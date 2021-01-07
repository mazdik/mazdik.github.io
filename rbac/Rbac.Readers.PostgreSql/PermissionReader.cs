using System;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using Dapper;
using Rbac.Contracts;

namespace Rbac.Readers.PostgreSql
{
    public class PermissionReader : IPermissionReader
    {
        public List<UserPermission> GetUserPermissions(IDbConnection connection, long userId, string objectId = null)
        {
            var sql = @"select u.id as user_id,
                   u.name  as user_name,
                   r.code  as role,
                   r.title as role_title,
                   o.code  as object,
                   o.title as object_title,
                   a.code  as action,
                   a.title as action_title
              from user_assigment u, role_user_assigment ru, role r, role_permission rp, permission p, object o, action a
             where u.id = ru.user_assigment_id
               and ru.role_id = r.id
               and r.id = rp.role_id
               and rp.permission_id = p.id
               and o.id = p.object_id
               and a.id = p.action_id
               and u.id = :userId
               and (o.code = :objectId or :objectId is null)";
            return connection.Query<UserPermission>(sql, new { userId, objectId }).ToList();
        }

        public bool UserIsAdmin(IDbConnection connection, long userId)
        {
            var sql = @"select r.*
              from role_user_assigment ru, role r
             where ru.role_id = r.id
               and ru.user_assigment_id = :userId
               and r.code = 'admin'";
            return connection.Query<bool>(sql, new { userId }).Any();
        }
    }
}
