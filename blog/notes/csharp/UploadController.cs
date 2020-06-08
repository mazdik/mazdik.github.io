using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;

namespace Controllers.Data
{
    [Route("api/[controller]/[action]")]
    [EnableCors("AllowCors")]
    public class UploadController : ControllerBase
    {
        private readonly IHostingEnvironment _appEnvironment;
        private readonly UploadInclinometer _uploadInc;

        public UploadController(IHostingEnvironment appEnvironment, UploadInclinometer uploadInc)
        {
            _appEnvironment = appEnvironment;
            _uploadInc = uploadInc ?? throw new ArgumentNullException(nameof(uploadInc));
        }

        [HttpPost]
        public async Task<object> LoadWellInclinometry(IFormFile file, [FromForm]long wellId, [FromForm]int wellboreNum)
        {
            bool success = false;
            long count = 0;
            var error = string.Empty;
            if (file != null)
            {
                var sizeLimit = 3;
                if (file.Length > sizeLimit * 1024 * 1024)
                {
                    return new { success, count, error = $"File upload size limit {sizeLimit} MB" };
                }
                if (file.ContentType.ToLower() != "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
                {
                    return new { success, count, error = "The file must be a Excel2007 file (.xlsx)" };

                }
                string path = _appEnvironment.WebRootPath + "/upload/";
                Directory.CreateDirectory(path);
                path += file.FileName;
                // сохраняем файл в папку Files в каталоге wwwroot
                using (var fileStream = new FileStream(path, FileMode.Create))
                {
                    await file.CopyToAsync(fileStream);
                }
                try
                {
                    count = _uploadInc.Load(path, wellId, wellboreNum);
                    success = true;
                }
                catch (Exception e)
                {
                    error = e.Message;
                }
                DeleteFile(path);
            }
            return new { success, count, error };
        }

        private void DeleteFile(string path)
        {
            if (System.IO.File.Exists(path))
            {
                try
                {
                    System.IO.File.Delete(path);
                }
                catch (IOException e)
                {
                    Console.WriteLine(e.Message);
                    return;
                }
            }
        }

    }
}
