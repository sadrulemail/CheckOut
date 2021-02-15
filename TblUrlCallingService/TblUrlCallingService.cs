using System;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.ServiceProcess;

namespace TblUrlCallingService
{
    public partial class TblUrlCallingService : ServiceBase
    {
        public TblUrlCallingService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            bWorker.RunWorkerAsync();

            eventLog.WriteEntry("Run Worker Async");
        }

        protected override void OnStop()
        {
            bWorker.CancelAsync();

            eventLog.WriteEntry("Cancel Async");
        }

        private void Wait()
        {
            int WaitSecond = 10;
            try
            {
                WaitSecond = int.Parse(getValue("IntervalInSecond"));
            }
            catch (Exception) { }
            Wait(WaitSecond);
        }

        private void Wait(int WaitSecond)
        {
            System.Threading.Thread.Sleep(1000 * WaitSecond);
        }

        private string getValue(string Key)
        {
            try
            {
                return string.Format("{0}", ConfigurationSettings.AppSettings[Key]);
            }
            catch (Exception) { return ""; }
        }

        private void AddError(string LogFile, string Msg)
        {
            try
            {
                File.AppendAllText(LogFile, string.Format("{0:dd MMM yyyy hh:mm:ss tt}: {1}{2}",
                    DateTime.Now,
                    Msg,
                    Environment.NewLine));
            }
            catch (Exception) { }
        }

        private void bWorker_DoWork(object sender, DoWorkEventArgs e)
        {
            string RemittanceConnectionString = getValue("RemittanceConnectionString");
            string tfKeyCode = getValue("Transfast_KeyCode");
            string responseCode = "";

            DataTable tb = new DataTable();
            string Query = "s_Tf_GetServiceData";
            SqlConnection oConn = null;
            SqlCommand oCommand;

            //long ID = 0;

            while (true)
            {
              

                if (bWorker.CancellationPending)
                {
                    e.Cancel = true;
                    return;
                }
                else
                {
                    try
                    {
                        System.Data.SqlClient.SqlConnection.ClearAllPools();
                        oConn = new SqlConnection(RemittanceConnectionString);
                        oCommand = new SqlCommand("SELECT 1;", oConn);
                        if (oConn.State == ConnectionState.Closed) oConn.Open();
                        oCommand.ExecuteNonQuery();

                        if (oConn.State != ConnectionState.Closed) oConn.Close();
                    }
                    catch (Exception eee)
                    {
                        if (oConn.State != ConnectionState.Closed) oConn.Close();

                        eventLog.WriteEntry("Database Connection: " + eee.Message);
                       // WriteLog("Tbl Notification Conn chk-01", eee.Message);
                        Wait(10000);
                        continue;
                    }
                    //eventLog.WriteEntry("DB Connection is OK");

                    using (SqlConnection conn = new SqlConnection())
                    {
                        // conn.ConnectionString = ConfigurationManager.ConnectionStrings["TransNotifyConnectionString"].ConnectionString;
                        conn.ConnectionString = RemittanceConnectionString;// getValue("TransNotifyConnectionString");

                        using (SqlCommand cmd = new SqlCommand(Query, conn))
                        {
                           // cmd.Parameters.Add(new SqlParameter("@NoOfNotification", NoOfNotification));
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Connection = conn;
                            if (conn.State == ConnectionState.Closed)
                                conn.Open();

                            using (SqlDataReader oReader = cmd.ExecuteReader())
                            {
                                //using (SqlDataReader dr = cmd.ExecuteReader())
                                {
                                    tb = new DataTable();
                                    tb.Clear();
                                    tb.Load(oReader);
                                }
                                oReader.Close();
                            }
                        }
                    }

                    if (tb.Rows.Count == 0)
                    {
                        Wait();
                        continue;
                    }

                    for (int r = 0; r < tb.Rows.Count; r++)
                    {
                       

                        try
                        {
  
                            TfService.TransfastService tfObject = new TfService.TransfastService();
                            responseCode= tfObject.PayInvoices(tfKeyCode);

                            //if (responseCode == "")
                            //    SetNotificationStatus(notificationID, "-1", responseCode);
                            //else
                            //    SetNotificationStatus(notificationID, "1", responseCode);
                       


                        }
                        catch (Exception ex)
                        {
                          //  WriteLog("Tbl Notification For Loop Error: " + "NotificationID: " + notificationID + "responseCode:" + responseCode, ex.Message + "xml:" + ReqXmlDoc);
                           // SetNotificationStatus(notificationID, "-1", responseCode);
                        }




                    }
                    

                } 
                
            } 
           
        }
    }
}
