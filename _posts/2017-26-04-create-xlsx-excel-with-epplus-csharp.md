---
layout: post
title:  "Create Excels with C# and EPPlus: A tutorial"
date:   2017-04-26 22:00:00 +0200
categories: dotnet
tags: [net,excel]
---

Quick tutorial about creating xlsx Excels with
C# and the [EPPlus nuget package][epplus-nuget].

> EPPlus Excel addresses are not zero based: The first column is column 1!

<!--more-->

Did you know: It is a successor to ExcelPackage, hence the name.  
(this should come in a cool <aside>)

Setup
===========
```
Install-Package EEPlus
```

Examples
========
[All code examples][github-project] can be found in the GitHub project.

Basic Usage
-----------
```c#
using OfficeOpenXml;

using (var package = new ExcelPackage())
{
	ExcelWorksheet sheet1 = package.Workbook.Worksheets.Add("MySheet");
	ExcelRange firstCell = sheet1.Cells[1, 1]; // or use "A1"
	firstCell.Value = "will it work...";
	sheet1.Cells.AutoFitColumns();
	package.SaveAs(new FileInfo(@"basicUsage.xslx"));
}
```

Opening & Saving
----------------
Open an existing Excel, or if the file does not exist,
create a new one when `package.Save()` is called.
```c#
using (var package = new ExcelPackage(new FileInfo(@"openingandsaving.xslx"), "optionalPassword"))
using (var basicUsageExcel = File.Open(@"basicUsage.xslx"), FileMode.Open))
{
	var sheet = package.Workbook.Worksheets.Add("Sheet1");
	sheet.Cells["D1"].Value = "Everything in the package will be overwritten";
	sheet.Cells["D2"].Value = "by the package.Load() below!!!";

	// Loads the worksheets from BasicUsage
	// (MySheet with A1 = will it work...)
	package.Load(basicUsageExcel);

	package.Save("optionalPassword");
	//package.SaveAs(FileInfo / Stream)
	//Byte[] p = package.GetAsByteArray();
}
```

Selecting cells
---------------
```c#
using (var package = new ExcelPackage())
{
	ExcelWorksheet sheet1 = package.Workbook.Worksheets.Add("MySheet");

	// One cell
	ExcelRange cellA2 = sheet1.Cells["A2"];
	var alsoCellA2 = sheet1.Cells[2, 1];
	Assert.That(cellA2.Address, Is.EqualTo("A2"));
	Assert.That(cellA2.Address, Is.EqualTo(alsoCellA2.Address));

	// Column from a cell
	// ExcelRange.Start is the top and left most cell
	Assert.That(cellA2.Start.Column, Is.EqualTo(1));
	// To really get the column: sheet1.Column(1)

	// A range
	ExcelRange ranger = sheet1.Cells["A2:C5"];
	var sameRanger = sheet1.Cells[2, 1, 5, 3];
	Assert.That(ranger.Address, Is.EqualTo(sameRanger.Address));

	// Dimensions used
	Assert.That(sheet1.Dimension, Is.Null);

	ranger.Value = "pushing";
	var usedDimensions = sheet1.Dimension;
	Assert.That(usedDimensions.Address, Is.EqualTo(ranger.Address));

	package.SaveAs(new FileInfo(@""));
}
```

Writing Values
--------------
```c#
using (var package = new ExcelPackage())
{
	ExcelWorksheet sheet1 = package.Workbook.Worksheets.Add("MySheet");

	// Numbers
	sheet1.SetValue("A1", "Numbers");
	Assert.That(sheet1.GetValue<string>(1, 1), Is.EqualTo("Numbers"));
	sheet1.Cells["B1"].Value = 15.32;
	sheet1.Cells["B1"].Style.Numberformat.Format = "#,##0.00";
	Assert.That(sheet1.Cells["B1"].Text, Is.EqualTo("15.32"));

	// Money
	sheet1.Cells["A2"].Value = "Moneyz";
	sheet1.Cells["B2"].Value = 15000.23D;
	sheet1.Cells["C2"].Value = -2000.50D;
	sheet1.Cells["B2:C2"].Style.Numberformat.Format = "#,##0.00 [$€-813];[RED]-#,##0.00 [$€-813]";

	// DateTime
	sheet1.Cells["A3"].Value = "Timey Wimey";
	sheet1.Cells["B3"].Style.Numberformat.Format = "yyyy-mm-dd";
	sheet1.Cells["B3"].Formula = $"=DATE({DateTime.Now:yyyy,MM,dd})";
	sheet1.Cells["C3"].Style.Numberformat.Format = DateTimeFormatInfo.CurrentInfo.FullDateTimePattern;
	sheet1.Cells["C3"].Value = DateTime.Now;
	sheet1.Cells["D3"].Style.Numberformat.Format = "dd/MM/yyyy HH:mm";
	sheet1.Cells["D3"].Value = DateTime.Now;

	// A hyperlink
	sheet1.Cells["C25"].Formula = "HYPERLINK(\"mailto:support@pongit.be\",\"Contact support\")";
	sheet1.Cells["C25"].Style.Font.Color.SetColor(Color.Blue);
	sheet1.Cells["C25"].Style.Font.UnderLine = true;

	sheet1.Cells.AutoFitColumns();
	package.SaveAs(new FileInfo(@""));
}
```

Formatting
----------
```c#
using (var package = new ExcelPackage())
{
	ExcelWorksheet sheet1 = package.Workbook.Worksheets.Add("Styling");
	sheet1.TabColor = Color.Red;

	// Cells with style
	ExcelFont font = sheet1.Cells["A1"].Style.Font;
	sheet1.Cells["A1"].Value = "Bold and proud";
	sheet1.Cells["A1"].Style.Font.Name = "Arial";
	font.Bold = true;
	font.Color.SetColor(Color.Green);
	// ExcelFont also has: Size, Italic, Underline, Strike, ...

	sheet1.Cells["A3"].Style.Font.SetFromFont(new Font(new FontFamily("Arial"), 15, FontStyle.Strikeout));
	sheet1.Cells["A3"].Value = "SetFromFont(Font)";

	// Borders need to be made
	sheet1.Cells["A1:A2"].Style.Border.BorderAround(ExcelBorderStyle.Dotted);
	sheet1.Cells[5, 5, 9, 8].Style.Border.BorderAround(ExcelBorderStyle.Dotted);

	// Merge cells
	sheet1.Cells[5, 5, 9, 8].Merge = true;

	// More style
	sheet1.Cells["D14"].Style.ShrinkToFit = true;
	sheet1.Cells["D14"].Style.Font.Size = 24;
	sheet1.Cells["D14"].Value = "Shrinking for fit";

	sheet1.Cells["D15"].Style.WrapText = true;
	sheet1.Cells["D15"].Value = "A wrap, yummy!";
	sheet1.Cells["D16"].Value = "No wrap, ouch!";

	// Setting a background color requires setting the PatternType first
	sheet1.Cells["F6:G8"].Style.Fill.PatternType = ExcelFillStyle.Solid;
	sheet1.Cells["F6:G8"].Style.Fill.BackgroundColor.SetColor(Color.Red);

	// Horizontal Alignment needs a little workaround
	// http://stackoverflow.com/questions/34660560/epplus-isnt-honoring-excelhorizontalalignment-center-or-right
	var centerStyle = package.Workbook.Styles.CreateNamedStyle("Center");
	centerStyle.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
	sheet1.Cells["B5"].StyleName = "Center";
	sheet1.Cells["B5"].Value = "I'm centered";

	// MIGHT NOT WORK:
	sheet1.Cells["B6"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
	sheet1.Cells["B6"].Value = "I'm not centered? :(";

	package.SaveAs(new FileInfo(@""));
}
```

Converting indexes and ranges
-----------------------------
```c#
[Test]
public void ConvertingIndexesAndAddresses()
{
	Assert.That(ExcelCellBase.GetAddress(1, 1), Is.EqualTo("A1"));
	Assert.That(ExcelCellBase.IsValidCellAddress("A5"), Is.True);

	Assert.That(ExcelCellBase.GetFullAddress("MySheet", "A1:A3"), Is.EqualTo("'MySheet'!A1:A3"));

	Assert.That(ExcelCellBase.TranslateToR1C1("AB23", 0, 0), Is.EqualTo("R[23]C[28]"));
	Assert.That(ExcelCellBase.TranslateFromR1C1("R23C28", 0, 0), Is.EqualTo("$AB$23"));
}
```

[epplus-nuget]: https://www.nuget.org/packages/EPPlus/
[github-project]: https://github.com/be-pongit/EPPlusTutorial
