using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class CheckoutNotify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
     
       NotifyTransaction();

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        //SMS_Webservice.SmsClient sms = new SMS_Webservice.SmsClient();
        //Label1.Text = sms.PushSMS(txtMobileNo.Text, txtMessage.Text, 5, 2, "E561AE5E-8D1F-44CF-896E-438A99F83E2D");
       
       NotifyTransaction();
    }
    private string getValue(string Key)
    {
        try
        {
            return string.Format("{0}", ConfigurationSettings.AppSettings[Key]);
        }
        catch (Exception) { return ""; }
    }
    private void NotifyTransaction()
    {
        string PaymentsDBConnectionString = "";
        SqlConnection oConn = new SqlConnection(); ;
        SqlCommand oCommand;
        string Query = "s_APIBaseTransactionNotificationSelection";
        oConn.ConnectionString = ConfigurationManager.ConnectionStrings["TransNotifyConnectionString"].ConnectionString;
    
        DataTable tb = null;
        try
        {

            System.Data.SqlClient.SqlConnection.ClearAllPools();

            oCommand = new SqlCommand("SELECT 1", oConn);
            if (oConn.State == ConnectionState.Closed)
                oConn.Open();
            oCommand.ExecuteNonQuery();

            if (oConn.State != ConnectionState.Closed)
                oConn.Close();
        }
        catch (Exception eee)
        {

        }

        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["TransNotifyConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand(Query, conn))
            {
                cmd.Parameters.Add(new SqlParameter("@NoOfNotification", 1));
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



        for (int r = 0; r < tb.Rows.Count; r++)
        {
          
        string notificationID = "";
            string transactionID = "";
            string transactionDT ="";
            string transactionParticular = "";
            string transactionAmount = "";
            string transactionSource = "";
            string transactionRemarks = "";
            string transactionType = "";
            string pushTimeStamp="";
            string legs = "1";
            string bankName = "";
            string branchCode = "";

            string notifyUrl = "";
            string postingMethod = "";
            HttpWebRequest req = null;
            string _statusCode = "";
            try
            {
        

            notificationID = tb.Rows[r]["APIBaseTransactionNotificationID"].ToString();
            transactionID = String.Format("{0:yyMMdd}", tb.Rows[r]["SystemTransactionDateTime"]) + tb.Rows[r]["TraceNo"].ToString().Substring(10);
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

            // //  notifyUrl = tb.Rows[r]["NotifyingURL"].ToString();
            notifyUrl = "https://gw.bkash.com:9081/BankService/transaction/receiver";
               // postingMethod = tb.Rows[r]["PostingMethod"].ToString();

                string ReqXmlDoc = getReqXmlDoc( transactionID,  transactionDT,  transactionParticular,  transactionAmount,  transactionSource,  transactionRemarks,  transactionType, pushTimeStamp,  legs,  bankName,  branchCode);


            //--
            FromFile(ReqXmlDoc);



            //    ////---------------

            //    byte[] postBytes = Encoding.ASCII.GetBytes("Request=" + ReqXmlDoc);
            //    req.ContentType = "application/x-www-form-urlencoded";
            //    req.ContentLength = postBytes.Length;


            //--------------------------------------

          

                //string Query_Status = "s_APIBaseTransactionNotificationSendingStatusSet";
                //using (SqlConnection conn = new SqlConnection())
                //{
                //    conn.ConnectionString = ConfigurationManager.ConnectionStrings["TransNotifyConnectionString"].ConnectionString;

                //    using (SqlCommand cmd = new SqlCommand(Query_Status, conn))
                //    {
                //        cmd.Parameters.Add(new SqlParameter("@NotificationID", notificationID));
                //        cmd.Parameters.Add(new SqlParameter("@NotificationID", notificationID));
                //        cmd.Parameters.Add(new SqlParameter("@NotificationID", notificationID));
                //        cmd.Parameters.Add(new SqlParameter("@NotificationID", notificationID));
                //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                //        cmd.Connection = conn;
                //        if (conn.State == ConnectionState.Closed)
                //            conn.Open();

                //        SqlDataReader oReader = cmd.ExecuteReader();

                //        //using (SqlDataReader dr = cmd.ExecuteReader())
                //        {
                //            tb = new DataTable();
                //            tb.Load(oReader);
                //        }
                //        oReader.Close();
                //    }
                //}

            }
            catch (Exception ex)
            {
                //Email_Update(ID, false);
                //eventLog.WriteEntry(ex.Message);
                //AddError(LogFile, ex.Message);
            }
        }
      
    }

    private static void FromFile(string ReqXmlDoc)
    {
        try
        {
            var certificate = @"F:\Document\Others\Integration to bKash\Cert\ibanking.tblbd.com_EV.pfx";
            var certpwd = "Trust@1234";
            var URL = "https://gw.bkash.com:9081/BankService/transaction/receiver";
            var certs = new X509Certificate2Collection();
            certs.Import(certificate, certpwd, X509KeyStorageFlags.DefaultKeySet);

            var webrequest = WebRequest.Create(URL) as HttpWebRequest;

            ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3;
            ServicePointManager.Expect100Continue = false;
            ServicePointManager.ServerCertificateValidationCallback += new RemoteCertificateValidationCallback(AlwaysGoodCert);
            webrequest.ClientCertificates.Add(certs[0]);

            String username = "TBL";
            String password = "694oO9#efg!007kgG@741";

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
                    string statusCode = xn["statusCode"].InnerText;
                   
                }
            }

 
        }
        catch (Exception ex)
        {

        }
    }

    private static bool AlwaysGoodCert(object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslpolicyerrors)
    {
        return true;
    }


    private string getReqXmlDoc(string transactionID, string transactionDT, string transactionParticular, string transactionAmount, string transactionSource, string transactionRemarks, string transactionType, string pushTimeStamp, string legs,string bankName,string branchCode)
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