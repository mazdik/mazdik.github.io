using System;
using System.Collections.Generic;
using System.Linq;

namespace Test
{

    class ModelTest4
    {
        public long WellId { get; set; }
        public string LayerId { get; set; }
        public string Code { get; set; }
        public double Value { get; set; }
    }

    class Test4
    {
        public static void PivotExample()
        {
            var m1 = new ModelTest4
            {
                WellId = 123,
                LayerId = "PL0001",
                Code = "DN_WEIGHT",
                Value = 100,
            };
            var m2 = new ModelTest4
            {
                WellId = 123,
                LayerId = "PL0001",
                Code = "DW_WEIGHT",
                Value = 200,
            };
            var m3 = new ModelTest4
            {
                WellId = 123,
                LayerId = "PL0001",
                Code = "DJ_WEIGHT",
                Value = 300,
            };
            var m4 = new ModelTest4
            {
                WellId = 123,
                LayerId = "PL0002",
                Code = "DJ_WEIGHT",
                Value = 333,
            };

            var myList = new List<ModelTest4> { m1, m2, m3, m4 };

            var query = myList
                .GroupBy(x => new { x.WellId, x.LayerId })
                .Select(g => new
                {
                    WellId = g.Key.WellId,
                    LayerId = g.Key.LayerId,
                    DN_WEIGHT = g.Where(x => x.Code == "DN_WEIGHT").Sum(x => x.Value),
                    DW_WEIGHT = g.Where(x => x.Code == "DW_WEIGHT").Sum(x => x.Value),
                    DJ_WEIGHT = g.Where(x => x.Code == "DJ_WEIGHT").Sum(x => x.Value),
                });

        }

    }
}
