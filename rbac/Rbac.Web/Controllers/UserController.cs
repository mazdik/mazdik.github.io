using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Configuration;
using Rbac.Contracts;
using Rbac.Readers;
using Rbac.Connectors;
using Rbac.Web.Access;

namespace Rbac.Web.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IConfiguration _config;
        private readonly IDbConnector _connector;
        private readonly IPermissionReader _permissionReader;
        private readonly IUserReader _userReader;

        public UserController(IConfiguration config, IDbConnector connector, IPermissionReader permissionReader, IUserReader userReader)
        {
            _config = config;
            _connector = connector;
            _permissionReader = permissionReader;
            _userReader = userReader;
        }

        [AllowAnonymous]
        [HttpPost("login")]
        public IActionResult Login([FromBody]LoginModel userParam)
        {
            using (var connection = _connector.GetConnection())
            {
                var user = _userReader.GetUser(connection, userParam.username);
                if (user == null)
                {
                    return BadRequest(new { message = "Username or password is incorrect" });
                }
                var userPermissions = _permissionReader.GetUserPermissions(connection, user.Id);
                user.Permissions = CheckAccess.GetUserPermissionTabs(userPermissions);
                user.Roles = userPermissions.Select(x => x.Role).Distinct().ToList();
                user.Token = GenerateToken(user);
                return Ok(user);
            }
        }

        [CheckAccess(PermissionItem.User, new PermissionAction[] { PermissionAction.Read })]
        [HttpGet("test")]
        public IActionResult Test()
        {
            var identity = User.Identity;
            if (!User.Identity.IsAuthenticated || identity == null)
            {
                return new ForbidResult();
            }
            return Ok("ok");
        }

        private string GenerateToken(User user)
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_config["Jwt:Key"]);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, user.Id.ToString())
                }),
                Expires = DateTime.UtcNow.AddMinutes(30),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return tokenHandler.WriteToken(token);
        }

    }

    public class LoginModel
    {
        public string username;
        public string password;
    }
}