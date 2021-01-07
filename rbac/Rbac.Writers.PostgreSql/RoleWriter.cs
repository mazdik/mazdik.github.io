using System.Collections.Generic;
using System.Data;
using System.Linq;
using Dapper;
using Rbac.Contracts;

namespace Rbac.Writers.PostgreSql
{
    public class RoleWriter : IRoleWriter
    {
        public void Insert(IDbConnection connection, Role role)
        {
            connection.Execute(@"insert into role(:code, :title) values(:Code, :Title)", role);
        }

        public void Delete(IDbConnection connection, Role role)
        {
            connection.Execute(@"delete from role where id = :roleId", new { roleId = role.Id });
        }

    }
}
