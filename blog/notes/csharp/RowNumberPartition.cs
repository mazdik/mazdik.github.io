using System;
using System.Collections.Generic;
using System.Linq;

namespace Itsk.Mer.Shell
{
    class RowNumberPartition
    {
        public static void Test()
        {
            var beatles = (new[] { new { id=1 , inst = "guitar" , name="john" },
                new { id=2 , inst = "guitar" , name="george" },
                new { id=3 , inst = "guitar" , name="paul" },
                new { id=4 , inst = "drums" , name="ringo" },
                new { id=5 , inst = "drums" , name="pete" }
            });

            // ROW_NUMBER() OVER (PARTITION BY inst ORDER BY id) AS rn
            var result = beatles.OrderBy(x => x.id).GroupBy(x => x.inst)
                           .Select(g => new { g, count = g.Count() })
                           .SelectMany(t => t.g.Select(b => b)
                           .Zip(Enumerable.Range(1, t.count), (j, i) => new { j.inst, j.name, rn = i }));

            var result2 = beatles
                        .GroupBy(g => g.inst)
                        .Select(c => c.OrderBy(o => o.id).Select((v, i) => new { i, v }).ToList())
                        .SelectMany(c => c)
                        .Select(c => new { c.v.id, c.v.inst, c.v.name, rn = c.i + 1 })
                        .ToList();

            foreach (var i in result2)
            {
                Console.WriteLine("{0} {1} {2}", i.inst, i.name, i.rn);
            }

            /*
             id |   inst   |   name  | rn
            -----------------------------
             1 |  guitar  |  john   | 1
             2 |  guitar  |  george | 2
             3 |  guitar  |  paul   | 3
             4 |  drums   |  ringo  | 1
             5 |  drums   |  pete   | 2
             */
        }
    }
}
