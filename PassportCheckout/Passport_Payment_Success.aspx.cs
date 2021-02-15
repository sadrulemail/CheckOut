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

public partial class Passport_Payment_Success : System.Web.UI.Page
{
    string RefID = "";
    string TransactionID = "";
    string Status = "";
    string Referrer = "";
    string PageUrl = "";
    string Keycode = "";
  //  string PaymentType = "";
    string PAN = "";
    string OrderID = "";
    string SenderAcc = "";
    string xmlmsg = "";
    string OrderDescription = "";
    DataTable CheckoutPaymentDT;
    string ITCL_OrderStatus = "";
    double Amount = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        //ShowError("Mejba is a good programmer.");
        //return;


        if (string.Format("{0}", Request.QueryString["ORDERID"]).Length > 0 
            && string.Format("{0}", Request.QueryString["SESSIONID"]).Length > 0)
        {
            //This is needed to get the ITCL ORDERID and SESSION for the first time
            Response.End();
            return;
        }

        //Common.WriteLog(Request.Url.OriginalString, "Page Url:Passport_Payment_Success.aspx");

        RefID = string.Format("{0}", Request.Form["BillingCode"]);
        if (RefID == "") RefID = string.Format("{0}", Request.QueryString["BillingCode"]);

        TransactionID = string.Format("{0}", Request.Form["tr_id"]);
        if (TransactionID == "") TransactionID = string.Format("{0}", Request.QueryString["tr_id"]);

        Status = string.Format("{0}", Request.Form["status"]);
        if (Status == "") Status = string.Format("{0}", Request.QueryString["status"]);

        Keycode = string.Format("{0}", Request.Form["keycode"]);
        if (Keycode == "") Keycode = string.Format("{0}", Request.QueryString["keycode"]);

        xmlmsg = string.Format("{0}", Request.Form["xmlmsg"]);
        if (xmlmsg == "") xmlmsg = string.Format("{0}", Request.QueryString["xmlmsg"]);
        
        SenderAcc = string.Format("{0}", Request.QueryString["SenderAcc"]);

        SqlConnection.ClearAllPools();
        CheckoutPaymentDT = new DataTable();

        try
        {
            
            Referrer = string.Format("{0}", this.Request.UrlReferrer.AbsoluteUri);
            //Response.Write(Referrer);
            Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
        }
        catch (Exception) { }

        if (Referrer == "")
        {
            try
            {
                string a = Request.ServerVariables["HTTP_HOST"];
                Referrer = string.Format("{0}", Request.ServerVariables["HTTP_ORIGIN"]);
                //Response.Write(Referrer);
                //Label1.Text = Referrer;
                Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
            }
            catch (Exception)
            {
                //Label1.Text = ex.Message; 
            }
        }


        PageUrl = Request.Url.OriginalString.Split('?')[0];


        if (TransactionID.Length == 0)
        {
            //ITCL

            string xmlstr = xmlmsg;
            if (!xmlmsg.Contains("<"))
                xmlstr = DecryptConnectionString(xmlmsg);
            //Common.WriteLog("xml", xmlstr);

            XmlDocument x = new XmlDocument();

            x.LoadXml(xmlstr);


            TransactionID = x.GetElementsByTagName("ApprovalCode")[0].InnerText;
            OrderID = x.GetElementsByTagName("OrderID")[0].InnerText;
            PAN = x.GetElementsByTagName("PAN")[0].InnerText;
            OrderDescription = x.GetElementsByTagName("OrderDescription")[0].InnerText;
            ITCL_OrderStatus = x.GetElementsByTagName("ApprovalCodeScr")[0].InnerText;
      


            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_ITCL_Response_Insert";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {                        
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                        cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("TransactionType")[0].InnerText;
                        cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Currency")[0].InnerText;
                        cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = decimal.Parse(x.GetElementsByTagName("PurchaseAmount")[0].InnerText) / 100;
                        cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ResponseCode")[0].InnerText;

                        string ResponseDescription = "";
                        try
                        {
                            ResponseDescription = x.GetElementsByTagName("ResponseDescription")[0].InnerText;
                        }
                        catch (Exception) { }
                        cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value = ResponseDescription;

                        cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("OrderStatus")[0].InnerText; ;
                        cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = TransactionID;
                        cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                        cmd.Parameters.Add("@xmlmsg", System.Data.SqlDbType.VarChar).Value = xmlstr;

                        cmd.Parameters.Add("@AcqFee", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("AcqFee")[0].InnerText;

                        string MerchantTranID = "";
                        try
                        {
                            MerchantTranID = x.GetElementsByTagName("MerchantTranID")[0].InnerText;
                        }
                        catch (Exception ex)
                        { Common.WriteLog("MerchantTranID", ex.Message); }
                        cmd.Parameters.Add("@MerchantTranID", System.Data.SqlDbType.VarChar).Value = MerchantTranID;

                        string CardHolderName = "";
                        try
                        {
                            CardHolderName = x.GetElementsByTagName("CardHolderName")[0].InnerText;
                        }
                        catch (Exception)
                        { }
                        cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = CardHolderName;

                        cmd.Parameters.Add("@Brand", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Brand")[0].InnerText;

                        string ThreeDSStatus = "";
                        try
                        {
                            ThreeDSStatus = x.GetElementsByTagName("ThreeDSStatus")[0].InnerText;
                        }
                        catch (Exception ex)
                        { Common.WriteLog("ThreeDSStatus", ex.Message); }
                        cmd.Parameters.Add("@ThreeDSStatus", System.Data.SqlDbType.VarChar).Value = ThreeDSStatus;

                        string ThreeDSVerificaion = "";
                        try
                        {
                            ThreeDSVerificaion = x.GetElementsByTagName("ThreeDSVerificaion")[0].InnerText;
                        }
                        catch (Exception ex)
                        { Common.WriteLog("ThreeDSVerificaion", ex.Message); }
                        cmd.Parameters.Add("@ThreeDSVerificaion", System.Data.SqlDbType.VarChar).Value = ThreeDSVerificaion;

                        cmd.Connection = conn;
                        conn.Open();

                        if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                        cmd.ExecuteNonQuery();                        
                    }
                }
            }
            catch (Exception ex)
            {
                Common.WriteLog("s_ITCL_Response_Insert", RefID + " " + ex.Message);
                ShowError("Failed to update the Transaction. (100)");
                return;
            }

            // check ITCL payment status(orderStatus) for payment confernation

            int length = OrderDescription.Trim().Length;
            bool ItclOrderStatus;

            if (length == 0)
            {
                ItclOrderStatus = false;
            }
            else
            {
                RefID = OrderDescription.Trim().Substring(length - 14, 14);
                //    MerchantType = OrderDescription.Trim().Substring(0, length - 15);
                if (getCheckout_Ref_Details())
                {
                    ItclOrderStatus = GetItclOrderStatus(
                              getValueOfKey("Passport_ITCL_UID"),
                             CheckoutPaymentDT.Rows[0]["OrderID"].ToString(),
                             CheckoutPaymentDT.Rows[0]["SessionID"].ToString(),
                             int.Parse(getValueOfKey("Passport_ITCL_PORT"))
                             );
                }
                else
                {
                    return;
                }

            }
            
         
            if (ItclOrderStatus == true)     //Later: ITCL Get Order Status webservice check
            //visible = true;
            {
                DataTable DT = Save_Payments_Passport_Success(RefID, OrderID, TransactionID, PAN, "ITCL", 0);
                if (DT != null)
                {
                //    string MerchantUrl = RedirectToMerchantURL(MerchantType);
                //    RedirectMerchantUrl(MerchantUrl);
                }
                else
                {
                    //Response.Clear();
                    Common.WriteLog(Request.Url.OriginalString,
                        string.Format("Error: 101: Failed to update the Transaction: {0}, RefID: {1}",
                        TransactionID,
                        RefID));
                    ShowError("Failed to update the Transaction. (101)");
                    return;
                }
            }

            else
            {
                //Response.Clear();
                Common.WriteLog(Request.Url.OriginalString,
                    string.Format("Error: 102: Failed to update the Transaction: {0}, RefID: {1}",
                    TransactionID,
                    RefID));
                ShowError("Failed to update the Transaction. (102)");
                return;
            }

            SqlDataSource1.SelectParameters.Add("TransactionID", TransactionID);
            SqlDataSource1.SelectParameters.Add("OrderID", OrderID);
            SqlDataSource1.SelectParameters.Add("PAN", PAN);
            SqlDataSource1.SelectParameters.Add("TransactionType", "ITCL");
            SqlDataSource1.DataBind();      
        }
        else
        {
            //Mobile Money
            if (!getCheckout_Ref_Details()) return;
            //s_TBMM_Response_Insert
            try
            {
                using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_TBMM_Response_Insert";
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;

                        cmd.Parameters.Add("@transaction_id", System.Data.SqlDbType.VarChar).Value = TransactionID;
                        cmd.Parameters.Add("@application_id", System.Data.SqlDbType.VarChar).Value = RefID;
                        cmd.Parameters.Add("@BillingCode", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", RefID);
                        cmd.Parameters.Add("@success", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", Request.Form["success"]);
                        cmd.Parameters.Add("@status", System.Data.SqlDbType.VarChar).Value = Status;

                        cmd.Connection = conn;

                        if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch(Exception ex)
            {
                Common.WriteLog("Error: 103: s_TBMM_Response_Insert", string.Format("TransactionID/txid: {0},RefID/Billcode: {1}, Status: {2}, success: {3},Ex: {3}",
                   TransactionID,
                   RefID,
                   Status,
                   Request.Form["success"],
                   ex.Message));

                ShowError("Response Data has not been Inserted. (103)");
                return;                
            }

            if (TransactionID.Length < 5 || RefID.Length != 14)
            {
                Common.WriteLog(Request.Url.OriginalString, string.Format("Error: 104: TransactionID/txid: {0},RefID/Billcode: {1}, Status: {2}, Keycode: {3}",
                   TransactionID,
                   RefID,
                   Status,
                   Keycode));
                ShowError("Invalid Request. (104)");
                return;
            }

          

      
          //  PaymentType = Common.getPayments_Passport_Type(RefID);

            if (Status.ToUpper().Trim() == "SUCCESS")
            {            
                try
                {
                    Amount = double.Parse(CheckoutPaymentDT.Rows[0]["Amount"].ToString());
                 
                    if (    //TBMM Webservice check
                        TBMMpaymentInfoCheck(
                            TransactionID,
                            getValueOfKey("TBMM_DIP_ACC"),
                            Amount) &&
                        Amount > 0 )  
                    {
                        //Payment Found in TBMM
                        DataTable DT = Save_Payments_Passport_Success(RefID, null, TransactionID, null,"MB", long.Parse(SenderAcc));
                        if (DT != null)
                        {
                          //  string MerchantUrl = RedirectToMerchantURL(CheckoutPaymentDT.Rows[0]["MarchentID"].ToString());
                            //Common.WriteLog("MerchantUrl", MerchantUrl);

                      
                            //return;
                        }
                        else
                        {
                            Common.WriteLog(Request.Url.OriginalString,
                                string.Format("Error: 104: Failed to update the Transaction: {0}, RefID: {1}",
                                TransactionID,
                                RefID));
                            ShowError("Failed to update the Transaction. (104)");
                            return;
                        }
                    }
                    else
                    {
                        ShowError("Insufficient Amount.");
                        return;
                    }

                    SqlDataSource1.SelectParameters.Add("TransactionID", TransactionID);
                    SqlDataSource1.SelectParameters.Add("RefID", RefID);
                    SqlDataSource1.SelectParameters.Add("SenderAcc", SenderAcc);
                    SqlDataSource1.SelectParameters.Add("TransactionType", "MB");
                    SqlDataSource1.DataBind();
                }
                catch (Exception ex)
                {
                    Common.WriteLog(
                    string.Format(
                        "Error: 105: CheckMerchantTransactionService: TrnID: {0}, RefID: {1}, SenderAcc: {2}"
                        , TransactionID
                        , RefID
                        , SenderAcc
                        )
                        , ex.Message);
                    ShowError("Failed to update the Transaction. (105)");
                    return;
                }
                //Redirect = string.Format("{0}&billcode={1}", Redirect, RefID);
                //Response.Redirect(Redirect, true);
            }
            else
            {
                Common.WriteLog(Request.Url.OriginalString, "Invalid Status:" + Status);

                ShowError("Transaction failed.");
                return;
            }
       
        }
    }


    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    private bool TBMMpaymentInfoCheck(string TrnID, string AccNo, double _Amount)
    {
        //return true;
        bool RetVal = false;
        double TBMM_Amount = 0;
        string TBMM_Amount_S = "";

        try
        {
            CheckMerchantTransaction.CheckMerchantTransactionSoapClient service
                = new CheckMerchantTransaction.CheckMerchantTransactionSoapClient();
            //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");
            TBMM_Amount_S = service.GetTransactionInfo(TrnID, AccNo);

            TBMM_Amount = double.Parse(TBMM_Amount_S.Trim());
            //if (TBMM_Amount == _Amount || TBMM_Amount > 0) RetVal = true;
            if (TBMM_Amount >= _Amount && _Amount > 0)
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
    private bool getCheckout_Ref_Details()
    {
        try
        {
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "[s_Passport_Ref_Details]";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(CheckoutPaymentDT);
                    }
                }
            }
            if (CheckoutPaymentDT.Rows.Count == 1)
            {
                return true;
            }
            else
            {
                Common.WriteLog("Error: 106 "+  Request.Url.OriginalString, string.Format("RefID: {0}, Status: {1}",
                   RefID,
                 "Data table NULL"));
                ShowError("Invalid Information/Server Problem. (106)");
                return false;
            }
        }
        catch(Exception ex)
        {
            Common.WriteLog("Error: 107 " + Request.Url.OriginalString, string.Format("RefID: {0}, Error: {1}",
                  RefID,
               ex.Message));
            ShowError("Invalid Information/Server Problem. (107)");
        }
        return false;
    }

    private Boolean GetItclOrderStatus(string _MerchantID, string _ORDERID, string _SESSIONID, int hostPort)
    {
        try
        {
            string ReqXmlDoc = "";
            String path = "/Exec";
            ReqXmlDoc = getReqXmlDoc(_MerchantID, _ORDERID, _SESSIONID); ;
            string hostName = Common.getValueOfKey("Itcl_hostName"); ;

            string headers;
            string response = "";

            Socket sk = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            System.Net.IPAddress remoteIPAddress = System.Net.IPAddress.Parse(hostName);
            System.Net.IPEndPoint remoteEndPoint = new System.Net.IPEndPoint(remoteIPAddress, hostPort);
            headers = "POST " + path + " HTTP/1.0\r\n";
            headers += "Host: " + hostName + "\r\n";
            headers += "Content-type: application/x-www-form-urlencoded\r\n";
            headers += "Content-Length: " + ReqXmlDoc.Length + "\r\n\r\n";
            headers += ReqXmlDoc;

            TcpClient tcpClient;
            NetworkStream networkStream;
            StreamWriter streamWriter;
            StreamReader streamReader;

            using (tcpClient = new TcpClient(hostName, hostPort))
            {
                networkStream = tcpClient.GetStream();

                streamWriter = new StreamWriter(networkStream);
                streamReader = new StreamReader(networkStream);

                streamWriter.WriteLine(headers);
                streamWriter.Flush();

                response = streamReader.ReadToEnd();
            }
            return GetPreponseData(response, _ORDERID, RefID, _MerchantID);
        }
        catch (Exception ee)
        {
            Common.WriteLog(Request.Url.OriginalString, string.Format("RefID: {0}, Error: {1}",
                 RefID,
              ee.Message));
            ShowError("Unable to connect with ITCL server.");
            return false;
        }
      

    }

    private Boolean GetPreponseData(string htmlMsg, string orderID, string RefID, string MerchantID)
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
        catch (Exception ex)
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

    private string getReqXmlDoc(string _MerchantID, string _OrderID, string _SessionID)
    {
        XmlDocument doc = new XmlDocument();

        XmlNode docNode = doc.CreateXmlDeclaration("1.0", null, null);
        doc.AppendChild(docNode);

        XmlNode TKKPGNode = doc.CreateElement("TKKPG");
        doc.AppendChild(TKKPGNode);

        XmlNode RequestChild = doc.CreateElement("Request");
        TKKPGNode.AppendChild(RequestChild);

        XmlNode OperationChild = doc.CreateElement("Operation");
        OperationChild.InnerText = "GetOrderStatus";
        RequestChild.AppendChild(OperationChild);

        XmlNode LanguageChild = doc.CreateElement("Language");
        LanguageChild.InnerText = "EN";
        RequestChild.AppendChild(LanguageChild);

        XmlNode OrderChild = doc.CreateElement("Order");
        RequestChild.AppendChild(OrderChild);

        XmlNode OrderTypeChild = doc.CreateElement("OrderType");
        OrderTypeChild.InnerText = "Purchase";
        OrderChild.AppendChild(OrderTypeChild);

        XmlNode MerchantChild = doc.CreateElement("Merchant");
        MerchantChild.InnerText = _MerchantID;
        OrderChild.AppendChild(MerchantChild);

        XmlNode OrderIDChild = doc.CreateElement("OrderID");
        OrderIDChild.InnerText = _OrderID;
        OrderChild.AppendChild(OrderIDChild);

        XmlNode SessionIDChild = doc.CreateElement("SessionID");
        SessionIDChild.InnerText = _SessionID;
        RequestChild.AppendChild(SessionIDChild);

        return doc.OuterXml;
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

    private DataTable Save_Payments_Passport_Success(string _RefID, string _OrderID, string _TransactionID, string _PAN, string _TransactionType, long SenderAcc)
    {
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Passport_Success";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = _TransactionID;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = _OrderID;
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
                    var tb = new DataTable();
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

    private void ShowError(string ErrorText)
    {
        GridView1.Visible = false;
        PanelError.Visible = true;
        lblStatus.Text = ErrorText;
    }
}