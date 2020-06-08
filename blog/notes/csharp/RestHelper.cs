using System;
using System.Collections.Generic;
using System.Globalization;
using System.Dynamic;

namespace Itsk.Mer.Common
{
    public class RestHelper
    {
        public static bool IsNumericType(Type type)
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

        public static double GetDouble(string value)
        {
            double result = 0;
            if (!string.IsNullOrEmpty(value))
            {
                value = value.Replace(',', '.');
                if (!double.TryParse(value, NumberStyles.Any, CultureInfo.CurrentCulture, out result) &&
                    //Then try in US english
                    !double.TryParse(value, NumberStyles.Any, CultureInfo.GetCultureInfo("en-US"), out result) &&
                    //Then in neutral language
                    !double.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out result))
                {
                }
            }
            return result;
        }

        public static DateTime GetDateTime(string value)
        {
            value = value.Replace("Z", string.Empty);
            return DateTime.Parse(value);
        }

        public static DateTime GetDateTime(DateTime value)
        {
            var date = DateTime.SpecifyKind(value, DateTimeKind.Unspecified);
            return date;
        }

        public static List<object> ListObjectLower(List<object> rows)
        {
            var list = new List<object>();
            foreach (var row in rows)
            {
                var dict = new Dictionary<string, object>();
                var fields = row as IDictionary<string, object>;
                foreach (string key in fields.Keys)
                {
                    dict.Add(key.ToLower(), fields[key]);
                }
                var obj = DictionaryToObject(dict);
                list.Add(obj);
            }
            return list;
        }

        private static dynamic DictionaryToObject(Dictionary<string, object> dict)
        {
            IDictionary<string, object> eo = new ExpandoObject() as IDictionary<string, object>;
            foreach (KeyValuePair<string, object> kvp in dict)
            {
                eo.Add(kvp);
            }
            return eo;
        }

    }
}
