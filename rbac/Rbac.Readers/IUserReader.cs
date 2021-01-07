using System;
using System.Collections.Generic;
using System.Data;
using Rbac.Contracts;

namespace Rbac.Readers
{
    public interface IUserReader
    {
        User GetUser(IDbConnection connection, string userName);
    }
}
