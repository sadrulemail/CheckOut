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
public partial class Checkout_Payment_Success : System.Web.UI.Page
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
    string ITCL_OrderStatus = "";
    string OrderDescription = "";
    string OrderID = "";
    double Amount = 0;
    string MerchantType = "";
    string StatusDB = "";
    string PayType = "";
    DataTable CheckoutPaymentDT;

    protected void Page_Load(object sender, EventArgs e)
    {
        //SqlDataSource1.SelectParameters.Add("TransactionID", "029442 A");
        //SqlDataSource1.SelectParameters.Add("RefID", "313351D900002B");
        //SqlDataSource1.DataBind();
        //return;
        //GetTBMpaymentInfo(); return;

        try
        {
            string LogText = "";

            foreach (string key in Request.Form.Keys)
            {
                LogText += String.Format("FORM:{0}:{1}\n", key, Request.Form[key]);
            }

            if (Request.QueryString.Count > 0)
            {
                LogText += String.Format("QueryString:{0}\n", Request.QueryString);
            }

            Common.WriteLog("Checkout_Payment_Success.aspx", LogText);
        }
        catch (Exception)
        { }


        string[] Refferers = { "", "" };


        if (string.Format("{0}", Request.QueryString["ORDERID"]).Length > 0 
            && string.Format("{0}", Request.QueryString["SESSIONID"]).Length > 0)
        {
            //This is needed to get the ITCL ItclOrderID and SESSION for the first time
            Response.End();
            return;
        }

      //  string functionReturnValue1 = HttpContext.Current.Request.UrlReferrer.ToString();
        string FromURL1 = Request.ServerVariables["URL"];



        string b1 = Request.ServerVariables["HTTP_REFERER"];

        //Common.WriteLog(Request.Url.OriginalString, "Page Url:Passport_Payment_Success.aspx");

        RefID = string.Format("{0}", Request.Form["BillingCode"]);
        if (RefID == "") RefID = string.Format("{0}", Request.QueryString["BillingCode"]);
        RefID = RefID.Trim();
        //RefID = Common.purifyString(RefID, "1234567890abcdefABCDEF");

        TransactionID = string.Format("{0}", Request.Form["tr_id"]);
        if (TransactionID == "") TransactionID = string.Format("{0}", Request.QueryString["tr_id"]);
        //TransactionID = Common.purifyString(TransactionID, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

        Status = string.Format("{0}", Request.Form["status"]);
        if (Status == "") Status = string.Format("{0}", Request.QueryString["status"]);
        //Status = Common.purifyString(Status, "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ");

        Keycode = string.Format("{0}", Request.Form["keycode"]);
        if (Keycode == "") Keycode = string.Format("{0}", Request.QueryString["keycode"]);

        xmlmsg = string.Format("{0}", Request.Form["xmlmsg"]);
        if (xmlmsg == "") xmlmsg = string.Format("{0}", Request.QueryString["xmlmsg"]);
        
        SenderAcc = string.Format("{0}", Request.QueryString["SenderAcc"]);

        SqlConnection.ClearAllPools();
        
        CheckoutPaymentDT = new DataTable();
        

        //try
        //{
 
        //  Referrer = string.Format("{0}", this.Request.UrlReferrer.AbsoluteUri);
        //    //Response.Write(Referrer);
        //    Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
          
        //}
        //catch (Exception) { }

        //if (Referrer == "")
        //{
        //    try
        //    {
        //       // Referrer = string.Format("{0}", Request.ServerVariables["HTTP_ORIGIN"]);
        //      //  Referrer = string.Format("{0}", Request.ServerVariables["HTTP_REFERER"]);
        //        string a =Request.ServerVariables["HTTP_HOST"];
        //        //Response.Write(Referrer);
        //        //Label1.Text = Referrer;
        //        Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
        //        Uri myReferrer = Request.UrlReferrer;
        //        string actual = myReferrer.ToString();
        //    }
        //    catch (Exception ex)
        //    {
        //        //Label1.Text = ex.Message; 
        //    }
        //}


        PageUrl = Request.Url.OriginalString.Split('?')[0];
        //bool visible = false;


        if (TransactionID.Length == 0)
        {
            //ITCL

            


            //using (SqlConnection conn = new SqlConnection())
            //{
            //    string Query = "[s_Checkout_page_Url_Check]";
            //    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            //    using (SqlCommand cmd = new SqlCommand())
            //    {
            //        try
            //        {
            //            cmd.CommandText = Query;
            //            cmd.CommandType = System.Data.CommandType.StoredProcedure;
            //            //cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
            //            //cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;
            //            //cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "ITCL";

            //            cmd.Connection = conn;
            //            conn.Open();

            //            using (SqlDataReader sdr = cmd.ExecuteReader())
            //            {
            //                while (sdr.Read())
            //                {
            //                    // have to check referrer url for live
            //                    string sql_Referrer = string.Format("{0}", sdr["Referrer"]);
            //                    string sql_Url = string.Format("{0}", sdr["PageUrl"]);
            //                    if (Referrer.ToLower().StartsWith(sql_Referrer.ToLower())
            //                        && PageUrl.ToLower().StartsWith(sql_Url.ToLower())
            //                            || sql_Referrer == "" || Referrer == "")
            //                    {
            //                        visible = true;
            //                    }
            //                }
            //            }
            //        }
            //        catch (Exception ex)
            //        {
            //            Response.Write("Error: " + ex.Message);
            //            Response.End();
            //        }
            //    }
            //}

            //if (!visible)
            //{
            //    Response.Clear();
            //    Response.Write("Invalid Request<br>" + Referrer);
            //    Common.WriteLog(PageUrl, PageUrl);
            //    Response.End();
            //}

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

                        string xmlstr = xmlmsg;
                        if (!xmlmsg.Contains("<"))
                            xmlstr = DecryptConnectionString(xmlmsg);
                        //Common.WriteLog("xml", xmlstr);

                        XmlDocument x = new XmlDocument();

                        x.LoadXml(xmlstr);

                        TransactionID = x.GetElementsByTagName("ApprovalCode")[0].InnerText;
                        ItclOrderID =  x.GetElementsByTagName("OrderID")[0].InnerText;
                        PAN = x.GetElementsByTagName("PAN")[0].InnerText;
                        ITCL_OrderStatus = x.GetElementsByTagName("ApprovalCodeScr")[0].InnerText;
                        OrderDescription = x.GetElementsByTagName("OrderDescription")[0].InnerText;
                        //Amount = double.Parse(x.GetElementsByTagName("PurchaseAmountScr")[0].InnerText.Replace(" ","")); // amount white space

                        cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = ItclOrderID;
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


                        cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("OrderStatus")[0].InnerText;
                        cmd.Parameters.Add("@OrderDescription", System.Data.SqlDbType.VarChar).Value = OrderDescription;

                        

                        cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = TransactionID;
                        cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                        cmd.Parameters.Add("@AcqFee", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("AcqFee")[0].InnerText;
                        cmd.Parameters.Add("@xmlmsg", System.Data.SqlDbType.VarChar).Value = xmlstr;
                        string MerchantTranID = "";
                        try
                        {
                            MerchantTranID = x.GetElementsByTagName("MerchantTranID")[0].InnerText;
                        }
                        catch(Exception ex)
                        { Common.WriteLog("MerchantTranID", ex.Message); }
                        cmd.Parameters.Add("@MerchantTranID", System.Data.SqlDbType.VarChar).Value = MerchantTranID;
                        // cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Name")[0].InnerText;
                        string CardHolderName = "";
                        try
                        {
                            CardHolderName= x.GetElementsByTagName("CardHolderName")[0].InnerText;
                        }
                        catch(Exception ex)
                        { }
                        cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = CardHolderName;
                        cmd.Parameters.Add("@Brand", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Brand")[0].InnerText;
                        string ThreeDSStatus = "";
                        try
                        {
                            ThreeDSStatus= x.GetElementsByTagName("ThreeDSStatus")[0].InnerText;
                        }
                        catch(Exception ex)
                        { Common.WriteLog("ThreeDSStatus", ex.Message); }
                        cmd.Parameters.Add("@ThreeDSStatus", System.Data.SqlDbType.VarChar).Value = ThreeDSStatus;
                        string ThreeDSVerificaion = "";
                        try
                        {
                            ThreeDSVerificaion = x.GetElementsByTagName("ThreeDSVerificaion")[0].InnerText;
                        }
                        catch(Exception ex)
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
                Common.WriteLog("s_ITCL_Response_Insert", ex.Message + ' ' + xmlmsg);
                //Label1.Text += "<br>" + ex.Message; 
            }

            int length = OrderDescription.Trim().Length;
            bool ItclOrderStatus;

            

            if (length == 0)
            {
                ItclOrderStatus = false;
            }
            else
            {
                RefID = OrderDescription.Trim().Substring(length - 14, 14);
                MerchantType = OrderDescription.Trim().Substring(0, length - 15);
                getCheckout_Ref_Details();
                ItclOrderStatus = GetItclOrderStatus(
                         CheckoutPaymentDT.Rows[0]["UID"].ToString(),
                         CheckoutPaymentDT.Rows[0]["ItclOrderID"].ToString(),
                         CheckoutPaymentDT.Rows[0]["SessionID"].ToString(),
                         Int16.Parse(CheckoutPaymentDT.Rows[0]["PortNo"].ToString())
                         );
                
            }

            
            if (ItclOrderStatus == true)     //Later: ITCL Get Order Status webservice check
                //visible = true;

            {                
                DataTable DT = Save_Payments_Checkout_Success(RefID, ItclOrderID, TransactionID, PAN, "ITCL", 0);
                if (DT != null)
                {
                    string MerchantUrl = RedirectToMerchantURL(MerchantType);
                    RedirectMerchantUrl(MerchantUrl);
                }
                else
                {
                    Response.Clear();
                    Common.WriteLog(Request.Url.OriginalString,
                        string.Format("Error: 101: Failed to update the Transaction: {0}, RefID: {1}",
                        TransactionID,
                        RefID));
                    llbStatus.Text = "Failed to update the Transaction. (1)";                    
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
                llbStatus.Text = ("Failed to update the Transaction. (2)");
                return;
            }
        }
        else
        {
            //Mobile Money

            getCheckout_Ref_Details();

            using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_TBMM_Response_Insert";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@transaction_id", System.Data.SqlDbType.VarChar).Value = TransactionID;
                    cmd.Parameters.Add("@application_id", System.Data.SqlDbType.VarChar).Value = RefID;
                    //cmd.Parameters.Add("@BillingCode", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", RefID);
                    //cmd.Parameters.Add("@success", System.Data.SqlDbType.VarChar).Value = Status;
                    cmd.Parameters.Add("@status", System.Data.SqlDbType.VarChar).Value = Status;

                    cmd.Connection = conn;

                    if (conn.State == System.Data.ConnectionState.Closed)
                        conn.Open();

                    cmd.ExecuteNonQuery();
                    //isSaved = true;

                }
            }


            if (TransactionID.Length < 5 || RefID.Length < 10)
            {
                Response.Clear();
                Common.WriteLog(Request.Url.OriginalString, string.Format("TransactionID/txid: {0},RefID/Billcode: {1}, Status: {2}, Keycode: {3}",
                   TransactionID,
                   RefID,
                   Status,
                   Keycode));
                llbStatus.Text = "Invalid Request.";
                return;
            }       

            //if (!visible)
            //{
            //    Response.Clear();
            //    Common.WriteLog(Request.Url.OriginalString, string.Format("Page Access Error:PageUrl: {0},PaymentType: {1}",
            //        PageUrl,
            //        PaymentType));
            //    Response.Write("Invalid Request");
            //    Response.End();
            //}

            if (Status.ToUpper().Trim() == "SUCCESS")
            {
                //if (Redirect.Trim() != "")
                try
                {
                    Amount = double.Parse(CheckoutPaymentDT.Rows[0]["Amount"].ToString());
                    //double TotalAmount = double.Parse(CheckoutPaymentDT.Rows[0]["TotalAmount"].ToString());


                    if (    //TBMM Webservice check
                        TBMMpaymentInfoCheck(
                        TransactionID, 
                        CheckoutPaymentDT.Rows[0]["AccountNo"].ToString(),
                        Amount)
                        )
                    {
                        //Payment Found in TBMM
                        DataTable DT = Save_Payments_Checkout_Success(RefID, null, TransactionID, null, "MB", long.Parse(SenderAcc));
                        if (DT != null)
                        {
                            string MerchantUrl = RedirectToMerchantURL(CheckoutPaymentDT.Rows[0]["MarchentID"].ToString());
                            //Common.WriteLog("MerchantUrl", MerchantUrl);
                            
                            RedirectMerchantUrl(MerchantUrl);
                            
                            //return;
                        }
                        else
                        {
                            Response.Clear();
                            Common.WriteLog(Request.Url.OriginalString,
                                string.Format("Failed to update the Transaction: {0}, RefID: {1}",
                                TransactionID,
                                RefID));
                            llbStatus.Text = "Failed to update the Transaction. (3)";
                            return;
                        }
                    }
                    else
                    {
                        //Invalid Payment
                        llbStatus.Text = "Invalid Payment Information";
                        //Response.End();
                    }
                }
                catch (Exception)
                {
                    //Common.WriteLog("Error 25", ex.Message);
                }
                //Redirect = string.Format("{0}&billcode={1}", Redirect, RefID);
                //Response.Redirect(Redirect, true);
            }
            else
            {
                Common.WriteLog(Request.Url.OriginalString, "Invalid Status:" + Status);
            }
        }
    }

    private void getCheckout_Ref_Details()
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
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed)
                        conn.Open();

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
        
        //string ReqXmlDoc = "";

        //ReqXmlDoc = getReqXmlDoc(Amount, "050", RefID, "Test");
        //HttpWebRequest req = null;

        
            UrlDataSet.UrlVersDataTable dt = new UrlDataSet.UrlVersDataTable();
            UrlDataSet.UrlVersRow oRow = dt.NewUrlVersRow();

            oRow.RefID = RefID;
            oRow.Amount = Amount;
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
                Post_XMLResponse_Msg(redirectUrl, _xmlresponse_Msg, OrderID, StatusDB, PayType, RefID, Amount);
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
    private Boolean GetItclOrderStatus(string _MerchantID, string _ORDERID, string _SESSIONID,int hostPort)
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

        tcpClient = new TcpClient(hostName, hostPort);
        networkStream = tcpClient.GetStream();

        streamWriter = new StreamWriter(networkStream);
        streamReader = new StreamReader(networkStream);

        streamWriter.WriteLine(headers);
        streamWriter.Flush();

        response = streamReader.ReadToEnd();

        try
        {
      
             return GetPreponseData(response, _ORDERID, RefID, _MerchantID);
             
        }
        catch (Exception ee)
        {
            return false;
        }
        tcpClient.Close();
    
    }
    private Boolean GetItclOrderStatus_(string _MerchantID, string _ORDERID, string _SESSIONID)
    {
        string ReqXmlDoc = "";
        //string _ORDERID = "";
        //string _SESSIONID = "";
        //string _MerchantID = "";
        //if (CheckoutPaymentDT.Rows.Count>0)
        //{
        //    _ORDERID = CheckoutPaymentDT.Rows[0]["ItclOrderID"].ToString();
        //    _SESSIONID = CheckoutPaymentDT.Rows[0]["SessionID"].ToString();
        //    _MerchantID = CheckoutPaymentDT.Rows[0]["UID"].ToString();
        //}

        ReqXmlDoc = getReqXmlDoc(_MerchantID, _ORDERID, _SESSIONID); ;
     
        string ITCL_PaymentURL = "";
        HttpWebRequest req = null;
        string PROXY_SERVER = "";
        int PROXY_PORT = 0;

        try
        {
            PROXY_SERVER = Common.getValueOfKey("PROXY_SERVER");
            PROXY_PORT = int.Parse(Common.getValueOfKey("PROXY_PORT"));
        }
        catch (Exception) { }

        try
        {
            ITCL_PaymentURL = Common.getValueOfKey("ITCL_PaymentURL");
            string ITCL_PostUrl = Common.getValueOfKey("ITCL_PostUrl");
            req = (HttpWebRequest)WebRequest.Create(ITCL_PostUrl);
            req.KeepAlive = false;
            req.AllowAutoRedirect = true;
            req.ProtocolVersion = HttpVersion.Version11;
            req.Method = "POST";
            req.ContentType = "application/x-www-form-urlencoded";
            byte[] postBytes = Encoding.ASCII.GetBytes("Request=" + ReqXmlDoc);
            //req.ContentType = "application/x-www-form-urlencoded";
            req.ContentLength = postBytes.Length;

            if (PROXY_SERVER != "")
            {
                WebProxy wp = new WebProxy(PROXY_SERVER, PROXY_PORT);
                req.Proxy = wp;
            }

            Stream requestStream = req.GetRequestStream();
            requestStream.Write(postBytes, 0, postBytes.Length);
            requestStream.Close();
        }
        catch (Exception ex)
        {
            SaveITCLUnApprovedDataLog(_ORDERID, RefID, _MerchantID, ITCL_OrderStatus.ToUpper(), "", ex.Message);          
        }

        try
        {
            using (HttpWebResponse response = (HttpWebResponse)req.GetResponse())
            {
                using (Stream resStream = response.GetResponseStream())
                {
                    try
                    {                       
                        var sr = new StreamReader(response.GetResponseStream());
                        string responseText = sr.ReadToEnd();                        
                        return GetPreponseData(responseText, _ORDERID, RefID, _MerchantID);
                    }
                    catch (Exception)
                    {
                        return false;
                    }
                }
            }
        }
        catch (Exception ee)
        {
            return false;
        }   

       // return false;
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
        catch (Exception ex) {

            Common.WriteLog("s_Itcl_GetOrderStatus_Log", string.Format("{0}", ex.Message));
        }
    }

    private string getReqXmlDoc(string _MerchantID, string _OrderID, string _SessionID )
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
}