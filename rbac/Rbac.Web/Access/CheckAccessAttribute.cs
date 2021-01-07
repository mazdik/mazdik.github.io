using System;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace Rbac.Web.Access
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true, Inherited = true)]
    public class CheckAccessAttribute : AuthorizeAttribute, IAuthorizationFilter
    {
        private PermissionItem _item;
        private PermissionAction[] _actions;

        public CheckAccessAttribute(PermissionItem item, PermissionAction[] actions)
        {
            _item = item;
            _actions = actions;
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            var user = context.HttpContext.User;

            if (!user.Identity.IsAuthenticated)
            {
                return;
            }

            string userIdString = user.FindFirst(ClaimTypes.Name)?.Value;
            long userId = !string.IsNullOrEmpty(userIdString) ? long.Parse(userIdString) : default;

            CheckAccess service = (CheckAccess)context.HttpContext.RequestServices.GetService(typeof(CheckAccess));
            var success = service.Check(userId, _item, _actions);
            if (!success)
            {
                context.Result = new StatusCodeResult((int)System.Net.HttpStatusCode.Forbidden);
                return;
            }
            return;
        }
    }
}
