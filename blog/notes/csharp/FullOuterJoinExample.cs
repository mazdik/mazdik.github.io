using System;
using System.Collections.Generic;
using System.Linq;

namespace Test
{

    public static class ExtensionMethods
    {
        public static IEnumerable<TResult> FullOuterJoin<TLeft, TRight, TKey, TResult>(
            this IEnumerable<TLeft> leftItems,
            IEnumerable<TRight> rightItems,
            Func<TLeft, TKey> leftKeySelector,
            Func<TRight, TKey> rightKeySelector,
            Func<TLeft, TRight, TResult> resultSelector)
        {
            var leftJoin =
                from left in leftItems
                join right in rightItems
                  on leftKeySelector(left) equals rightKeySelector(right) into temp
                from right in temp.DefaultIfEmpty()
                select resultSelector(left, right);

            var rightJoin =
                from right in rightItems
                join left in leftItems
                  on rightKeySelector(right) equals leftKeySelector(left) into temp
                from left in temp.DefaultIfEmpty()
                select resultSelector(left, right);

            return leftJoin.Union(rightJoin);
        }
    }

    class ModelTest3
    {
        public long WellId { get; set; }
        public string LayerId { get; set; }
        public DateTime BeginDate { get; set; }
        public DateTime? EndDate { get; set; }
        public int? Rn { get; set; }
    }

    class Test3
    {
        public static void FullOuterJoinExample()
        {
            var m1 = new ModelTest3
            {
                WellId = 123,
                LayerId = "PL0001",
                BeginDate = new DateTime(2017, 7, 7),
                EndDate = new DateTime(2017, 8, 16),
                Rn = null
            };
            var m2 = new ModelTest3
            {
                WellId = 123,
                LayerId = "PL0001",
                BeginDate = new DateTime(2017, 8, 16),
                EndDate = new DateTime(2017, 8, 17),
                Rn = 2
            };
            var n1 = new ModelTest3
            {
                WellId = 123,
                LayerId = "PL0001",
                BeginDate = new DateTime(2017, 7, 7),
                EndDate = new DateTime(2017, 8, 16),
                Rn = 111
            };

            var t1 = new List<ModelTest3> { m1 };
            var t2 = new List<ModelTest3> { n1 };
            var result = new List<ModelTest3>();

            if (t1.Count == 0 && t2.Count > 0)
            {
                result = t2;
            }
            if (t2.Count == 0 && t1.Count > 0)
            {
                result = t1;
            }
            if (t1.Count > 0 && t2.Count > 0)
            {
                var res = t1.FullOuterJoin(t2, lKey => new { lKey.WellId, lKey.LayerId }, rKey => new { rKey.WellId, rKey.LayerId },
                       (left, right) => new ModelTest3()
                       {
                           WellId = (left == null || left.WellId == 0) ? right.WellId : left.WellId,
                           LayerId = (left == null || String.IsNullOrEmpty(left.LayerId)) ? right.LayerId : left.LayerId,
                           BeginDate = (left == null || left.BeginDate == null) ? right.BeginDate : left.BeginDate,
                           EndDate = (left == null || left.EndDate == null) ? right.EndDate : left.EndDate,
                           Rn = (left == null || left.Rn == null || left.Rn == 0) ? right.Rn : left.Rn,
                       }
                );
                result = (res.GroupBy(x => new { x.WellId, x.LayerId, x.BeginDate }).Select(g => g.First())).ToList();
            }
        }

        public static void ResultSelector(ModelTest3 left, ModelTest3 right)
        {
            ModelTest3 result = new ModelTest3();
            Type t = typeof(ModelTest3);
            var properties = t.GetProperties().Where(prop => prop.CanRead && prop.CanWrite);

            foreach (var prop in properties)
            {
                var leftValue = prop.GetValue(left, null);
                var rightValue = prop.GetValue(right, null);
                if (leftValue != null)
                {
                    prop.SetValue(result, leftValue, null);
                } else
                {
                    prop.SetValue(result, rightValue, null);
                }
            }
        }

        public void printPropreties() {
            Type t = typeof(ModelTest3);
            // только геттеры
            var properties = t.GetProperties().Where(prop => prop.CanRead && !prop.CanWrite);
            foreach(var prop in properties) {
                Console.WriteLine("{0} = g.Sum(x => x.{0}),", prop.Name);
            }
        }

    }
}
