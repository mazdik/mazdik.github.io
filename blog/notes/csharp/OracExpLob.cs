using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Data;
using Oracle.DataAccess.Client;
using Oracle.DataAccess.Types;
using NLog;

namespace Test
{
    class OracExpLob
    {
        private static Logger logger = LogManager.GetCurrentClassLogger();
        private string path = Directory.GetCurrentDirectory();

        public string OracleConnString(string dataSource, string user, string pass)
        {
            string oradb = "Data Source=" + dataSource + ";User Id=" + user + ";Password=" + pass + ";";
            return oradb;
        }

        public void OracleProcedure(string ConnectionString, string ProcedureName, string OutBlobParam)
        {
            OracleConnection OracleCon = new OracleConnection(ConnectionString);
            //GIVE PROCEDURE NAME
            OracleCommand cmd = new OracleCommand(ProcedureName, OracleCon);
            cmd.CommandType = CommandType.StoredProcedure;

            //ASSIGN PARAMETERS TO BE PASSED
            //cmd.Parameters.Add("sdisk", OracleDbType.Char).Value = "D";
            //cmd.Parameters.Add("PARAM2", OracleDbType.Varchar2).Value = "VAL2";

            //THIS PARAMETER MAY BE USED TO RETURN RESULT OF PROCEDURE CALL
            cmd.Parameters.Add(OutBlobParam, OracleDbType.Blob);
            cmd.Parameters[OutBlobParam].Direction = ParameterDirection.Output;

            //USE THIS PARAMETER CASE CURSOR IS RETURNED FROM PROCEDURE
            //cmd.Parameters.Add("vCHASSIS_RESULT", OracleDbType.RefCursor, ParameterDirection.InputOutput);

            try
            {
                OracleCon.Open();

                //CALL PROCEDURE
                OracleDataAdapter da = new OracleDataAdapter(cmd);
                cmd.ExecuteNonQuery();

                /* 1й способ */
                OracleBlob myBlob = (OracleBlob)(cmd.Parameters[OutBlobParam].Value);
                byte[] MyData = new byte[myBlob.Length];
                myBlob.Read(MyData, 0, (int)myBlob.Length);
                FileStream fs = new FileStream(path + "\\" + Program.reportFileName, FileMode.Create, FileAccess.Write);
                fs.Write(MyData, 0, (int)myBlob.Length);
                fs.Close();

                /* 2й способ */
                //byte[] MyData = new byte[0];
                //MyData = (byte[])((OracleBlob)(cmd.Parameters["bblob"].Value)).Value;
                //int ArraySize = new int();
                //ArraySize = MyData.GetUpperBound(0);
                //FileStream fs = new FileStream(@"C:\report.xlsx", FileMode.Create, FileAccess.Write);
                //fs.Write(MyData, 0, ArraySize);
                //fs.Close();

            }
            catch (OracleException oe)
            {
                logger.Info("Ошибка подключения к БД Oracle." + '\n' + oe.Message);
            }
            finally
            {
                if (OracleCon != null)
                {
                    OracleCon.Close();
                    OracleCon.Dispose();
                }
            }
        }


    }
}
