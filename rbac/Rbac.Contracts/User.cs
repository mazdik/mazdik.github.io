using System.Collections.Generic;

namespace Rbac.Contracts
{
    public class User
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public List<UserPermissionTab> Permissions { get; set; }
        public List<string> Roles { get; set; }
        public string Token { get; set; }
    }
}
