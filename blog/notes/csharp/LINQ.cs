string[] names = {"Adams", "Arthur", "Buchanan", "Bush", "Carter", "Cleveland"};

//Синтаксис выражений запросов
IEnumerable<string> sequence = from n in names
								 where n.Length < 6
								 select n;    
 
//Синтаксис точечной нотации
IEnumerable<string> sequence = names
	.Where(n => n.Length < 6)
	.Select(n => n);

//именнованный метод
int[] oddNums = Common.FilterArrayOfInts(nums, Application.IsOdd);
//анонимный метод
int[] oddNums = Common.FilterArrayOfInts(nums, delegate(int i) { return ((i & 1) == 1); });
//лямбда-выражение
int[] oddNums = Common.FilterArrayOfInts(nums, i => ((i & 1) == 1) );
