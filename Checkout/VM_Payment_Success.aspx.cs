using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using Crypto;
using System.Web;
using System.Xml;
using System.Net;
using System.IO;
using System.Text;
using System.Net.Sockets;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;

public partial class VM_Payment_Success : System.Web.UI.Page
{
    string RefID = "";
    string TransactionID = "";
    string Status = "";
    //string Referrer = "";
    string PageUrl = "";
    string Keycode = "";
    //string PaymentType = "";
    string PAN = "";
    string ItclOrderID = "";
    string SenderAcc = "";
    string xmlmsg = "";
    string xmlstr = "";
    string ITCL_OrderStatus = "";
    string OrderDescription = "";
    string OrderID = "";
    string Amount = "0";
    string MerchantType = "VM";
    string StatusDB = "";
    string PayType = "";
    DataTable CheckoutPaymentDT;
    string OrderStatus = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            xmlmsg = Request.Form["response"];

            if (!xmlmsg.Contains("<"))
                xmlstr = DecryptConnectionString(xmlmsg);
            else
                xmlstr = xmlmsg;
        }
        catch (Exception ex) { llbStatus.Text = ex.Message; }

        string order_id = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_ITCL_Response_Insert";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                XmlDocument x = new XmlDocument();
                x.LoadXml(xmlstr.Trim());

                try
                {
                    Amount = x.SelectSingleNode("/Response/Amount").InnerText;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                }
                catch (Exception) { }
                try
                {
                    OrderStatus = x.SelectSingleNode("/Response/Tran_Status").InnerText.ToUpper();
                    cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = OrderStatus;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value
                        = x.SelectSingleNode("/Response/Currency").InnerText;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value
                        = x.SelectSingleNode("/Response/Tran_Type").InnerText;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value
                    = x.SelectSingleNode("/Response/RRN").InnerText;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@OrderDescription", System.Data.SqlDbType.VarChar).Value
                        = x.SelectSingleNode("/Response/Service").InnerText;
                }
                catch (Exception) { }
                try
                {
                    PAN = x.SelectSingleNode("/Response/PAN").InnerText;
                    cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                }
                catch (Exception) { }
                try
                {
                    order_id = x.SelectSingleNode("/Response/Tran_ID").InnerText;
                    TransactionID = order_id;
                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = order_id;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@Brand", System.Data.SqlDbType.VarChar).Value
                    = x.SelectSingleNode("/Response/Cardtype").InnerText;
                }
                catch (Exception) { }
                try
                {
                    cmd.Parameters.Add("@xmlmsg", System.Data.SqlDbType.VarChar).Value = xmlstr;
                }
                catch (Exception) { }

                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "VM";

                cmd.Connection = conn;
                conn.Open();

                if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                cmd.ExecuteNonQuery();
            }
        }

        CheckoutPaymentDT = new DataTable();
        

        int length = order_id.Trim().Length;
        bool ItclOrderStatus;            

        if (length == 0)
        {
            ItclOrderStatus = false;
        }
        else
        {
            RefID = order_id;
            getCheckout_Ref_Details(RefID);
            ItclOrderStatus = GetOrderStatus(
                        CheckoutPaymentDT.Rows[0]["UID"].ToString(),
                        CheckoutPaymentDT.Rows[0]["TerminalID"].ToString(),
                        CheckoutPaymentDT.Rows[0]["ItclOrderID"].ToString(),
                        CheckoutPaymentDT.Rows[0]["RefID"].ToString()
                        );
                
        }

            
        if (ItclOrderStatus == true)     //Later: ITCL Get Order Status webservice check
            //visible = true;

        {                
            DataTable DT = Save_Payments_Checkout_Success(RefID, ItclOrderID, TransactionID, PAN, "VM", 0);
            if (DT != null)
            {
                string MerchantUrl = RedirectToMerchantURL(CheckoutPaymentDT.Rows[0]["MarchentID"].ToString());
                RedirectMerchantUrl(MerchantUrl);
            }
            else
            {
                Response.Clear();
                Common.WriteLog(Request.Url.OriginalString,
                    string.Format("Error: 101: Failed to update the Transaction: {0}, RefID: {1}",
                    TransactionID,
                    RefID));
                llbStatus.Text += "Failed to update the Transaction. (1)";                    
                return;
            }
        }
        else
        {
            Response.Clear();
            Common.WriteLog(Request.Url.OriginalString,
                string.Format("Error: 102: Failed to update the Transaction: {0}, RefID: {1}",
                TransactionID,
                RefID));
            llbStatus.Text += ("Failed to update the Transaction. (2)");
            return;
        }
        
        
    }

    private void getCheckout_Ref_Details(string _RefID)
    {
        using (SqlDataAdapter da = new SqlDataAdapter())
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Ref_Details";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = _RefID;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed) conn.Open();

                    da.SelectCommand = cmd;
                    da.Fill(CheckoutPaymentDT);
                }
            }
        }
    }

    private string DecryptConnectionString(string connectionString)
    {
        string result = "";

        bool app = true;

        if (app == true)
        {
            Byte[] b = Convert.FromBase64String(connectionString);
            string decryptedConnectionString = System.Text.ASCIIEncoding.ASCII.GetString(b);
            result = decryptedConnectionString;
        }
        else if (app == false)
        {
            result = connectionString;
        }

        return result;
    }

    private DataTable Save_Payments_Checkout_Success(string _RefID, string _ItclOrderID, string _TransactionID, string _PAN, string _TransactionType, long SenderAcc)
    {
        //bool RetVal = false;
        

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Success";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = _TransactionID;
                cmd.Parameters.Add("@ItclOrderID", System.Data.SqlDbType.VarChar).Value = _ItclOrderID;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = _RefID;
                cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = _PAN;
                cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = _TransactionType;
                if (SenderAcc > 0)
                    cmd.Parameters.Add("@SenderAcc", System.Data.SqlDbType.BigInt).Value = SenderAcc;


                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = false;
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    DataTable tb = new DataTable();
                    tb.Load(dr);
                    return tb;
                }                

                //RetVal = (bool)sqlDone.Value;
            }
        }
    }

    public string Encrypt(object value)
    {
        string RetVal = string.Empty;
        RetVal = HttpUtility.UrlEncode(StringCipher.Encrypt(value.ToString()));
        return RetVal;
    }

    private string RedirectToMerchantURL(string MerchantType)
    {
        string PaymentPostUrl = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_MerchantUrlRedirect";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@MerchantType", System.Data.SqlDbType.VarChar).Value = MerchantType;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
              
                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        PaymentPostUrl = sdr["PaymentGetUrl"].ToString();
                        OrderID = sdr["OrderID"].ToString();
                        StatusDB = sdr["Status"].ToString();
                        PayType = sdr["Type"].ToString();
                    }
                }
            }
        }
        return PaymentPostUrl;
    }


    private void RedirectMerchantUrl(string redirectUrl)
    {
        double _Amount = 0;
        _Amount = double.Parse(Amount.Replace(",", ""));
        //string ReqXmlDoc = "";

        //ReqXmlDoc = getReqXmlDoc(Amount, "050", RefID, "Test");
        //HttpWebRequest req = null;


        UrlDataSet.UrlVersDataTable dt = new UrlDataSet.UrlVersDataTable();
            UrlDataSet.UrlVersRow oRow = dt.NewUrlVersRow();

            oRow.RefID = RefID;
            oRow.Amount = _Amount;
            oRow.OrderID = OrderID;
            oRow.Status = StatusDB;
            oRow.PayType = PayType;
            redirectUrl = getReplacedUrl(redirectUrl, oRow);


            string _xmlresponse_Msg = "";
            bool _xmlresponse = false;

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Get_XML_Response_Param";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ItclOrderID", System.Data.SqlDbType.VarChar).Value = null;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;


                    cmd.Connection = conn;
                    conn.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            _xmlresponse = (bool)sdr["AllowXmlResponce"];
                            _xmlresponse_Msg = EncodeTo64(sdr["Checkout_Xml_Msg"].ToString());
                        }
                    }
                    // cmd.ExecuteNonQuery();
                    // _payment_success_url = string.Format("{0}", sqlPaymentSuccessUrl.Value);
                    // _xmlresponse_Msg = string.Format("{0}", sqlXmlResponceMsg.Value);
                    //_xmlresponse = (bool)sqlXmlResponse.Value;
                }
            }

            if (_xmlresponse)
            {
                Post_XMLResponse_Msg(redirectUrl, _xmlresponse_Msg, OrderID, StatusDB, PayType, RefID, _Amount);
            }


        //req = (HttpWebRequest)WebRequest.Create(redirectUrl);
        //req.KeepAlive = false;
        //req.AllowAutoRedirect = false;
        //req.ProtocolVersion = HttpVersion.Version11;
        //req.Method = "POST";
        //req.ContentType = "application/x-www-form-urlencoded";

        //string postContent = string.Format("OrderID={0}&amount={1}&refid={2}", "Hello", 1.00,"12345678912345");

        //byte[] postBytes = Encoding.ASCII.GetBytes(postContent);
        //req.ContentLength = postBytes.Length;
        //Stream requestStream = req.GetRequestStream();
        //requestStream.Write(postBytes, 0, postBytes.Length);
        //requestStream.Close();

        //  Response.Redirect(string.Format("{0}?",redirectUrl), true);
        // Response.Redirect(string.Format("http://www.reb.gov.bd?OrderID={0}&amount={1}&refid={2}", "OrderID-111", 11.00, "123456789"), true);

        try
            {
                Response.Redirect(string.Format("{0}", redirectUrl), true);


                //Make a request            
                //HttpWebRequest request = (HttpWebRequest)WebRequest.Create(redirectUrl);
                //request.Method = "POST";
                //request.ContentType = "application/x-www-form-urlencoded";
                //request.AllowAutoRedirect = true;

                ////Put the post data into the request
                //byte[] data = (new ASCIIEncoding()).GetBytes(postContent);
                //request.ContentLength = data.Length;
                //Stream reqStream = request.GetRequestStream();
                //reqStream.Write(data, 0, data.Length);
                //reqStream.Close();
                //Response.Redirect(string.Format("{0}?", redirectUrl), true);
            }
            catch (Exception ex)
            {
                //Common.WriteLog("RedirectMerchantUrl", ex.Message);
                //PanelError.Visible = true;
                //PanelError.Controls.Add(new LiteralControl(ex.Message + "<br />" + "Error Accessing Q-Cash Server, please try later. (1)"));
                //return;
            }

        return;
    }

    private void Post_XMLResponse_Msg(string _payment_success_url, string _xmlresponse_Msg, string _merchant_order_id, string _payment_status, string _payment_type, string _ref_id, Double Amount)
    {
        string redirectUrl = "";
        UrlDataSet.UrlVersDataTable dt = new UrlDataSet.UrlVersDataTable();
        UrlDataSet.UrlVersRow oRow = dt.NewUrlVersRow();

        oRow.RefID = _ref_id;
        oRow.Amount = Amount;
        oRow.OrderID = _merchant_order_id;
        oRow.Status = _payment_status;
        oRow.PayType = _payment_type;
        redirectUrl = getReplacedUrl(_payment_success_url, oRow);

        //string postbackUrl = "Checkout_Payment.aspx";

        Response.Clear();
        StringBuilder sb = new StringBuilder();
        sb.Append("<html>");
        sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
        sb.AppendFormat("<form name='form' action='{0}' method='POST'>", redirectUrl);
        //    sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", "TEST_" + Session.SessionID.ToString().ToUpper());
        sb.AppendFormat("<input type='hidden' name='CheckoutXmlMsg' value='{0}'>", _xmlresponse_Msg);

        // Other params go here
        sb.Append("</form>");
        sb.Append("</body>");
        sb.Append("</html>");
        Response.Write(sb.ToString());
        Response.End();
    }

    static public string EncodeTo64(string toEncode)
    {
        byte[] toEncodeAsBytes
              = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
        string returnValue
              = System.Convert.ToBase64String(toEncodeAsBytes);
        return returnValue;
    }

    private string GetStatus()
    {
        String status = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Get_Status";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
             
                SqlParameter sqlDone = new SqlParameter("@Status", System.Data.SqlDbType.VarChar, 10);
                sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                status = string.Format("{0}", sqlDone.Value);
               
            }
        }
        return status;
    }

    private string getReplacedUrl(string Redirect, UrlDataSet.UrlVersRow oRow)
    {
        string[] Vers = Redirect.Split('{');

        if (Vers.Length < 2) return Redirect;


        for (int i = 1; i < Vers.Length; i++)
            Vers[i] = Vers[i].Split('}')[0];

        for (int i = 1; i < Vers.Length; i++)
        {
            Redirect = Redirect.Replace("{" + Vers[i] + "}", oRow[Vers[i]].ToString());
        }

        return Redirect;
    }

    private bool TBMMpaymentInfoCheck(string TrnID, string AccNo, double _Amount)
    {
        //return true;

        bool RetVal = false;
        double TBMM_Amount = 0;
        string TBMM_Amount_S = "";

        try
        {
            System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate (object sender, X509Certificate certificate, X509Chain chain, SslPolicyErrors sslPolicyErrors) { return true; };
            MBPayCheckService.CheckMerchantTransaction service 
                = new MBPayCheckService.CheckMerchantTransaction();
            //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");
            TBMM_Amount_S = service.GetTransactionInfo(TrnID, AccNo);

            TBMM_Amount = double.Parse(TBMM_Amount_S.Trim());
            if (TBMM_Amount >= _Amount)
                RetVal = true;

            Tbmm_PaymentVerifyLog(TrnID, AccNo, _Amount, TBMM_Amount);
        }
        catch (Exception ex) 
        {
            Common.WriteLog(
                    string.Format(
                        "CheckMerchantTransactionService: TrnID: {0}, AccNo: {1}, TBMM_Amount: {2}, _Amount: {3}"
                        , TrnID
                        , AccNo
                        , TBMM_Amount_S
                        , _Amount)
                , ex.Message);
        }

        return RetVal;
    }

    private void Tbmm_PaymentVerifyLog(string TrnID, string AccNo, double _Amount, double Return_Amount)
    {

        try
        {
            using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMM_GetTransactionInfo_Log";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@TxCode", System.Data.SqlDbType.VarChar).Value = TrnID;
                    cmd.Parameters.Add("@MerchantMobile", System.Data.SqlDbType.VarChar).Value = AccNo;
                    cmd.Parameters.Add("@PaidAmount", System.Data.SqlDbType.Decimal).Value = _Amount;
                    cmd.Parameters.Add("@ReturnAmount", System.Data.SqlDbType.Decimal).Value = Return_Amount;

                    cmd.Connection = conn;

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                    //isSaved = true;

                }
            }
        }
        catch (Exception ex)
        {

            Common.WriteLog("s_Itcl_GetOrderStatus_Log", string.Format("{0}", ex.Message));
        }
    }

    //private Boolean GetOrderStatus_(string _MerchantID, string _TerminalID, string _ORDERID, string _SESSIONID,int hostPort)
    //{
    //    string ReqXmlDoc = "";
    //    String path = "/Exec";
    //    ReqXmlDoc = getReqXmlDoc(_MerchantID, _TerminalID, _ORDERID, _SESSIONID); ;
    //    string postbackUrl = Common.getValueOfKey("VM_GetOrderStatus");


    //    Response.Clear();
    //    StringBuilder sb = new StringBuilder();
    //    sb.Append("<html>");
    //    sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
    //    sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
    //    sb.AppendFormat("<textarea name='Request' id='Request' style='display:none'>");
    //    sb.AppendFormat(ReqXmlDoc);
    //    sb.AppendFormat("</textarea>");
    //    //sb.AppendFormat("<input type='submit' value='Go to Next Step' />");
    //    // Other params go here
    //    sb.Append("</form>");
    //    sb.Append("</body>");
    //    sb.Append("</html>");
    //    Response.Write(sb.ToString());
    //    Response.End();

    //    string headers;
    //    string response = "";

    //    Socket sk = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
    //    System.Net.IPAddress remoteIPAddress = System.Net.IPAddress.Parse(hostName);
    //    System.Net.IPEndPoint remoteEndPoint = new System.Net.IPEndPoint(remoteIPAddress, hostPort);
    //    headers = "POST " + path + " HTTP/1.0\r\n";
    //    //headers += "Host: " + hostName + "\r\n";
    //    headers += "Content-type: application/x-www-form-urlencoded\r\n";
    //    headers += "Content-Length: " + ReqXmlDoc.Length + "\r\n\r\n";
    //    headers += ReqXmlDoc;

    //    TcpClient tcpClient;
    //    tcpClient = new TcpClient(hostName, hostPort);
    //    NetworkStream networkStream;
    //    StreamWriter streamWriter;
    //    StreamReader streamReader;

    //    networkStream = tcpClient.GetStream();

    //    streamWriter = new StreamWriter(networkStream);
    //    streamReader = new StreamReader(networkStream);

    //    streamWriter.WriteLine(headers);
    //    streamWriter.Flush();

    //    response = streamReader.ReadToEnd();

    //    try
    //    {
    //        return GetPreponseData(response, _ORDERID, RefID, _MerchantID);
    //    }
    //    catch (Exception ee)
    //    {
    //        return false;
    //    }
    //    finally
    //    {
    //        tcpClient.Close();
    //    }

    //}

    private Boolean GetOrderStatus(string _MerchantID, string _TerminalID, string _ORDERID, string _MerchantTransactionID)
    {
        string ReqXmlDoc = "";
        string responseText = "";
        string VM_Auth = "";
        //string _ORDERID = "";
        //string _SESSIONID = "";
        //string _MerchantID = "";
        //if (CheckoutPaymentDT.Rows.Count>0)
        //{
        //    _ORDERID = CheckoutPaymentDT.Rows[0]["ItclOrderID"].ToString();
        //    _SESSIONID = CheckoutPaymentDT.Rows[0]["SessionID"].ToString();
        //    _MerchantID = CheckoutPaymentDT.Rows[0]["UID"].ToString();
        //}

        ReqXmlDoc = getReqXmlDoc(_MerchantID, _TerminalID, _MerchantTransactionID);
     
        HttpWebRequest req = null;
        string PROXY_SERVER = "";
        int PROXY_PORT = 0;

        try
        {
            VM_Auth = Common.getValueOfKey("VM_Auth");
            PROXY_SERVER = Common.getValueOfKey("PROXY_SERVER");
            PROXY_PORT = int.Parse(Common.getValueOfKey("PROXY_PORT"));
        }
        catch (Exception) { }

        try
        {
            ServicePointManager.CheckCertificateRevocationList = false;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                 | SecurityProtocolType.Ssl3
                  | SecurityProtocolType.Tls11
                   | SecurityProtocolType.Tls12;
            ServicePointManager.Expect100Continue = true;

            //ServicePointManager.CertificatePolicy = new MyPolicy();
            //ServicePointManager.CheckCertificateRevocationList = false;

            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };


            string VM_PostUrl = Common.getValueOfKey("VM_GetOrderStatus");

            //using (WebClient client = new WebClient())
            //{
            //    try
            //    {
                    WebProxy wp = new WebProxy(PROXY_SERVER, PROXY_PORT);
            //        client.Proxy = wp;
            //        ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            //        //client.Headers.Add(HttpRequestHeader.ContentType, "application/xml");
            //        client.Headers.Add(HttpRequestHeader.Authorization, "Basic " + VM_Auth);
            //        llbStatus.Text += VM_Auth;
            //        byte[] response =
            //            client.UploadValues(
            //                VM_PostUrl, "POST", new System.Collections.Specialized.NameValueCollection()
            //                {
            //                    { "Request", ReqXmlDoc }
            //                });

            //        responseText = System.Text.Encoding.UTF8.GetString(response);
            //        llbStatus.Text += responseText;
            //    }
            //    catch (Exception cex)
            //    {
            //        llbStatus.Text += "<div>1. " + cex.Message + "</div>";
            //        return false;
            //    }
            //    //eventLog.WriteEntry(content);
            //}

            //
            HttpWebRequest request1 = (HttpWebRequest)WebRequest.Create(VM_PostUrl);
            byte[] bytes;
            bytes = System.Text.Encoding.ASCII.GetBytes(ReqXmlDoc);
            request1.ContentType = "application/xml; encoding='utf-8'";
            request1.ContentLength = bytes.Length;
            request1.Method = "POST";
            request1.Headers.Add(HttpRequestHeader.Authorization, "Basic " + VM_Auth);
            Stream requestStream = request1.GetRequestStream();
            requestStream.Write(bytes, 0, bytes.Length);
            requestStream.Close();
            HttpWebResponse response;
            response = (HttpWebResponse)request1.GetResponse();
            if (response.StatusCode == HttpStatusCode.OK)
            {
                Stream responseStream = response.GetResponseStream();
                responseText = new StreamReader(responseStream).ReadToEnd();
            }
            //

            llbStatus.Text += responseText;

            return CheckApproved(responseText);

            //req = (HttpWebRequest)WebRequest.Create(VM_PostUrl);
            //req.KeepAlive = false;
            //req.AllowAutoRedirect = true;
            //req.ProtocolVersion = HttpVersion.Version11;
            //req.Method = "POST";
            //req.ContentType = "application/x-www-form-urlencoded";
            //byte[] postBytes = Encoding.ASCII.GetBytes("Request=" + ReqXmlDoc);
            ////req.ContentType = "application/x-www-form-urlencoded";
            //req.ContentLength = postBytes.Length;

            //if (PROXY_SERVER != "")
            //{
            //    WebProxy wp = new WebProxy(PROXY_SERVER, PROXY_PORT);
            //    req.Proxy = wp;
            //}

            //Stream requestStream = req.GetRequestStream();
            //requestStream.Write(postBytes, 0, postBytes.Length);
            //requestStream.Close();
        }
        catch (Exception ex)
        {
            llbStatus.Text += "<div>2. " + ex.Message + "</div>";
            SaveITCLUnApprovedDataLog(_ORDERID, RefID, _MerchantID, ITCL_OrderStatus.ToUpper(), "", ex.Message);          
        }

        //try
        //{
        //    using (HttpWebResponse response = (HttpWebResponse)req.GetResponse())
        //    {
        //        using (Stream resStream = response.GetResponseStream())
        //        {
        //            try
        //            {                       
        //                var sr = new StreamReader(response.GetResponseStream());
        //                string responseText = sr.ReadToEnd();                        
        //                return CheckApproved(responseText);
        //            }
        //            catch (Exception)
        //            {
        //                return false;
        //            }
        //        }
        //    }
        //}
        //catch (Exception ee)
        //{
        //    return false;
        //}   

       return false;
    }

    private Boolean CheckApproved(string txt)
    {
        bool RetVal = false;

        if (txt.ToUpper().Contains("<STATUS>APPROVED<"))
            RetVal = true;

        return RetVal;
    }

    private Boolean GetPreponseData( string htmlMsg, string orderID, string RefID, string MerchantID)
    {
        try
        {
            int startPoint;
            int endPoint;
            string OrderID_Response = "";
            string OrderStatus = "";
            string statusCode = "";
            string xmlmsg = (string.Format("{0}",
                htmlMsg)).ToLower();

            try
            {
                startPoint = xmlmsg.IndexOf("<orderid>") + 9;
                endPoint = xmlmsg.IndexOf("</orderid>");
                OrderID_Response = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<orderstatus>") + 13;
                endPoint = xmlmsg.IndexOf("</orderstatus>");
                OrderStatus = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<status>") + 8;
                endPoint = xmlmsg.IndexOf("</status>");
                statusCode = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            //Common.WriteLog("responseText", string.Format("OrderID_Response:{0},OrderStatus:{1},statusCode:{2}", OrderID_Response, OrderStatus, statusCode));
            //Common.WriteLog("responseText", string.Format("orderID:{0},RefID:{1},MerchantID:{2}", OrderID_Response, RefID, MerchantID));
            
            if (orderID == OrderID_Response && OrderStatus.ToUpper().Trim() == "APPROVED")
            {
                SaveITCLUnApprovedDataLog(orderID, RefID, MerchantID, OrderStatus.ToUpper(), statusCode, "");                
                return true;
            }
            else
            {
                SaveITCLUnApprovedDataLog(orderID, RefID, MerchantID, OrderStatus.ToUpper(), statusCode, "");
                return false;
                // save orderid sessionid orderstatus statuscode datetime
            }
        }
        catch (Exception)
        {
            return false;
        }       
      
    }

    private void SaveITCLUnApprovedDataLog(string OrderID, string RefID, string UID, string OrderStatus, string StatusCode, string ErrorMsg)
    {
        try
        {
            using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Itcl_GetOrderStatus_Log";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@UID", System.Data.SqlDbType.VarChar).Value = UID;
                    cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = OrderStatus;
                    cmd.Parameters.Add("@StatusCode", System.Data.SqlDbType.VarChar).Value = StatusCode;
                    cmd.Parameters.Add("@ErrorMsg", System.Data.SqlDbType.VarChar).Value = ErrorMsg;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "VM";

                    cmd.Connection = conn;

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                    //isSaved = true;

                }
            }
        }
        catch (Exception ex) {

            Common.WriteLog("s_Itcl_GetOrderStatus_Log", string.Format("{0}", ex.Message));
        }
    }

    private string getReqXmlDoc(string _MerchantID, string _TerminalID, string _MerchantTransactionID)
    {
        XmlDocument doc = new XmlDocument();

        XmlNode docNode = doc.CreateXmlDeclaration("1.0", null, null);
        doc.AppendChild(docNode);

        XmlNode REQUESTNode = doc.CreateElement("REQUEST");
        doc.AppendChild(REQUESTNode);

        XmlNode OperationChild = doc.CreateElement("Operation");
        OperationChild.InnerText = "GetOrderStatus";
        REQUESTNode.AppendChild(OperationChild);        

        XmlNode MerchantChild = doc.CreateElement("MerchantID");
        MerchantChild.InnerText = _MerchantID;
        REQUESTNode.AppendChild(MerchantChild);

        XmlNode TerminalIDChild = doc.CreateElement("TerminalID");
        TerminalIDChild.InnerText = _TerminalID;
        REQUESTNode.AppendChild(TerminalIDChild);

        XmlNode OrderIDChild = doc.CreateElement("MerchantTransactionID");
        OrderIDChild.InnerText = _MerchantTransactionID;
        REQUESTNode.AppendChild(OrderIDChild);

        return doc.OuterXml;
    }
}