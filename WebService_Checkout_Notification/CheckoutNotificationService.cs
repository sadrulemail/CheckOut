using System;
using System.ComponentModel;
using System.Data;
using System.ServiceProcess;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Xml;
using System.Text;

namespace WebService_Checkout_Notification
{
    partial class CheckoutNotificationService : ServiceBase
    {
      //  string PaymentsDBConnectionString = "";
        string TransNotifyConnectionString = "";

        public CheckoutNotificationService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            System.Diagnostics.Debugger.Launch();
            // TODO: Add code here to start your service.
            bWorker.RunWorkerAsync();

            eventLog.WriteEntry("Run Worker Async");
        }

        protected override void OnStop()
        {
            // TODO: Add code here to perform any tear-down necessary to stop your service.
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
            //try
            //{

            // string Notification_PostUrl = "https://10.32.14.231:9081/BankService/transaction/receiver";
            //  string Bkash_Method = "POST";
            int NoOfNotification = 1;
            string certPath = getValue("bKashCertPath");
            string certPass = getValue("bKashCertPass");
            string bKashUserID = getValue("bKashHeaderId");
            string bKashPassword = getValue("bKashHeaderPassword").Replace("&", "&amp;");

            DataTable tb = new DataTable();
            string Query = "s_APIBaseTransactionNotificationSelection";
            SqlConnection oConn = null;
            SqlCommand oCommand;

            //long ID = 0;

            while (true)
            {
                //try
                //{
                TransNotifyConnectionString = getValue("TransNotifyConnectionString");

                //  GP_Method = getValue("GP_Method");
                try
                {
                    NoOfNotification = int.Parse(getValue("NoOfNotification"));
                }
                catch (Exception) { }

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
                        oConn = new SqlConnection(TransNotifyConnectionString);
                        oCommand = new SqlCommand("SELECT 1;", oConn);
                        if (oConn.State == ConnectionState.Closed) oConn.Open();
                        oCommand.ExecuteNonQuery();

                        if (oConn.State != ConnectionState.Closed) oConn.Close();
                    }
                    catch (Exception eee)
                    {
                        if (oConn.State != ConnectionState.Closed) oConn.Close();

                        eventLog.WriteEntry("Database Connection: " + eee.Message);
                        WriteLog("Tbl Notification Conn chk-01", eee.Message);
                        Wait(10000);
                        continue;
                    }
                    //eventLog.WriteEntry("DB Connection is OK");

                    using (SqlConnection conn = new SqlConnection())
                    {
                        // conn.ConnectionString = ConfigurationManager.ConnectionStrings["TransNotifyConnectionString"].ConnectionString;
                        conn.ConnectionString = getValue("TransNotifyConnectionString");

                        using (SqlCommand cmd = new SqlCommand(Query, conn))
                        {
                            cmd.Parameters.Add(new SqlParameter("@NoOfNotification", NoOfNotification));
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
                        string notificationID = "";
                        string transactionID = "";
                        string transactionDT = "";
                        string transactionParticular = "";
                        string transactionAmount = "";
                        string transactionSource = "";
                        string transactionRemarks = "";
                        string transactionType = "";
                        string pushTimeStamp = "";
                        string legs = "1";
                        string bankName = "";
                        string branchCode = "";

                        string notifyUrl = "";
                        string responseCode = "";
                        string ReqXmlDoc = "";

                        try
                        {
                            //try
                            //{


                            notificationID = tb.Rows[r]["APIBaseTransactionNotificationID"].ToString();
                            transactionID = String.Format("{0:yyMMdd}", tb.Rows[r]["SystemTransactionDateTime"])
                                        + tb.Rows[r]["TraceNo"].ToString().Substring(10);
                            transactionDT = String.Format("{0:dd-MM-yyyy HH:mm}", tb.Rows[r]["SystemTransactionDateTime"]);
                            transactionParticular = tb.Rows[r]["TransactionParticulars"].ToString().Trim();
                            transactionAmount = tb.Rows[r]["AmountTk"].ToString();
                            transactionSource = tb.Rows[r]["ModeOfTransaction"].ToString().Trim();
                            transactionRemarks = tb.Rows[r]["Remarks"].ToString().Trim();
                            transactionType = "DR";
                            pushTimeStamp = String.Format("{0:dd-MM-yyyy HH:mm}", tb.Rows[r]["NotificationSendingDateTime"]);
                            legs = "1";
                            bankName = tb.Rows[r]["BankName"].ToString();
                            branchCode = tb.Rows[r]["BranchCode"].ToString();

                            notifyUrl = tb.Rows[r]["NotifyingURL"].ToString();

                            //"https://gw.bkash.com:9081/BankService/transaction/receiver";
                            // postingMethod = tb.Rows[r]["PostingMethod"].ToString();

                            ReqXmlDoc = getReqXmlDoc(
                                transactionID,
                                transactionDT,
                                transactionParticular,
                                transactionAmount,
                                transactionSource,
                                transactionRemarks,
                                transactionType,
                                pushTimeStamp,
                                legs,
                                bankName,
                                branchCode);


                            //--
                            responseCode = PostData_Mutual_SSL_Authentication(
                                ReqXmlDoc,
                                certPath,
                                certPass,
                                notifyUrl,
                                bKashUserID,
                                bKashPassword);


                            // Get elements
                            //XmlDocument xml_res = new XmlDocument();
                            //xml_res.LoadXml(content);
                            //responseCode = xml_res.GetElementsByTagName("statusCode")[0].InnerText;
                            //  if(responseCode=="0000")

                            if (responseCode == "")
                                SetNotificationStatus(notificationID, "-1", responseCode);
                            else
                                SetNotificationStatus(notificationID, "1", responseCode);
                            //else
                            //   SetNotificationStatus(notificationID, "-1", responseCode);


                        }
                        catch (Exception ex)
                        {
                            WriteLog("Tbl Notification For Loop Error: " + "NotificationID: " + notificationID + "responseCode:" + responseCode, ex.Message + "xml:" + ReqXmlDoc);
                            SetNotificationStatus(notificationID, "-1", responseCode);
                        }



                        //}
                        //catch (Exception ex)
                        //{
                        //    //if (PresentUrl == 1)
                        //    //{
                        //    //    eventLog.WriteEntry("Connection Switched: 2");
                        //    //    PresentUrl = 2;
                        //    ////    SMS_Fail_Update(ID, false, PresentUrl, "", "", ex.Message, "");
                        //    //}
                        //    //else
                        //    //{
                        //    //    eventLog.WriteEntry("Connection Switched: 1");
                        //    //    PresentUrl = 1;
                        //    //   // SMS_Fail_Update(ID, false, PresentUrl, "", "", ex.Message, "");
                        //    //}
                        //    SetNotificationStatus(notificationID, "-1", responseCode);
                        //    WriteLog("Tbl Notification Conn chk-02", ex.Message);

                        //}

                    }
                    //end For

                } //end else
                  //}
                  //catch (Exception exx)
                  //{
                  //    WriteLog("Tbl Notification Conn chk-03", exx.Message);
                  //    eventLog.WriteEntry("Error 1: " + exx.Message);
                  //    Wait(20);
                  //    continue;
                  //}
            } //end While
            //}
            //catch (Exception ex)
            //{
            //    WriteLog("Exit from Service", ex.Message);
            //    eventLog.WriteEntry("Error 0: " + ex.Message);
            //}
        }

        private  string PostData_Mutual_SSL_Authentication(string ReqXmlDoc,string certPath,string certPass, string PostUrl,string username, string password)
        {
            string statusCode = "";
            try
            {
               // var certificate = @"F:\Document\Others\Integration to bKash\Cert\ibanking.tblbd.com_EV.pfx";
              //  var certpwd = "Trust@1234";
             //   var URL = "https://gw.bkash.com:9081/BankService/transaction/receiver";
                var certs = new X509Certificate2Collection();
                certs.Import(certPath, certPass, X509KeyStorageFlags.DefaultKeySet);

                var webrequest = WebRequest.Create(PostUrl) as HttpWebRequest;

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls ;
                //ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3;
                ServicePointManager.Expect100Continue = false;
                ServicePointManager.ServerCertificateValidationCallback += new RemoteCertificateValidationCallback(AlwaysGoodCert);
                webrequest.ClientCertificates.Add(certs[0]);

                //String username = bHeaderID;
                //String password = bHeaderPass;

                string encoded = Convert.ToBase64String(ASCIIEncoding.ASCII.GetBytes(username + ":" + password));
                webrequest.Headers.Add("Authorization", "Basic " + encoded);

                webrequest.Method = WebRequestMethods.Http.Post;
                //  webrequest.ContentType = "application/json; charset=utf-8";

                byte[] postBytes = System.Text.Encoding.ASCII.GetBytes(ReqXmlDoc); ;
                webrequest.ContentType = "text/xml; encoding='utf-8'";
                webrequest.ContentLength = postBytes.Length;

                Stream requestStream = webrequest.GetRequestStream();
                requestStream.Write(postBytes, 0, postBytes.Length);
                requestStream.Close();
                HttpWebResponse response;
                response = (HttpWebResponse)webrequest.GetResponse();
                if (response.StatusCode == HttpStatusCode.OK)
                {
                    Stream responseStream = response.GetResponseStream();
                    string responseStr = new StreamReader(responseStream).ReadToEnd();

                    XmlDocument doc = new XmlDocument();
                    doc.LoadXml(responseStr);

                    XmlNodeList xnList = doc.SelectNodes("/responseData");
                    foreach (XmlNode xn in xnList)
                    {
                        return statusCode = xn["statusCode"].InnerText.Trim();

                    }
                }


            }
            catch (Exception ex)
            {
                WriteLog("Tbl Notification authentication", ex.Message);
                //throw ex;
                 statusCode="";
            }
            return statusCode;
        }
        private static bool AlwaysGoodCert(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslpolicyerrors)
        {
            return true;
        }

        public  void WriteLog(string Page, string LogText)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_ErrorLog_Insert";
                    conn.ConnectionString = getValue("PaymentsDBConnectionString");

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@Page", System.Data.SqlDbType.VarChar).Value = Page;
                        cmd.Parameters.Add("@Msg", System.Data.SqlDbType.VarChar).Value = LogText;
                        cmd.Connection = conn;
                        if (conn.State == ConnectionState.Closed) conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    //conn.Close();
                }
            }
            catch (Exception ex)
            {
                eventLog.WriteEntry("Write Log Failed: " + ex.Message);
            }
        }

        private void SetNotificationStatus(string notificationID,string statusCode,string responseCode)
        {
            try
            {
                string Query = "s_APIBaseTransactionNotificationSendingStatusSet";
                using (SqlConnection conn = new SqlConnection())
                {
                    conn.ConnectionString = getValue("TransNotifyConnectionString");

                    using (SqlCommand cmd = new SqlCommand(Query, conn))
                    {
                        cmd.Parameters.Add(new SqlParameter("@NotificationID", notificationID));
                        cmd.Parameters.Add(new SqlParameter("@SendingTime", DateTime.Now));
                        cmd.Parameters.Add(new SqlParameter("@Status", statusCode));
                        cmd.Parameters.Add(new SqlParameter("@Response", responseCode));
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Connection = conn;
                        if (conn.State == ConnectionState.Closed)
                            conn.Open();

                        cmd.ExecuteNonQuery();

                        //using (SqlDataReader dr = cmd.ExecuteReader())
                        //{
                        //    tb = new DataTable();
                        //    tb.Load(oReader);
                        //}
                    }
                }
            }
            catch(Exception ex)
            {
                WriteLog("s_APIBaseTransactionNotificationSendingStatusSet" + "notificationID:" + notificationID, ex.Message);
            }
        }
        private string getReqXmlDoc(string transactionID, string transactionDT, string transactionParticular, string transactionAmount, string transactionSource, string transactionRemarks, string transactionType, string pushTimeStamp, string legs, string bankName, string branchCode)
        {
            XmlDocument doc = new XmlDocument();

            XmlNode docNode = doc.CreateXmlDeclaration("1.0", null, null);
            doc.AppendChild(docNode);

            XmlNode transactionNode = doc.CreateElement("transaction");
            doc.AppendChild(transactionNode);

            XmlNode transactionIDChild = doc.CreateElement("transactionID");
            transactionIDChild.InnerText = transactionID;
            transactionNode.AppendChild(transactionIDChild);

            XmlNode transactionDateChild = doc.CreateElement("transactionDate");
            transactionDateChild.InnerText = transactionDT;
            transactionNode.AppendChild(transactionDateChild);

            XmlNode transactionParticularChild = doc.CreateElement("transactionParticular");
            transactionParticularChild.InnerText = transactionParticular;
            transactionNode.AppendChild(transactionParticularChild);

            XmlNode transactionAmountChild = doc.CreateElement("transactionAmount");
            transactionAmountChild.InnerText = transactionAmount;
            transactionNode.AppendChild(transactionAmountChild);

            XmlNode transactionSourceChild = doc.CreateElement("transactionSource");
            transactionSourceChild.InnerText = transactionSource;
            transactionNode.AppendChild(transactionSourceChild);

            XmlNode transactionRemarksChild = doc.CreateElement("transactionRemarks");
            transactionRemarksChild.InnerText = transactionRemarks;
            transactionNode.AppendChild(transactionRemarksChild);

            XmlNode transactionTypeChild = doc.CreateElement("transactionType");
            transactionTypeChild.InnerText = transactionType;
            transactionNode.AppendChild(transactionTypeChild);

            XmlNode pushTimestampChild = doc.CreateElement("pushTimestamp");
            pushTimestampChild.InnerText = pushTimeStamp;
            transactionNode.AppendChild(pushTimestampChild);

            XmlNode legsChild = doc.CreateElement("legs");
            legsChild.InnerText = legs;
            transactionNode.AppendChild(legsChild);

            XmlNode bankNameChild = doc.CreateElement("bankName");
            bankNameChild.InnerText = bankName;
            transactionNode.AppendChild(bankNameChild);

            XmlNode branchCodeChild = doc.CreateElement("branchCode");
            branchCodeChild.InnerText = branchCode;
            transactionNode.AppendChild(branchCodeChild);

            return doc.OuterXml;
        }
     
    }
}