namespace Rbac.Contracts
{
    public class UserPermission
    {
        public long UserId { get; set; }
        public string Role { get; set; }
        public string RoleTitle { get; set; }
        public string Object { get; set; }
        public string ObjectTitle { get; set; }
        public string Action { get; set; }
        public string ActionTitle { get; set; }
    }
}
