using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using Rbac.Connectors;
using Rbac.Connectors.PostgreSql;
using Rbac.Readers;
using Rbac.Readers.PostgreSql;
using Rbac.Web.Access;

namespace Rbac.Web.Configuration
{
    public static class TypeMappingConfiguration
    {
        public static IServiceCollection AddTypeSettings(this IServiceCollection services, IConfiguration configuration)
        {
            services.AddSingleton<IDbConnector, PgConnection>(provider =>
            {
                var logger = provider.GetService<ILoggerFactory>().CreateLogger<IDbConnector>();
                return new PgConnection(configuration["ConnectionStrings:PgConn"], logger);
            });
            services.AddTransient<IUserReader, UserReader>();
            services.AddTransient<IPermissionReader, PermissionReader>();
            services.AddSingleton<CheckAccess, CheckAccess>();

            return services;
        }
    }
}
