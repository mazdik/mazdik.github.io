using System.Data;
using Rbac.Contracts;

namespace Rbac.Writers
{
    public interface IRoleWriter
    {
        void Insert(IDbConnection connection, Role role);
        void Delete(IDbConnection connection, Role role);
    }
}
