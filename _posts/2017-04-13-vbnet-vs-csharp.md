---
layout: post
title:  "VB.NET vs C# Syntax differences"
date:   2017-04-13 15:00:00 +0200
categories: dotnet
tags: [net]
---

TODO:
- Check against: https://learnxinyminutes.com/docs/powershell/
---> is the same stuff covered?



A quick cheat sheet outlining the syntax differences between VB.NET and C#.  
Because some things are just so similar but still confusingly different in VB.NET vs C#...

We'll also cover:
- Things VB.NET just can't do (pointers, ...)
- The few cases where VB.NET code is *shorter* than it's C# counterpart (gasp!)
- Dangers of using some of the VB6 legacy (My, Option Strict)
- Some VB.NET only stuff that comes in handy from time to time


This post assumes familiarity with C#.



Confusingly Different
---------------------
Or some fun issues during heavy context switching :)

- Terminating statements with `;` in VB.NET or not using `_` for line continuations.
- Compare with `=` in C# or with `==` in VB.NET (and `!=` vs `<>`)
- VB.NET is *not* case sensitive



Syntax comparison
-----------------

### General syntax

```vb
' VB.NET
#If DEBUG Then
#End If
#Region "Imports"
Imports System
#End Region
Namespace MyApp
	<Serializable>
	Public Class HappyCoding
		''' <summary>
		''' XML Comment
		''' </summary>
		Shared Sub Main(ByVal args() As String)
			Dim name As String = "VB.NET"
			Dim builder As New StringBuilder()

			' "X"c for defining a char
			builder.Append("A"c)

			' Parentheses are optional when calling
			' a method without parameters
			' Array accessor is with parentheses (), not with []
			' All this allows for "fun" like this:
			Dim firstChar = builder.ToString.ToArray(0)
		End Sub
	End Class
End Namespace
```

C# equivalent

```c#
#if DEBUG
#endif
#region usings
using System;
#endregion
namespace MyApp {
	[Serializable]
	public class HappyCoding {
		/// <summary>
		/// XML Comment
		/// </summary>
		static void Main(string[] args) {
			string name = "C#";
			var builder = new StringBuilder();
			builder.Append('A');
			char firstChar = builder.ToString().ToArray()[0];
		}
	}
}
```

### Data Types

| VB.NET                              | C#
|-------------------------------------|--------------------------|
| Dim b As Byte = &H2A                | byte b = 0x2A;
| Dim c As Char = "B"c                | char c = 'c';
| Dim d As Decimal = 35.99@           | decimal d = 35.99m;
| Dim f As Single = 2.9!              | float f = 2.9f;
| Dim pi As Double = 3.1415           | double pi = 3.1415D;
| Dim lng As Long = 123456L ' UL      | long lng = 123456L; // UL
| Dim s As Short = 123S ' US          | short s = 123;
|                                     |
| Dim i? As Integer = Nothing         | int? i = null;
| Dim i As Integer?                   | int? i;
|-------------------------------------|--------------------------|
{: .table-code}

```vb
Dim d As Date = #10/15/2005# ' C#: var d = new DateTime(2005, 10, 15)
Dim dt As DateTime = #10/15/2005 12:15:00 PM#
```

This compiles!? How cool is VB.NET :)  
A VB.NET `Date` is in fact an alias for `DateTime`. 
So yes, `Date` does have a time part.



### Type Information

| VB.NET                          | C#
|---------------------------------|---------------------------------|
| Dim x As Integer                | int x;
| x.GetType()                     | x.GetType();
| GetType(Integer)                | typeof(int);
| TypeName(x)                     | x.GetType().Name;
| NameOf(StringBuilder)           | nameof(StringBuilder)
|                                 |                                 |
| Dim lng = CType(x, Long)        | var lng = Convert.ToInt64(x);
| Dim lng = CLng(x)               | var lng = Convert.ToInt64(x);
| Dim i = Int(x)                  | var i = Conversion.Int(x);
|                                 |                                 |
| Dim s As New Shape              | var s = new Shape();
| TypeOf s IsNot Circle           | !(s is Circle)
| s1 Is s2                        | Object.ReferenceEquals(s1, s2)
| Dim c = TryCast(s, Circle)      | var c = s as Circle;
| c = DirectCast(s, Circle)       | c = (Circle)s;
|                                 |                                 |
{: .table-code}

Aside from CLng, VB.NET also has: CInt, CDate, CStr, CByte, CDbl, CBool, CObj, Chr.
And more conversion methods in `Microsoft.VisualBasic.Conversion`. This is a Module
so `Conversion.Int(x)` is available as `Int(x)` without Import.


### Operators, Strings

| VB.NET                          | C#
|---------------------------------|---------------------------------|
| Comparison
| <> =  <  >  <=  >=              | != ==  <  >  <=  >=  
| And   Or   Xor   Not   <<   >>  | &   \|   ^   ~   <<   >>
| AndAlso   OrElse  Not           | &&   \|\|   !
| x Is Nothing Or y IsNot Nothing | x == null \| y != null
|
| Arithmetic
| +  -  *  /                      | Same
| Mod                             | %
| \  (integer division)           | 
| ^  (raise to a power)           | Math.Pow
|
| Assignment
| =  +=  -=, ...                  | = += -=
|                                 | ++ --
|
| Strings
| Concatenation: &                | +
| Quote: ""                       | \"
| vbCrLf, vbTab, ...              | \r\n, \t, ...
|                                 |                                 |
{: .table-margin}


All logical comparisons in VB.NET are typically done with `AndAlso` and `OrElse`.
It's (surprise surprise) more typing than `And/Or` but the latter don't short-circuit
the evalusations. Ex: `If x IsNot Nothing And x.Trigger() Then` will crash.


### Control flow

| VB.NET                          | C#
|---------------------------------|---------------------------------|
| Dim i = If(y, 5)                | var i = y ?? 5;
| Dim x = If(i > 0, "t", "f")     | var x = i > 0 ? "t" : "f"
|                                 |                                 |
{: .table-code}



```vb
If x < 0 Then res = "oeps" Else res = "yaye"

If x > 5 Then
  x *= y
ElseIf x = 5 OrElse y Mod 2 = 0 Then
  x += y
Else
  x /= y
End If

' Microsoft.VisualBasic.CompilerServices.LikeOperator.LikeString
' Uses: Option Compare Binary/Text
If "John 3:16" Like "Jo[Hh]? #:*" Then
	' Use [!A-Z] for Regex [^A-Z]
	' VB.NET Like => Regex
	' # => \d, * => .*, ? => .
End If
' C#: Use Regex

' VB.NET switch is more feature rich
Select Case x
	Case 1, 2, 5 To 10
	Case Is = y ' Is is optional
	Case Is > 10
	Case Else
End Select

Select Case x.GetType
	Case GetType(StringBuilder)
End Select

For i As Integer = 0 To arr.Length - 1 Step 3
	' Step 1 is the default
Next
// C#: for (i = 0; i < arr.Length; i += 3) {}

For Each n As String In names
	Exit For
	Continue For
Next

// C#
foreach (sting n in names) {
	break;
	continue;
}
```





### Classes, Generics, Methods, Enums, ...

| VB.NET                 | C#
|----------------------  |---------------------------------|
| Public                 | public
| Private                | private
| Friend                 | internal
| Protected              | protected
|                        |                                 |
| Partial Class          | partial class
| MustInherit Class      | abstract class
| NotInheritable Class   | sealed class
| Module                 | static class
|                        |                                 |
| Methods
| MustOverride           | abstract
| NotInheritable         | sealed
| Shared                 | static
| Overridable            | virtual
| Overloads ' is optional| // no keyword required
|                        |                                 |
{: .table-code}


```vb
Interface IAlarm
	Property WakeUpAt As DateTime
End Interface

Structure Student
End Structure

Enum Action
	Start = 1
	[Stop] ' Escape reserved words with []
End Enum
' enum Action {Start = 1, Stop}

Class MyColl(Of TEntity)
	Inherits ObjectModel.Collection(Of TEntity)
	Implements IDisposable, IAlarm
	' Class MyCall<TEntity> : Collection<TEntity>, IDisposable, IAlarm

	ReadOnly MinInt As Integer = 0.5
	Const MaxInt As Integer = 25

	Public Property WakeUpAt As Date Implements IAlarm.WakeUpAt
	' public DateTime WakeUpAt { get; set; }

	Public Sub New()
		' : this(DateTime.Now)
		Me.New(DateTime.Now)
	End Sub

	Public Sub New(ByVal time As Date)
		' : base()
		MyBase.New()
	End Sub

	Shared Sub New()
		' static constructor
	End Sub

	Protected Overrides Sub Finalize()
		' C# "destructor": ~MyColl() {}
		MyBase.Finalize()
	End Sub

	' Default value, Get and Set both Public
	Public Property Size As Integer = -1

	Private _name As String
	Public Property Name As String
		Get
			Return _name
		End Get
		Protected Set(ByVal value As String)
			_name = value
		End Set
	End Property

	' WriteOnly for setter only
	Public ReadOnly Property Name As String
		Get
			Return _name
		End Get
	End Property

	Shared Function Max(Of T As {IComparable, Structure})(ByVal ParamArray items As T()) As T
		' static T Max<T>(params T[] items) where T : IComparable, struct
		' Assign to Function name instead of Return items.Max
		Max = items.Max
	End Function

	Protected Friend Function Yaye(Optional b As Boolean = True) As Boolean
		Static entered As Integer
		' Will increase with 1 each time the method is called
		entered += 1
		Return True
	End Function

	Private Function Yaye(Of Q As New)(ByRef b As String) As Q
		' private Q Yaye<Q>(ref string b) where Q : new()
		' VB.NET has no Out, only ByRef
		Return new Q()
	End Function

	Private Function YayeCaller() As Integer
		' Can pass a Property As ByRef
		Return Me.Yaye(Of Integer)(Name)
	End Function
End Class
```


```

```

```vb

```


### Linq, Lambdas and Anonymous Types

```vb
Delegate Sub MsgArrivedEventHandler(ByVal message As String)

Event MsgArrivedEvent As MsgArrivedEventHandler

' or to define an event which declares a delegate implicitly
Event MsgArrivedEvent(ByVal message As String)

AddHandler MsgArrivedEvent, AddressOf My_MsgArrivedCallback 
' Won't throw an exception if obj is Nothing
RaiseEvent MsgArrivedEvent("Test message") 
RemoveHandler MsgArrivedEvent, AddressOf My_MsgArrivedCallback
Imports System.Windows.Forms

Dim WithEvents MyButton As Button   ' WithEvents can't be used on local variable
MyButton = New Button

Sub MyButton_Click(ByVal sender As System.Object, _
  ByVal e As System.EventArgs) Handles MyButton.Click 
  MessageBox.Show(Me, "Button was clicked", "Info", _
    MessageBoxButtons.OK, MessageBoxIcon.Information) 
End Sub
```


**Anonymous Types**:
```vb
Dim stu = New With {Key .Name = "Sue", .Gpa = 3.4}
' var stu2 = new {Name = "Sue", Gpa = 3.5};
```

C# doesn't have `Key` which is used for comparisons: `stu.Equals(stu2)`.  
VB.NET without the `Key` keyword and C# consider two anonymous types to be
equal if all their properties are equal.



### Initializers

| VB.NET                                     | C#
|--------------------------------------------|--------------------------------------------|
| Dim nums = New Integer() {1, 2, 3}         | int[] nums = new[] {1, 2, 3};
| Dim nums() As Integer = {1, 2, 3}
| Dim names(4) As String ' 5 elements        | var names = new string[5];
| ReDim Preserve names(6) ' Preserve optional| Array.Resize(ref names, 7);
| -------------------------------------------| -------------------------------------------|
| Dim h = New Hero With {.Name = "Deadpool"} | var h = new Hero() {Name = "Deadpool"};
|--------------------------------------------|--------------------------------------------|
{: .table-code}

TODO: Initializers: Dictionary, Array, List, ...







### Other

**Exception Handling**:
```vb
Try
Catch ex As ArgumentException When ex.ParamName = NameOf(Name)
	' No C# equivalent for When
	Throw
Catch ex As Exception
Finally
	Throw New Exception()
End Try
```

**Extension Methods**:
```vb
Module StringExtensions
	<Extension()>
	Public Function Vowels(ByVal s As String) As Integer
		' public static int Vowels(this string s) {}
		Return s.Count(Function(c) "aeiou".Contains(Char.ToLower(c)))
	End Function
End Module
```

**Using**:
```vb
Using r As StreamReader = File.OpenText("file.txt")
End Using
```



Dangers of VB6 Legacy
---------------------
A new VB.NET project starts with `Option Strict Off` and `Option Explicit Off`. This is bad.  
... Unless you are a JavaScript developer, then you can just continue to do whatever you want!

```vb
' VB.NET
Dim name = "string"
name = 15
' name is now an integer or a string.. depending whether `Option Infer` is On or Off.
uhoh = 20 ' With `Option Explicit Off` this *will* compile.

// C# equivalent
object name = "string";
```

That's obviously not what one wants. Emulating C#'s `var name = "str"` behavior can be achieved
by turning `Option Strict On` and `Option Infer On` in the Project Properties Compile tab.

### Stuff that was imported from VB6

They are listed here, but you may skip this part and pretend it never happened.

```vb
Dim s = Mid("testing", 2, 3)   ' est

' IIf always evaluates both branches. Use If() instead!
Dim result = IIf(someBool, "truthyCase", "falsyCase")

' Multiple statements on one line.
If True Then s = "1": s = "2"

' Who wouldn't want a good ol' GoTo in their code base
On Error GoTo MyErrorHandler
MyErrorHandler: Console.WriteLine(Err.Description)
```



Available in C# only
--------------------

unsafe/pointers, checked/unchecked

**Other**:  
- Multi line comments
- 



Available in VB.NET only
------------------------

```vb
Delegate Sub HelloDelegate(ByVal s As String)
Sub SayHello(ByVal s As String)
	Console.WriteLine("Hello, " & s)
End Sub

' Create delegate that calls SayHello
Dim hello As HelloDelegate = AddressOf SayHello




With hero 
  .Name = "SpamMan" 
  .PowerLevel = 3 
End With 
```


- XML Literals
- WithEvents
- Handles Me.Load --> can just delete an EventHandler without having to delete any AddHandler
Firing of events is done with the RaiseEvent keyword, giving the IDE the chance to show a list of available events to pick from. RaiseEvents implicitly checks if there are any event handlers wired up. (in C# raising an event is syntactically identical to calling a procedure, and it requires an additional line of code to check for wired event handlers)




Local variables can be declared with the Static modifier in order to preserve their value between calls to the procedure.
Multiple default property indexers
My namespace



https://en.wikipedia.org/wiki/Comparison_of_C_Sharp_and_Visual_Basic_.NET



Convertion troubles
-------------------
While there are some online converters, they are not at all up to date, or very smart.
- [Carlosag converter][converter-carlosag]
- [Telerik converter][converter-telerik] <- If you must, take this one

They do not provide much more than a starting point.

- Using an array accessor in VB.NET (`arr(0)` vs `arr[0]`) results in an incorrect translation
- "Newer" features, like lambdas are converted to dynamic, or not at all
- Use any VB.NET or C# only feature and they won't even try to write some convertion code



Summary
-------
**So what's best :)**

VB.NET used to be lacking many convenient C# features. While it has mostly catched up, C# proves to be a moving target.

Properties used to be a real pain in VB.NET. A one liner syntax is now available like
`Property Start As Date`. But by now C# already introduced property expression bodies
and VB.NET can start catching up again.

For a long time VB.NET switch statement used to be more versatile but with the implementation of Pattern Matching
in C# this is no longer the case.

Lambda syntax like `o.Where(Function(x As Integer) x < 0)` isn't going to win any prizes when camped against
C#'s `o.Where((int x) => x < 0)`... But at least it's there :)

I'm probably a *little* biased towards C# because of the more succint syntax and because the vast majority of
online examples are written in C# while the free convertion tools are severly lacking.

Unless you really need some of the VB.NET or C# only features, choosing one over the other should probably
still be a team decision.




[converter-carlosag]: http://www.carlosag.net/tools/codetranslator/
[converter-telerik]: http://converter.telerik.com/
