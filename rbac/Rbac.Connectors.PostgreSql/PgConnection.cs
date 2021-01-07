using System;
using System.Data;
using Dapper;
using System.Globalization;
using Npgsql;
using Microsoft.Extensions.Logging;
using Rbac.Connectors;

namespace Rbac.Connectors.PostgreSql
{
    public class PgConnection : IDbConnector
    {
        private readonly string _connectionString;
        private readonly ILogger _logger;

        public PgConnection(string connectionString, ILogger logger)
        {
            _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }
        public IDbConnection GetConnection()
        {
            var connection = new NpgsqlConnection(_connectionString);
            connection.Open();
            SetLocale(connection);
            return connection;
        }

        public IDbConnection GetConnection(string connectionString)
        {
            var connection = new NpgsqlConnection(connectionString);
            connection.Open();
            return connection;
        }

        private void SetLocale(IDbConnection connection)
        {
            // Устанавливается через Accept-Language в RequestCultureMiddleware
            var lang = CultureInfo.CurrentUICulture.TwoLetterISOLanguageName;
            try
            {
                var sql = string.Format("set myvars.language_id = '{0}'", lang);
                connection.Execute(sql);
            }
            catch (Exception e)
            {
                _logger.LogError(e.ToString());
            }
        }
    }
}
