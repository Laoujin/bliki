---
layout: post
title:  "Create Excels with C# and EPPlus: Formulas & DataValidation"
date:   2017-04-27 12:00:00 +0200
categories: dotnet
tags: [net,excel]
---

In case your users want to continue working with the Excels after generation.

Not a problem for EPPlus. Instead of calculating values and writing them to
an excel, leverage the power of Excel formulas.

<!--more-->

Formulas
--------
```c#
using (var package = new ExcelPackage())
{
	var sheet = package.Workbook.Worksheets.Add("Formula");

	// The project contains code that actually adds some data to the sheet. Assumed data:
	// Id, Product, Quantity, Price, Base total, Discount, Total, Special discount, Payup
	// The data values:
	//yield return new Sell("Nails", 3.99M, 37);
	//yield return new Sell(name: "Hammer", price: 12.10M, quantity: 5, discount: 0.1M);
	//yield return new Sell("Saw", 15.37M, 12);

	// Starting = is optional
	sheet.Cells["A5"].Formula = "=COUNT(A2:A4)";

	// Total column
	sheet.Cells["E2:E4"].Formula = "C2*D2"; // quantity * price
	Assert.That(sheet.Cells["E2"].FormulaR1C1, Is.EqualTo("RC[-2]*RC[-1]"));
	Assert.That(sheet.Cells["E4"].FormulaR1C1, Is.EqualTo("RC[-2]*RC[-1]"));

	// Total - discount column
	// Calculate formulas before they are available in the sheet
	// (Opening an Excel with Office will do this automatically)
	sheet.Cells["G2:G4"].Formula = "IF(ISBLANK(F2),E2,E2*(1-F2))";
	Assert.That(sheet.Cells["G2"].Text, Is.Empty);
	sheet.Calculate();
	Assert.That(sheet.Cells["G2"].Text, Is.Not.Empty);

	// Total row
	// R1C1 reference style
	sheet.Cells["E5"].FormulaR1C1 = "SUBTOTAL(9,R[-3]C:R[-1]C)"; // total
	Assert.That(sheet.Cells["E5"].Formula, Is.EqualTo("SUBTOTAL(9,E2:E4)"));
	sheet.Cells["G5"].FormulaR1C1 = "SUBTOTAL(9,R[-3]C:R[-1]C)"; // total - discount
	Assert.That(sheet.Cells["G5"].Formula, Is.EqualTo("SUBTOTAL(9,G2:G4)"));

	sheet.Calculate();
	sheet.Cells["I2:I5"].Formula = "G2*(1-$H$5)"; // Pin H5

	package.SaveAs(new FileInfo(@""));
}
```

**SUBTOTAL**:  
SUBTOTAL(9,...), as apposed to using SUM directly, will not include other subtotals in their calculation.

```vba
SUBTOTAL(FUNC_NUM,ref1,[ref2],...)
```

Add 100 to FUNC_NUM to ignore manually hidden rows.
Filtered-out rows are always excluded.

| FUNC_NUM | Function name | Desc
|----------|---------------|-----
| 1        | AVERAGE
| 2        | COUNT         | Counts how many numbers
| 3        | COUNTA        | Counts how many values
| 4        | MAX
| 5        | MIN
| 6        | PRODUCT
| 7        | STDEV         | Estimates standard deviation based on a sample
| 8        | STDEVP        | Calculates standard deviation based on the entire population
| 9        | SUM
| 10       | VAR           | Estimates variance based on a sample
{: .table-code}


DataValidation
--------------
**Dropdownlists**:  
```c#
using (var package = new ExcelPackage())
{
	var sheet = package.Workbook.Worksheets.Add("Validation");

	var list1 = sheet.Cells["C7"].DataValidation.AddListDataValidation();
	list1.Formula.Values.Add("Apples");
	list1.Formula.Values.Add("Oranges");
	list1.Formula.Values.Add("Lemons");

	# Or load from another sheet
	//package.Workbook.Worksheets.Add("OtherSheet");
	//list1.Formula.ExcelFormula = "OtherSheet!A1:A4";

	list1.ShowErrorMessage = true;
	list1.Error = "We only have those available :(";

	list1.ShowInputMessage = true;
	list1.PromptTitle = "Choose your juice";
	list1.Prompt = "Apples, oranges or lemons?";

	list1.AllowBlank = true;

	sheet.Cells["C7"].Value = "Pick";
	sheet.Cells["C7"].Style.HorizontalAlignment = ExcelHorizontalAlignment.Right;
	package.SaveAs(new FileInfo(@""));
}
```

**Integer & DateTime validation**:  
```c#
using (var package = new ExcelPackage())
{
	var sheet = package.Workbook.Worksheets.Add("intsAndSuch");

	// Integer validation
	IExcelDataValidationInt intValidation = sheet.DataValidations.AddIntegerValidation("A1");
	intValidation.Prompt = "Value between 1 and 5";
	intValidation.Operator = ExcelDataValidationOperator.between;
	intValidation.Formula.Value = 1;
	intValidation.Formula2.Value = 5;

	// DateTime validation
	IExcelDataValidationDateTime dateTimeValidation = sheet.DataValidations.AddDateTimeValidation("A2");
	dateTimeValidation.Prompt = "A date greater than today";
	dateTimeValidation.Operator = ExcelDataValidationOperator.greaterThan;
	dateTimeValidation.Formula.Value = DateTime.Now.Date;

	// Time validation
	IExcelDataValidationTime timeValidation = sheet.DataValidations.AddTimeValidation("A3");
	timeValidation.Operator = ExcelDataValidationOperator.greaterThan;
	var time = timeValidation.Formula.Value;
	time.Hour = 13;
	time.Minute = 30;
	time.Second = 10;

	// Existing validations
	var validations = package.Workbook.Worksheets.SelectMany(sheet1 => sheet1.DataValidations);

	package.SaveAs(new FileInfo(BinDir.GetPath()));
}
```
