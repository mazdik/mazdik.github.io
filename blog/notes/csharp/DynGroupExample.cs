using System;
using System.Collections.Generic;
using System.Linq;

namespace Itsk.Mer.Shell
{
    class Consts
    {
        public const int LEVEL_COMPANY = 0;
        public const int LEVEL_WELL = 1;
        public const int LEVEL_LAYER = 2;
        public const int LEVEL_FIELD = 3;
        public const int LEVEL_ENTERPRISE = 4;
        public const int LEVEL_SHOP = 5;
        public const int LEVEL_LICENSE_AREA = 6;
        public const int LEVEL_KNS = 7;
        public const int LEVEL_AGENT = 8;
        public const int LEVEL_CLUSTER = 9;
        public const int LEVEL_CATEGORY_WELL = 10;
        public const int LEVEL_PURPOSE = 11;
    }

    class GroupObjects
    {
        public string Object1 { get; set; }
        public string Object2 { get; set; }
        public string Object3 { get; set; }
        public string Object4 { get; set; }
        public string Object5 { get; set; }
    }

    class OblectLevels: GroupObjects
    {
        public string Company { get; set; }
        public string Layer { get; set; }
        public string Field { get; set; }
        public string Enterprise { get; set; }
        public string Shop { get; set; }
        public string LicenseArea { get; set; }
        public string Kns { get; set; }
        public string Agent { get; set; }
        public string ClusterName { get; set; }
        public string CategoryWell { get; set; }
        public string Purpose { get; set; }
    }

    class ModelTest4: OblectLevels
    {
        public long WellId { get; set; }
        public double Value { get; set; }
    }

    class Test4
    {
        public static void DynGroupExample()
        {
            var m1 = new ModelTest4
            {
                Company = "Company2",
                Enterprise = "Enterprise2",
                WellId = 123,
                Layer = "PL0001",
                Value = 100,
            };
            var m2 = new ModelTest4
            {
                Company = "Company2",
                Enterprise = "Enterprise2",
                WellId = 123,
                Layer = "PL0002",
                Value = 200,
            };
            var m3 = new ModelTest4
            {
                Company = "Company2",
                Enterprise = "Enterprise2",
                WellId = 123,
                Layer = "PL0001",
                Value = 300,
            };
            var m4 = new ModelTest4
            {
                Company = "Company1",
                Enterprise = "Enterprise1",
                WellId = 123,
                Layer = "PL0001",
                Value = 333,
            };
            var m5 = new ModelTest4
            {
                Company = "Company1",
                Enterprise = "Enterprise1",
                WellId = 1234,
                Layer = "PL0002",
                Value = 333,
            };

            var myList = new List<ModelTest4> { m1, m2, m3, m4, m5 };
            var res = DynGroup(myList, "0-4-2");
        }

        public static IEnumerable<IGrouping<dynamic, T>> DynGroup<T>(List<T> list, string objLevelsList) where T : OblectLevels
        {
            var objLevels = objLevelsList.Split('-');
            foreach (var l in list)
            {
                if (objLevels.Length > 0 && objLevels[0] != null)
                {
                    l.Object1 = SwitchGroupObject(l, objLevels[0]);
                }
                if (objLevels.Length > 1 && objLevels[1] != null)
                {
                    l.Object2 = SwitchGroupObject(l, objLevels[1]);
                }
                if (objLevels.Length > 2 && objLevels[2] != null)
                {
                    l.Object3 = SwitchGroupObject(l, objLevels[2]);
                }
                if (objLevels.Length > 3 && objLevels[3] != null)
                {
                    l.Object4 = SwitchGroupObject(l, objLevels[3]);
                }
                if (objLevels.Length > 4 && objLevels[4] != null)
                {
                    l.Object5 = SwitchGroupObject(l, objLevels[4]);
                }
            }
            list = list.OrderBy(x => x.Object1).ThenBy(x => x.Object2).ThenBy(x => x.Object3).ThenBy(x => x.Object4).ThenBy(x => x.Object5).ToList();
            var result = list.GroupBy(x => new { x.Object1, x.Object2, x.Object3, x.Object4, x.Object5 });
            return result;
        }

        private static string SwitchGroupObject(OblectLevels groupObject, string lvl)
        {
            var level = Convert.ToInt32(lvl);
            string result = null;
            switch (level)
            {
                case Consts.LEVEL_COMPANY:
                    result = groupObject.Company;
                    break;
                case Consts.LEVEL_ENTERPRISE:
                    result = groupObject.Enterprise;
                    break;
                case Consts.LEVEL_FIELD:
                    result = groupObject.Field;
                    break;
                case Consts.LEVEL_LAYER:
                    result = groupObject.Layer;
                    break;
                case Consts.LEVEL_LICENSE_AREA:
                    result = groupObject.LicenseArea;
                    break;
                case Consts.LEVEL_AGENT:
                    result = groupObject.Agent;
                    break;
                case Consts.LEVEL_CLUSTER:
                    result = groupObject.ClusterName;
                    break;
                case Consts.LEVEL_CATEGORY_WELL:
                    result = groupObject.CategoryWell;
                    break;
                case Consts.LEVEL_PURPOSE:
                    result = groupObject.Purpose;
                    break;
                default:
                    break;
            }
            return result;
        }

    }
}
