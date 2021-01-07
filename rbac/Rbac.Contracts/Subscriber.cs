using System;
using System.Collections.Generic;
using System.Text;

namespace Rbac.Contracts
{
    public class Subscriber
    {
        public long Id { get; set; }
        public string Inn { get; set; }
        public string ShortName { get; set; }
        public string FullName { get; set; }
        public string Address { get; set; }
        public string Phone { get; set; }
        public string FullNameHead { get; set; }
        public string Representative { get; set; }
        public string RepresentativePhone { get; set; }
    }
}
