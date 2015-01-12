### What is this?
**DB Data Compare** compares two database tables (or views) and highlights their differences.
Those two tables can be from the same database or from two distinct databases. The tables names can be distinct as well.

<br>
### Does it compare data or table schema?
Only compares table data.

<br>
### How to use it?
Before running the tool, you need to prepare:
 * One [UDL](http://msdn.microsoft.com/en-us/library/e38h511e%28v=vs.71%29.aspx) file pointing to the database you want to connect, if you want to compare tables from the same DB.
 * Two UDL files, in case you need to compare tables from two different databases.

<sub>Creating Universal Data Link files is very easy. The quickest way - on Windows - is to create an empty text document, change extension from `txt` to `udl` and double-click on it. You will be presented with a GUI that should be self explanatory. For more info, please check the link above.</sub>

Then, on the left side and right sides, select the UDL file and table you need to compare. You will be presented with the differences.
Here is an example:
![screenshoot](https://github.com/ruisoftware/DBDataCompare/blob/master/DBDataCompare.png)

<br>
### Why reinventing the wheel?
Well, I wrote this back in 2002 in one afternoon, using the beloved Delphi 7 at the time.
I couldn't find any tool quickly, so I decided to write my own.
As I said, this was done in less than 4 hours, so the tool is pretty raw in terms of GUI appearance, but is beautifully small.

