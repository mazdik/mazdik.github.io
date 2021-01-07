using System;
using System.Linq;
using System.Collections.Generic;
using System.Data;
using Dapper;
using Rbac.Contracts;

namespace Rbac.Readers.PostgreSql
{
    public class UserReader : IUserReader
    {
        public User GetUser(IDbConnection connection, string userName)
        {
            var sql = @"select * from user_assigment where name = :userName";
            return connection.Query<User>(sql, new { userName }).FirstOrDefault();
        }
    }
}
