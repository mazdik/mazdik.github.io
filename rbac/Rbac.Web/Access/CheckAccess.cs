using System.Linq;
using System.Collections.Generic;
using Rbac.Connectors;
using Rbac.Readers;
using Rbac.Contracts;

namespace Rbac.Web.Access
{
    public class CheckAccess
    {
        private readonly IDbConnector _connector;
        private readonly IPermissionReader _permissionReader;

        public CheckAccess(IDbConnector connector, IPermissionReader permissionReader)
        {
            _connector = connector;
            _permissionReader = permissionReader;
        }

        public bool Check(long userId, PermissionItem item, PermissionAction[] actions)
        {
            var actionsList = actions.Select(x => x.ToString().ToLower()).ToList();
            using (var connection = _connector.GetConnection())
            {
                var userIsAdmin = _permissionReader.UserIsAdmin(connection, userId);
                if (userIsAdmin)
                {
                    return true;
                }
                var permissions = _permissionReader.GetUserPermissions(connection, userId, item.ToString().ToLower());
                var result = permissions.Where(x => actionsList.Contains(x.Action.ToLower())).Any();
                return result;
            }
        }

        public static List<UserPermissionTab> GetUserPermissionTabs(List<UserPermission> permissions)
        {
            var result = permissions.GroupBy(x => new { x.UserId, x.Object })
                .Select(g => new UserPermissionTab
                {
                    Object = g.Key.Object,
                    Create = g.Any(x => x.Action.ToLower() == PermissionAction.Create.ToString().ToLower()),
                    Read = g.Any(x => x.Action.ToLower() == PermissionAction.Read.ToString().ToLower()),
                    Update = g.Any(x => x.Action.ToLower() == PermissionAction.Update.ToString().ToLower()),
                    Delete = g.Any(x => x.Action.ToLower() == PermissionAction.Delete.ToString().ToLower()),
                    Print = g.Any(x => x.Action.ToLower() == PermissionAction.Print.ToString().ToLower()),
                }).ToList();
            return result;
        }

    }
}
