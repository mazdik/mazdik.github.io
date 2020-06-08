using System;
using System.Collections.Generic;
using System.Linq;

namespace Test
{
    class ModelTest2
    {
        public DateTime BEGIN_DATE { get; set; }
        public DateTime? END_DATE { get; set; }
        public int RN { get; set; }
    }

    class Test2
    {

        public static void LeftOuterJoinExample()
        {
            var m1 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 7, 7),
                END_DATE = new DateTime(2017, 8, 16),
                RN = 1
            };
            var m2 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 8, 16),
                END_DATE = new DateTime(2017, 8, 17),
                RN = 2
            };
            var m3 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 8, 17),
                END_DATE = null,
                RN = 3
            };

            var n1 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 7, 17),
                END_DATE = new DateTime(2017, 8, 15),
                RN = 1
            };
            var n2 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 8, 15),
                END_DATE = new DateTime(2017, 8, 16),
                RN = 2
            };
            var n3 = new ModelTest2
            {
                BEGIN_DATE = new DateTime(2017, 8, 16),
                END_DATE = null,
                RN = 3
            };

            var t1 = new List<ModelTest2> { m1, m2, m3 };
            var t2 = new List<ModelTest2> { n1, n2, n3 };

            foreach (var v in t1)
            {
                Console.WriteLine($"{v.BEGIN_DATE} {v.END_DATE} {v.RN}");
            }
            foreach (var v in t2)
            {
                Console.WriteLine($"{v.BEGIN_DATE} {v.END_DATE} {v.RN}");
            }
            /*
             Нужен такой результат
            1	01.08.2017 00:00:00	07.07.2017 8:30:21	16.08.2017 8:30:21	1	17.07.2017 8:30:21	15.08.2017 8:30:21	1
            2	15.08.2017 8:30:21	07.07.2017 8:30:21	16.08.2017 8:30:21	1	15.08.2017 8:30:21	16.08.2017 8:30:21	2
            3	16.08.2017 8:30:21	16.08.2017 8:30:21	17.08.2017 8:30:21	2	16.08.2017 8:30:21	None				3
            4	17.08.2017 8:30:21	17.08.2017 8:30:21	None				3	16.08.2017 8:30:21	None				3
            */

            // Список уникальных дат и сортировка
            DateTime beginDate = new DateTime(2017, 8, 1);
            DateTime endDate = beginDate.AddMonths(1);
            var uniqueItemsList = t1.Concat(t2).Select(x => x.BEGIN_DATE).Distinct().ToList();
            uniqueItemsList.Add(beginDate);
            var uniqueDates = uniqueItemsList.Distinct().ToList();
            uniqueDates.Sort();
            // Отбрасываем лишние даты
            uniqueDates = uniqueDates.Where(x => x >= beginDate && x < endDate).ToList();
            // Добавляем колонки key
            var pud = uniqueDates.Select(x => new { DATE = x, KEY = 0 }).ToList();
            var pt1 = t1.Select(x => new { x.BEGIN_DATE, x.END_DATE, x.RN, KEY = 0 }).ToList();
            var pt2 = t2.Select(x => new { x.BEGIN_DATE, x.END_DATE, x.RN, KEY = 0 }).ToList();
            // left outer join
            var dataAll = from c in pud
                          from p1 in pt1.Where(x => x.KEY == c.KEY && c.DATE >= x.BEGIN_DATE && (c.DATE < x.END_DATE || x.END_DATE == null))
                          .DefaultIfEmpty()
                          from p2 in pt2.Where(x => x.KEY == c.KEY && c.DATE >= x.BEGIN_DATE && (c.DATE < x.END_DATE || x.END_DATE == null))
                          .DefaultIfEmpty()
                          select new
                          {
                              c.KEY,
                              BEGIN_DATE = c.DATE,
                              END_DATE = "",
                              BEGIN_DATE1 = p1.BEGIN_DATE,
                              END_DATE1 = p1.END_DATE,
                              RN1 = p1.RN,
                              BEGIN_DATE2 = p2.BEGIN_DATE,
                              END_DATE2 = p2.END_DATE,
                              RN2 = p2.RN
                          };
            //var data = dataAll.Where(x => x.BEGIN_DATE >= x.BEGIN_DATE1 && (x.BEGIN_DATE < x.END_DATE1 || x.END_DATE1 == null))
            //    .Where(x => x.BEGIN_DATE >= x.BEGIN_DATE2 && (x.BEGIN_DATE < x.END_DATE2 || x.END_DATE2 == null)).ToList();
            var data = dataAll.ToList();
            // LEAD(DATE,1,NULL) OVER (ORDER BY DATE ASC) AS END_DATE
            var res = data.Select((obj, index) => new
            {
                obj.KEY,
                obj.BEGIN_DATE,
                END_DATE = (index + 1 < data.Count ? data[index + 1].BEGIN_DATE : endDate),
                obj.BEGIN_DATE1,
                obj.END_DATE1,
                obj.RN1,
                obj.BEGIN_DATE2,
                obj.END_DATE2,
                obj.RN2
            }).ToList();

            foreach (var v in res)
            {
                Console.WriteLine("{0:d}-{1:d} | {2:d}-{3:d} | {4:d}-{5:d}",
                    v.BEGIN_DATE, v.END_DATE, v.BEGIN_DATE1, v.END_DATE1, v.BEGIN_DATE2, v.END_DATE2);
            }

        }

    }

}
