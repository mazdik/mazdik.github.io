using System;
using System.Diagnostics;
using System.Configuration;

namespace GetProcessesByName
{
    class Program
    {
        public static string processesName = ConfigurationManager.AppSettings["processesName"];
        public static string minutes = ConfigurationManager.AppSettings["minutes"];
        static void Main(string[] args)
        {
            Process[] processlist = Process.GetProcessesByName(processesName);
                foreach (Process theprocess in processlist)
                {
                    //Console.WriteLine(theprocess.StartTime);
                    var procTime = DateTime.Now - theprocess.StartTime;
                    //Console.WriteLine(procTime.TotalMinutes);
                    if (procTime.TotalMinutes > Int32.Parse(minutes))
                    {
                        try
                        {
                            theprocess.Kill();
                        }
                        catch (Exception ex)
                        {
                            Console.WriteLine(ex.ToString());
                        }
                    }
                }
            //Console.ReadLine();
        }
    }
}
