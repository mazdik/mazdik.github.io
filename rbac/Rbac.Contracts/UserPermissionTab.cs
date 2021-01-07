using System;
using System.Collections.Generic;
using System.Text;

namespace Rbac.Contracts
{
    public class UserPermissionTab
    {
        public string Object { get; set; }
        public bool Create { get; set; }
        public bool Read { get; set; }
        public bool Update { get; set; }
        public bool Delete { get; set; }
        public bool Print { get; set; }
    }
}
