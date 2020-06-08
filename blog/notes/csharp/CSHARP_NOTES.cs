// Для модели
[Column(Name="my_property")]

// SqlDataReader - How to convert the current row to a dictionary
return Enumerable.Range(0, reader.FieldCount).ToDictionary(reader.GetName, reader.GetValue);

// SqlDataReader
object value = null;
for (int i = 0; i < reader.FieldCount; i++)
{
    if (reader.IsDBNull(i))
    {
        value = "<NULL>";
    }
    else
    {
        value = reader.GetValue(i);
    }
    Console.WriteLine("{0}: {1} ({2})", reader.GetName(i), 
        value, reader.GetFieldType(i).Name);
}

// Обновить данные в Dictionary
row = row.ToDictionary(r => "P_" + r.Key, r => (r.Value == null || r.Value.ToString() == "") ? null : r.Value);

//Simplest way to form a union of two lists
var listB = new List<int>{3, 4, 5};  
var listA = new List<int>{1, 2, 3, 4, 5};
//If it is a list, you can also use AddRange method.
listA.AddRange(listB); // listA now has elements of listB also.
//If you need new list (and exclude the duplicate), you can use Union
var listFinal = listA.Union(listB);
//If you need new list (and include the duplicate), you can use Concat
var listFinal = listA.Concat(listB);
//If you need common items, you can use Intersect.
var listFinal = listA.Intersect(listB); //3,4

//how do access previous item in list?
var LinqList = list.Select( 
   (myObject, index) => 
      new { 
        ID = myObject.ID, 
        Date = myObject.Date, 
        Value = myObject.Value, 
        DiffToPrev = (index > 0 ? myObject.Value - list[index - 1].Value : 0)
      }
);

// Linq update
listOfCompany.Where(c=> c.id == 1).FirstOrDefault().Name = "Whatever Name";
listOfCompany.Where(c=> c.id == 1).ToList().ForEach(cc => cc.Name = "Whatever Name");

// How to convert C# nullable int to int
int? v1 = null;
int v2;
v2 = v1 ?? default(int);
v2 = v1.GetValueOrDefault();

// проверка на null
if (user != null && user.parent != null && user.parent.parent != null) {
    user.parent.parent.name = "Петя";
}
user?.parent?.parent?.name = "Петя";

// Установка значений по-умолчанию
var name = user != null && user.name != null ? user.name : "Петя";
var name = user?.name ?? "Петя";

// Cast dynamic dapper query
const string sql = @"SELECT Name, Street FROM Contact";
IEnumerable<dynamic> results = null;

using (var cn = Connection)
{
	results = cn.Query<dynamic>(sql);
}

foreach (var row in results)
{
	 var fields = row as IDictionary<string, object>;
	 // do something with fields["Name"] and fields["Street"]
}

// IsNumeric
private bool IsNumericType(Type type)
{
	switch (Type.GetTypeCode(type))
	{
		case TypeCode.Byte:
		case TypeCode.SByte:
		case TypeCode.UInt16:
		case TypeCode.UInt32:
		case TypeCode.UInt64:
		case TypeCode.Int16:
		case TypeCode.Int32:
		case TypeCode.Int64:
		case TypeCode.Decimal:
		case TypeCode.Double:
		case TypeCode.Single:
			return true;
		default:
			return false;
	}
}

// dictionary key exists
if (dict.ContainsKey(key)) { ... }

// elapsed time
using System.Diagnostics;
...
Stopwatch stopWatch = new Stopwatch();
stopWatch.Start();
...
stopWatch.Stop();
TimeSpan ts = stopWatch.Elapsed;
string elapsedTime = String.Format("{0:00}:{1:00}:{2:00}.{3:00}", ts.Hours, ts.Minutes, ts.Seconds, ts.Milliseconds / 10);
Console.WriteLine("RunTime " + elapsedTime);

// Get property value from string using reflection
 public static object GetPropValue(object src, string propName)
 {
     return src.GetType().GetProperty(propName).GetValue(src, null);
 }

// How to pass various derived classes of the same interface within a generic List as a parameter to the function?
public interface ControlPoint {}
public class Knot:  ControlPoint {}
public class Node:  ControlPoint {}
class Spline
{
List<Knot> knots=new List<Knot>();
List<Node> nodes=new List<Node>();
void Calculate(List<ControlPoint> points) {} //<------- Compiler Error
}
// Answer
void Calculate(IEnumerable<ControlPoint> points)
void Calculate<T>(List<T> points) where T : ControlPoint

// Check if a property exist in a class
public static bool HasProperty(this object obj, string propertyName)
{
    return obj.GetType().GetProperty(propertyName) != null;
}

// list where not in another list
var result = peopleList2.Where(p => !peopleList1.Any(p2 => p2.ID == p.ID));

// Даты
var str = ddate.ToString("dd.MM.yyyy");
var ddate = DateTime.Parse(value);
var beginDate = new DateTime(date.Year, date.Month, 1);
var endDate = beginDate.AddMonths(1);

// bin folder in ASP.NET Core
var location = System.Reflection.Assembly.GetEntryAssembly().Location;
var directory = System.IO.Path.GetDirectoryName(location);
System.Console.WriteLine(directory);
// C:\MyApplication\bin\Debug\netcoreapp2.0

/*
[FromHeader], [FromQuery], [FromRoute], [FromForm]
[FromBody]

-- PascalCase (default)
settings.ContractResolver = new DefaultContractResolver();
-- camelCase
settings.ContractResolver = new CamelCasePropertyNamesContractResolver();
*/


