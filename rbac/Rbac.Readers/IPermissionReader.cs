using System;
using System.Collections.Generic;
using System.Data;
using Rbac.Contracts;

namespace Rbac.Readers
{
    public interface IPermissionReader
    {
        List<UserPermission> GetUserPermissions(IDbConnection connection, long userId, string objectId = null);
        bool UserIsAdmin(IDbConnection connection, long userId);
    }
}
