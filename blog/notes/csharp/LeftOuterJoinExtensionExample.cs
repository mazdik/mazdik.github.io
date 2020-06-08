using System;
using System.Collections.Generic;
using System.Linq;

namespace ConsoleAppCMD
{
    public static class ExtensionMethods
    {
        public static IEnumerable<TResult> LeftOuterJoin<TLeft, TRight, TKey, TResult>(
            this IEnumerable<TLeft> left,
            IEnumerable<TRight> right,
            Func<TLeft, TKey> leftKey,
            Func<TRight, TKey> rightKey,
            Func<TLeft, TRight, TResult> result)
        {
            return left.GroupJoin(right, leftKey, rightKey, (l, r) => new { l, r })
                 .SelectMany(
                     o => o.r.DefaultIfEmpty(),
                     (l, r) => new { lft = l.l, rght = r })
                 .Select(o => result.Invoke(o.lft, o.rght));
        }
    }

    class ModelTest2
    {
        public DateTime BeginDate { get; set; }
        public int CompanyId { get; set; }
        public int Value { get; set; }

        public override int GetHashCode()
        {
            int hashcode = BeginDate.GetHashCode();
            hashcode = 31 * hashcode + CompanyId.GetHashCode();
            return hashcode;
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj))
            {
                return false;
            }
            if (ReferenceEquals(this, obj))
            {
                return true;
            }
            if (obj.GetType() != typeof(ModelTest2))
            {
                return false;
            }
            return Equals((ModelTest2)obj);
        }

        public bool Equals(ModelTest2 other)
        {
            if (ReferenceEquals(null, other))
            {
                return false;
            }
            if (ReferenceEquals(this, other))
            {
                return true;
            }
            return BeginDate == other.BeginDate && CompanyId == other.CompanyId;
        }
    }

    class LeftOuterJoinExtensionExample
    {
        public static void Test()
        {
            var m1 = new ModelTest2
            {
                BeginDate = new DateTime(2017, 7, 1),
                CompanyId = 123,
                Value = 1
            };
            var m2 = new ModelTest2
            {
                BeginDate = new DateTime(2017, 7, 2),
                CompanyId = 123,
                Value = 2
            };
            var m3 = new ModelTest2
            {
                BeginDate = new DateTime(2017, 7, 3),
                CompanyId = 123,
                Value = 3
            };

            var n1 = new ModelTest2
            {
                BeginDate = new DateTime(2017, 7, 1),
                CompanyId = 123,
                Value = 100
            };
            var n2 = new ModelTest2
            {
                BeginDate = new DateTime(2017, 7, 2),
                CompanyId = 123,
                Value = 200
            };

            var t1 = new List<ModelTest2> { m1, m2, m3 };
            var t2 = new List<ModelTest2> { n1, n2 };

            var result = t1.LeftOuterJoin(t2,
                    p => new { p.BeginDate, p.CompanyId },
                    d => new { d.BeginDate, d.CompanyId },
                    (p, d) => new { p.BeginDate, p.CompanyId, Value = d?.Value ?? 0 }
                ).ToList();
            // override Equals in class
            result = t1.LeftOuterJoin(t2,
                p => p,
                d => d,
                (p, d) => new { p.BeginDate, p.CompanyId, Value = d?.Value ?? 0 }
            ).ToList();
        }
    }
}
