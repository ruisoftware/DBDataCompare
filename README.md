### What is this?
**DB Data Compare** compares two database tables (or views) and highlights their differences.
Those two tables can be from the same database or from two distinct databases. The tables names can be distinct as well.

<br>
### Does it compare data or table schema?
Only compares table data.

<br>
### How to use it?
Before running the tool, you need to prepare either
 * One [UDL](http://msdn.microsoft.com/en-us/library/e38h511e%28v=vs.71%29.aspx) file pointing to the database you want to connect, in case you need to compare tables from the **same database**.<br>
 or
 * Two UDL files, in case you need to compare tables from two **different databases**.

<sub>Creating Universal Data Link files is very easy. The quickest way - on Windows - is to create an empty text document, change extension from `txt` to `udl` and double-click on it. You will be presented with a GUI that should be self explanatory. For more info, please check the link above.</sub>

Then, on the left side and right sides, select your UDL files and the tables you want to compare. You will be presented with the differences.

In the example below, we are checking the data differences on the `DocPaper` table from two databases (`GoldDB.url` and `GoldLaDB.udl`).
![screenshoot](https://github.com/ruisoftware/DBDataCompare/blob/master/DBDataCompare.png)

You can see that they differ in the Key for `Ticket` and that the `GoldLaDB.DocPaper` table contains an extra record.

<br>
### Why reinventing the wheel?
Well, I wrote this back in 2002 in one afternoon, using the beloved Delphi 7 at the time.
I couldn't find any tool quickly, so I decided to write my own.<br>
As I said, this was done just to satisfy my needs back then, so the tool is pretty raw in terms of GUI appearance and performance, but is beautifully small.

<br>
### Future plans?
Nope. I no longer work with Delphi and just decided to create this repository to post some of my old code, instead of being lost in some forgotten hard drive. Hopefully might help other users.

