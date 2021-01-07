using System.Data;

namespace Rbac.Connectors
{
    public interface IDbConnector
    {
        IDbConnection GetConnection();

        IDbConnection GetConnection(string connectionString);
    }
}
