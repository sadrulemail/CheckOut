using System;
using System.ComponentModel;
using System.Data;
using System.ServiceProcess;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Net.Mail;
using System.Net;
using Microsoft.Exchange.WebServices.Data;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Text.RegularExpressions;

namespace Trust_Bank_Checkout_Email_Service
{
    partial class CheckOutEmailService : ServiceBase
    {
        string PaymentsDBConnectionString = "";

        public CheckOutEmailService()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
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
            //while (true)
            //{
            //    if (bWorker.CancellationPending)
            //    {
            //        e.Cancel = true;
            //        return;
            //    }
            //    else
            //    {
            //        System.Threading.Thread.Sleep(2000);
            //    }
            //}

            //return;

            eventLog.WriteEntry("bWorker_DoWork Start");



            try
            {
                string LogFile = getValue("LogFile");
                string Query = "s_Email_Pending";
                SqlConnection oConn = null;
                SqlCommand oCommand;
                SmtpClient client;
                MailMessage mailMsg;

                string RefNo = "";
                long ID = 0;
                double Amount = 0;
                string ApplicantName = "";
                string EmailTo = "";
                string Type ="";
                string AttachmentID = "";
                
                byte[] myByteArray = null;

                string[] MailBCC = null;
                string[] MailCC = null;
                DataTable tb = null;
                string EmailType = getValue("EmailType");
                string ExchangeUrl = getValue("ExchangeUrl");
                string ExchangeUserName = getValue("ExchangeUserName");
                string ExchangeUserPassword = getValue("ExchangeUserPassword");
                string ExchangeDomain = getValue("ExchangeDomain");

                while (true)
                {
                    try
                    {
                        PaymentsDBConnectionString = getValue("PaymentsDBConnectionString");

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
                                oConn = new SqlConnection(PaymentsDBConnectionString);
                                oCommand = new SqlCommand("SELECT 1", oConn);
                                if (oConn.State == ConnectionState.Closed)
                                    oConn.Open();
                                oCommand.ExecuteNonQuery();

                                if (oConn.State != ConnectionState.Closed)
                                    oConn.Close();
                            }
                            catch (Exception eee)
                            {
                                if (oConn.State != ConnectionState.Closed)
                                    oConn.Close();

                                AddError(LogFile, "Database Connection: " + eee.Message);
                                Wait();
                                continue;
                            }
                            //eventLog.WriteEntry("DB Connection is OK");

                            using (SqlConnection conn = new SqlConnection())
                            {
                                conn.ConnectionString = PaymentsDBConnectionString;

                                using (SqlCommand cmd = new SqlCommand(Query, conn))
                                {
                                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                                    cmd.Connection = conn;
                                    if (conn.State == ConnectionState.Closed)
                                        conn.Open();

                                    SqlDataReader oReader = cmd.ExecuteReader();

                                    //using (SqlDataReader dr = cmd.ExecuteReader())
                                    {
                                        tb = new DataTable();
                                        tb.Load(oReader);
                                    }
                                    oReader.Close();
                                }
                            }

                            if (tb.Rows.Count == 0)
                            {
                                Wait();
                                continue;
                            }

                            //eventLog.WriteEntry(tb.Rows.Count.ToString());                        

                            for (int r = 0; r < tb.Rows.Count; r++)
                            {
                                RefNo = "";
                                ID = 0;

                                try
                                {
                                    //eventLog.WriteEntry("SL: " + tb.Rows[r]["SL"].ToString());

                                    ID = (long)tb.Rows[r]["ID"];
                                    RefNo = tb.Rows[r]["RefID"].ToString();
                                    Amount = double.Parse(tb.Rows[r]["Amount"].ToString());
                                    ApplicantName = tb.Rows[r]["FullName"].ToString().ToUpper();
                                    EmailTo = tb.Rows[r]["EmailTo"].ToString();
                                    Type = tb.Rows[r]["Type"].ToString();
                                    AttachmentID = tb.Rows[r]["Attachment"].ToString();

                                    try
                                    {
                                        MailCC = tb.Rows[r]["CC"].ToString().Split(',');
                                    }
                                    catch (Exception) { }

                                    try
                                    {
                                        MailBCC = tb.Rows[r]["BCC"].ToString().Split(',');
                                    }
                                    catch (Exception) { }


                                    if (EmailType == "EXCHANGE")
                                    {
                                        try
                                        {
                                            ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2013);
                                            service.Url = new Uri(ExchangeUrl);

                                            ServicePointManager.ServerCertificateValidationCallback =
                                                delegate (Object obj, X509Certificate certificate, X509Chain chain, SslPolicyErrors error)
                                                { return true; };
                                            service.UseDefaultCredentials = false;
                                            service.Credentials = new WebCredentials(ExchangeUserName, ExchangeUserPassword, ExchangeDomain);

                                            EmailMessage message = new EmailMessage(service);
                                            message.Subject = string.Format("{0}", tb.Rows[r]["Subject"]);
                                            message.Body = new MessageBody(BodyType.HTML, string.Format("{0}", tb.Rows[r]["Body"]).Replace("\n", "<br />"));

                                            if (isEmailAddress(EmailTo) == false)
                                            {
                                                Email_Update(ID, false);
                                                AddError(LogFile, "Invalid Email:" + EmailTo);
                                                continue;
                                            }

                                            message.ToRecipients.Add(EmailTo);

                                            foreach (string cc_ in MailCC)
                                            {
                                                if (cc_.Trim().Length > 0 && isEmailAddress(cc_))
                                                    message.CcRecipients.Add(cc_);
                                            }

                                            foreach (string bcc_ in MailBCC)
                                            {
                                                if (bcc_.Trim().Length > 0 && isEmailAddress(bcc_))
                                                    message.BccRecipients.Add(bcc_);
                                            }

                                            if (Type.ToUpper() == "PASSPORT" && AttachmentID.Length > 1)
                                            {

                                                Passport_Receipt.Receipt receipt = new Passport_Receipt.Receipt();
                                                try
                                                {
                                                    myByteArray = null;
                                                    myByteArray = receipt.getReceiptBytesFromCrystalReport(RefNo, Amount, ApplicantName, "");
                                                    message.Attachments.AddFileAttachment(AttachmentID + ".pdf", myByteArray);
                                                    message.Send();
                                                    Email_Update(ID, true);
                                                }
                                                catch (Exception ex)
                                                {
                                                    eventLog.WriteEntry("Attachment Error: " + RefNo + " " + ApplicantName + " " + Amount.ToString() + " " + ex.Message);
                                                    Email_Update(ID, false);
                                                }
                                            }
                                            else
                                            {
                                                message.Send();
                                                Email_Update(ID, true);
                                            }
                                        }
                                        catch(Exception ex)
                                        {
                                            eventLog.WriteEntry(ex.Message);
                                        }
                                    }
                                    else
                                    {
                                        mailMsg = new MailMessage();
                                        mailMsg.IsBodyHtml = true;
                                        mailMsg.To.Add(EmailTo);
                                        System.Net.Mail.Attachment attach = null;

                                        //if (Email1.ToLower() != "ashik.email@gmail.com") continue;

                                        if (Type.ToUpper() == "PASSPORT" && AttachmentID.Length > 1)
                                        {
                                            Passport_Receipt.Receipt receipt = new Passport_Receipt.Receipt();

                                            myByteArray = receipt.getReceiptBytesFromCrystalReport(RefNo, Amount, ApplicantName, "");
                                            //Stream ms = new Stream(myByteArray);
                                            attach = new System.Net.Mail.Attachment(new MemoryStream(myByteArray), AttachmentID + ".pdf");
                                        }

                                        client = new SmtpClient(getValue("TblMailServer"), int.Parse(getValue("TblMailServerPort")));
                                        client.Credentials = new NetworkCredential(getValue("TblUserName"), getValue("TblPassword"), ExchangeDomain);
                                        client.EnableSsl = false;
                                        mailMsg.From = new MailAddress(getValue("TblEmailFrom"), getValue("TblEmailName"));

                                        try
                                        {
                                            foreach (string cc in MailCC)
                                                mailMsg.CC.Add(cc);
                                        }
                                        catch (Exception) { }
                                        try
                                        {
                                            foreach (string bcc in MailBCC)
                                                mailMsg.Bcc.Add(bcc);
                                        }
                                        catch (Exception) { }

                                        mailMsg.Subject = string.Format("{0}", tb.Rows[r]["Subject"]);
                                        mailMsg.Body = string.Format("{0}", tb.Rows[r]["Body"]);
                                        //mailMsg.Body = string.Format("{0}", mailMsg.Body);
                                        if (attach != null)
                                            mailMsg.Attachments.Add(attach);
                                        client.Send(mailMsg);

                                        Email_Update(ID, true);
                                    }

                                    //eventLog.WriteEntry("Email Sent: " + RefNo + " To: " + EmailTo + " Bcc: " + MailBCCs);
                                }
                                catch (Exception ex)
                                {
                                    Email_Update(ID, false);
                                    eventLog.WriteEntry(ex.Message);
                                    AddError(LogFile, ex.Message);
                                }
                            }
                            //eventLog.WriteEntry("Step");


                        }
                    }
                    catch (Exception exx)
                    {
                        eventLog.WriteEntry("Error 1: " + exx.Message);
                        Wait(20);
                    }
                }   //end while
            }
            catch (Exception ex)
            {
                eventLog.WriteEntry("Error 0: " + ex.Message);
            }
        }

        private void Email_Update(long ID, bool EmailSent)
        {
            string Query = "s_Email_Update";
            SqlConnection oConn = null;
            SqlCommand oCommand;

            try
            {
                oConn = new SqlConnection(PaymentsDBConnectionString);
                oCommand = new SqlCommand(Query, oConn);
                oCommand.CommandType = CommandType.StoredProcedure;
                oCommand.Parameters.Add("@ID", SqlDbType.BigInt).Value = ID;
                oCommand.Parameters.Add("@EmailSent", SqlDbType.Bit).Value = EmailSent;

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                int i = oCommand.ExecuteNonQuery();
            }
            catch (Exception)
            {
            }
            finally
            {
                if (oConn.State != ConnectionState.Closed)
                    oConn.Close();
            }
        }

        private bool isEmailAddress(string emailAddress)
        {
            //string patternLenient = @"\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
            //Regex reLenient = new Regex(patternLenient);

            string patternStrict = @"^(([^<>()[\]\\.,;:\s@\""]+"
                  + @"(\.[^<>()[\]\\.,;:\s@\""]+)*)|(\"".+\""))@"
                  + @"((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
                  + @"\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+"
                  + @"[a-zA-Z]{2,}))$";
            Regex reStrict = new Regex(patternStrict);

            //bool isLenientMatch = reLenient.IsMatch(emailAddress);
            //return isLenientMatch;

            bool isStrictMatch = reStrict.IsMatch(emailAddress);
            return isStrictMatch;
        }
    }
}