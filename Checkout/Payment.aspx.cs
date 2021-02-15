using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Net;
using System.IO;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Net.Sockets;
using System.Collections.Generic;

public partial class Checkout_Payment : System.Web.UI.Page
{
    //string FullName = "";
    //string OrderID = "";
    //string Email = "";
    string Keycode = "";
    string Referrer = "";
    string PageUrl = "";
    double Amount = 0;
    string RefID = "";
    string SID = "";

    bool ServiceCharge_mb = false;
    bool ServiceCharge_itcl = false;
    //string MarchentID = "";
    string PaymentSuccessUrl = "";


    protected void Page_Load(object sender, EventArgs e)
    {
    
        if (hidMerchantID.Value == "" && !IsPostBack)
        {
            //hidFullName.Value = string.Format("{0}", Request.QueryString["fullname"]);
            //hidOrderID.Value = string.Format("{0}", Request.QueryString["orderid"]);
            //hidEmail.Value = string.Format("{0}", Request.QueryString["email"]);
            //hidMerchantID.Value = string.Format("{0}", Request.QueryString["merchantID"]);
            //if (hidMerchantID.Value.Length == 0)
            //    hidMerchantID.Value = string.Format("{0}", Request.QueryString["marchentID"]);
            //hidAmount.Value = string.Format("{0}", Request.QueryString["amount"]);
            hidRefID.Value = RefID = string.Format("{0}", Request.QueryString["refid"]);
            Keycode = string.Format("{0}", Request.QueryString["keycode"]);
            //SID = string.Format("{0}", Request.QueryString["SID"]);
            if (RefID.Length < 14 || Keycode.Length < 32)
            {
                Response.Redirect("Default.aspx", true);
            }
          

            GetCheckoutAmount(Request.QueryString["refid"],Keycode);
        }

        //if (hidMerchantID.Value == "" && string.Format("{0}", Request.Form["merchantID"]).Length > 0)
        //{
        //    hidAmount.Value = string.Format("{0}", Request.Form["amount"]);            
        //    hidFullName.Value =  string.Format("{0}", Request.Form["FullName"]);
        //    hidEmail.Value =  string.Format("{0}", Request.Form["Email"]);
        //    hidMerchantID.Value = string.Format("{0}", Request.Form["merchantID"]);
        //    hidOrderID.Value = string.Format("{0}", Request.Form["OrderID"]);
        //    hidPaymentSuccessUrl.Value = string.Format("{0}", Request.Form["PaymentSuccessUrl"]);
        //    hidRefID.Value= string.Format("{0}", Request.Form["RefID"]);
        //}

        

        Amount = double.Parse((hidAmount.Value == "" ? "0" : hidAmount.Value));        

        //FullName = FullName.Trim();

        Button1.Visible = false;

        if (!IsPostBack)
            GetPaymentMarchentName();

        if (IsPostBack)
        {
            Response.ExpiresAbsolute = DateTime.Now;
            Response.Expires = -1441;
            Response.CacheControl = "no-cache";
            Response.AddHeader("Pragma", "no-cache");
            Response.AddHeader("Pragma", "no-store");
            Response.AddHeader("cache-control", "no-cache");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoServerCaching();
        }        

        try
        {
            Referrer = string.Format("{0}", this.Request.UrlReferrer.AbsoluteUri);
            //Response.Write(Referrer);
            Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
        }
        catch (Exception) { }

        PageUrl = Request.Url.OriginalString.Split('?')[0];
        //Response.Write(PageUrl);

        //if (Common.isEmailAddress(Email))
        //    PanelEmail.Visible = false;
        //else
        //{
        //    if (IsPostBack)
        //    {
        //        Email = txtEmail.Text;
        //        if (!Common.isEmailAddress(Email))
        //        {
        //            Response.Clear();
        //            Response.Write("Invalid Email Address");
        //            Response.End();
        //            return;
        //        }
        //    }
        //}

        if (hidOrderID.Value.Length < 1)
        {
            //Response.Clear();
            //Response.Write("Order ID is Needed.");
            //Response.End();
            ShowPanel("Order ID is Needed.");
            //llbStatus.Text = "Order ID is Needed.";
            return;

        }
        if (Amount < 1)
        {
            //Response.Clear();
            //Response.Write("Minimum Amount is Needed.");
            //Response.End();
            ShowPanel("Minimum Amount is Needed.");
            return;
            //llbStatus.Text = "Minimum Amount is Needed.";
            //return;
        }
        
        //try
        //{
        //    Amount = double.Parse(string.Format("{0:N2}", Request.QueryString["amount"]));
        //}
        //catch (Exception)
        //{
        //    Response.Write("Invalid Amount.");
        //    Response.End();
        //    return;
        //    //llbStatus.Text = "Invalid Amount.";
        //    //return;
        //}

        SqlConnection.ClearAllPools();

        if (!IsPostBack)
        {
            lblTitle.Text = string.Format("Dear {0},<br />", hidFullName.Value == "" ? "Customer" : hidFullName.Value);
            bool visible = false;
            

            lblTBMM_PaymentAmount.Text = lblVisa_PaymentAmount.Text = string.Format("{0:N2}", Amount);

         

            //Get Service Charges
            using (SqlConnection conn = new SqlConnection())
            {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
            string Query = "Select dbo.f_Checkout_Service_Charge ('" + Amount + "','" + hidMerchantID.Value + "','MB','" + ddlEMI.SelectedValue + "') as Charge";
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        lblTBMM_Charge.Text = string.Format("{0:N2}", sdr["Charge"]);
                    }
                }
            }

            Query = "Select dbo.f_Checkout_Service_Charge ('" + Amount + "','" + hidMerchantID.Value + "','ITCL','" + ddlEMI.SelectedValue + "') as Charge";
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.Connection = conn;

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            lblVisa_Charge.Text = string.Format("{0:N2}", sdr["Charge"]);
                        }
                    }
                }

                Query = "Select dbo.f_Checkout_Emi_Interest ('" + Amount + "','" + hidMerchantID.Value + "','ITCL','" + ddlEMI.SelectedValue + "') as EmiInterest";
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.Connection = conn;

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            lblVisa_Emi_Interest.Text = string.Format("{0:N2}", sdr["EmiInterest"]);
                        }
                    }
                }
            }
        }


            if (!ServiceCharge_mb)
                lblTBMM_Charge.Text = "0.0";
            if (!ServiceCharge_itcl)
                lblVisa_Charge.Text = "0.0";


            lblTBMM_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblTBMM_Charge.Text));
            lblVisa_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblVisa_Charge.Text) + double.Parse(lblVisa_Emi_Interest.Text));
            


            //if (!visible)
            //{
            //    Response.Clear();
            //    Response.Write("Invalid Request<br>Referer: " + Referrer);
            //    Common.WriteLog(PageUrl, PageUrl);
            //    Response.End();
            //}
        }

      

    private void ShowPanel(string errorMsg)
    {
        PanelSuccess.Visible = false;
        PanelError.Visible = true;
        lblBody.Visible = false;
        lblError.Text = errorMsg;
    }
        //txtxml.Visible = true;
        //txtxml.InnerHtml = getReqXmlDoc(100.54, "050", "Test Description", "POS_999");

    private void GetCheckoutAmount(string RefID,string Keycode)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Pay_Status_Ref_Wise";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar).Value = Keycode;

                    SqlParameter sqlAmount = new SqlParameter("@Amount", SqlDbType.Decimal);
                    sqlAmount.Direction = ParameterDirection.InputOutput;
                    sqlAmount.Value = null;
                    cmd.Parameters.Add(sqlAmount);

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Int);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = "0";
                    cmd.Parameters.Add(sqlDone);

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = "";
                    cmd.Parameters.Add(sqlMsg);

                    SqlParameter sqlMerchant = new SqlParameter("@MerchantID", SqlDbType.VarChar);
                    sqlMerchant.Direction = ParameterDirection.InputOutput;
                    sqlMerchant.Value = "";
                    cmd.Parameters.Add(sqlMerchant);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    if (sqlDone.Value.ToString() == "1")
                    {
                        hidAmount.Value = sqlAmount.Value.ToString();
                        hidMerchantID.Value = "Test";
                        hidOrderID.Value = "TEST_3JBI0U4LO5VPJAS2V4V0OKQV";
                    }
                    else
                    {
                        ShowPanel("Already paid");
                    }


                }
            }
        }
        catch (Exception ex)
        {

        }
    }

    private void GetPaymentMarchentName()
    {
        bool allowEmi = false;
        SqlCommand cmd = new SqlCommand();
        SqlDataAdapter da = new SqlDataAdapter();
        DataTable dt = new DataTable();
        SqlConnection conn = new SqlConnection();
        string Query = "s_GetPaymentMarchent_Name";     //***
        conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
        try
        {
            cmd = new SqlCommand(Query, conn);
            cmd.Parameters.Add(new SqlParameter("@MarchentID", hidMerchantID.Value));
            cmd.Parameters.Add(new SqlParameter("@RefID", hidRefID.Value));
            cmd.CommandType = CommandType.StoredProcedure;
            da.SelectCommand = cmd;
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                //lblMarchentName.Text = dt.Rows[0]["MarchentName"].ToString();
                lblMarchentName1.Text = dt.Rows[0]["MarchentName"].ToString();
                lblMarchentName1.NavigateUrl = string.Format("{0}", dt.Rows[0]["MarchentCompanyURL"].ToString());

                lblImage.Text = string.Format("<img src='Images/Marchent/{0}' style='max-width:125px' />", dt.Rows[0]["MarchentLogoURL"].ToString());
                lblImage.NavigateUrl = string.Format("{0}", dt.Rows[0]["MarchentCompanyURL"].ToString());

                if (!(bool)dt.Rows[0]["Active_MB"])
                    PanelMB.Visible = false;
                if (!(bool)dt.Rows[0]["Active_ITCL"])
                    PanelItcl.Visible = false;

                if (!(bool)dt.Rows[0]["AllowEMI"])
                {
                    PanelEMI.Visible = false;
                    PanelEMI_Interest.Visible = false;
                }
                ////if (!(bool)dt.Rows[0]["PayWithCharge_MB"])
                ////    ServiceCharge_mb = 0;
                ////if (!(bool)dt.Rows[0]["PayWithCharge_ITCL"])
                ////    ServiceCharge_itcl = 0;
                if (hidRefID.Value != "")
                    Amount = double.Parse(dt.Rows[0]["Amount"].ToString());

                ServiceCharge_mb = (bool)dt.Rows[0]["PayWithCharge_MB"];
                ServiceCharge_itcl= (bool)dt.Rows[0]["PayWithCharge_ITCL"];

                PaymentSuccessUrl = string.Format("{0}", dt.Rows[0]["PaymentSuccessUrl"].ToString());

                if (
                    hidPaymentSuccessUrl.Value.StartsWith("http://") ||
                    hidPaymentSuccessUrl.Value.StartsWith("https://") ||
                    (hidPaymentSuccessUrl.Value + PaymentSuccessUrl).StartsWith("http://") ||
                    (hidPaymentSuccessUrl.Value + PaymentSuccessUrl).StartsWith("https://")
                   )
                { }
                else
                {
                    ////Response.Write("Invalid Request. Please provide correct payment confirmation URL.");
                    ////Response.End();
                    ShowPanel("Invalid Request. Please provide correct payment confirmation URL.");
                    return;
                }
            }
            else
            {
                //Response.Write("Invalid Request.");
                //Response.End();
                ShowPanel("Invalid Request.");
            }         
        }
        catch (Exception)
        {
           
        }       
    }

    //Click Payment Button
    protected void lnk_Command(object sender, CommandEventArgs e)
    {
        string Redirect = "";
        string PaymentType = string.Format("{0}", e.CommandArgument);
        string Merchant = "";
        string Password = "";
        bool PayWithCharge = false;
        double ServiceCharge = 0;
        double TotalCost = 0;
        double EmiInterest = 0;
        Int16 hostPort = 8080;



        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Marchant_Details_Select";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@CheckoutMerchantID", System.Data.SqlDbType.VarChar).Value = hidMerchantID.Value;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                cmd.Parameters.Add("@EmiNo", System.Data.SqlDbType.Int).Value = ddlEMI.SelectedValue;
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Money).Value = Amount;

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        Merchant = string.Format("{0}", sdr["UID"]);
                        Password = string.Format("{0}", sdr["Password"]);
                        PayWithCharge = (bool)sdr["PayWithCharge"];
                        ServiceCharge = double.Parse(sdr["ServiceCharge"].ToString());
                        hostPort = Int16.Parse( sdr["PortNo"].ToString());
                        EmiInterest = double.Parse(sdr["EmiInterest"].ToString());
                    }
                }
            }
        }

        if (Merchant.Trim().Length == 0)
        {
            PanelError.Visible = true;
            PanelError.Controls.Add(new LiteralControl("Merchant Info Not Found."));
            return;
        }



        ////if (Redirect.Trim() != "")
        ////{            
        //RefID = Common.getNewRefID();
        //Redirect = string.Format("{0}&amount={1}&billingcode={2}", Redirect, Amount, RefID);
        //Response.Redirect(Redirect, true);


        if (PaymentType == "MB")
        {
            //ServiceCharge = double.Parse(lblTBMM_Charge.Text);
            TotalCost = double.Parse(lblTBMM_Total.Text);
        }
        else if (PaymentType == "ITCL")
        {
            //ServiceCharge = double.Parse(lblVisa_Charge.Text);
            TotalCost = double.Parse(lblVisa_Total.Text);
            //if (int.Parse(ddlEMI.SelectedValue) > 0)
            //{
            //    EmiInterest = ServiceCharge;
            //    ServiceCharge = 0;
            //}
        }


        if (ServiceCharge < 0 || TotalCost <= 0 || Amount <= 0)
            return;

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Payments_Insert";    //***
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;


            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = hidFullName.Value;
                if (PayWithCharge)
                {
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount + ServiceCharge + EmiInterest;
                    cmd.Parameters.Add("@Fees", System.Data.SqlDbType.Decimal).Value = Amount;
                }
                else
                {                    
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount + EmiInterest;
                    cmd.Parameters.Add("@Fees", System.Data.SqlDbType.Decimal).Value = Amount - ServiceCharge;
                }
                cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = hidEmail.Value;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = hidOrderID.Value;
                cmd.Parameters.Add("@SID", System.Data.SqlDbType.VarChar).Value = SID;
                cmd.Parameters.Add("@ServiceCharge", SqlDbType.Decimal).Value = ServiceCharge;
                cmd.Parameters.Add("@MarchentID", SqlDbType.VarChar).Value = hidMerchantID.Value;
                cmd.Parameters.Add("@Emi_No", System.Data.SqlDbType.Int).Value = ddlEMI.SelectedValue == "" ? "0" : ddlEMI.SelectedValue;
                cmd.Parameters.Add("@InterestAmount", System.Data.SqlDbType.Decimal).Value = EmiInterest;
                cmd.Parameters.Add("@PaymentSuccessUrl", System.Data.SqlDbType.VarChar).Value = hidPaymentSuccessUrl.Value;
                cmd.Parameters.Add("@PayWithCharge", System.Data.SqlDbType.Bit).Value = PayWithCharge;
                cmd.Parameters.Add("@RefID_In", System.Data.SqlDbType.VarChar).Value = hidRefID.Value;

                SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                sqlRefID.Direction = ParameterDirection.InputOutput;
                sqlRefID.Value = "";
                cmd.Parameters.Add(sqlRefID);

                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = false;
                cmd.Parameters.Add(sqlDone);

                SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                sqlMsg.Direction = ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                if ((bool)sqlDone.Value == true)
                {
                    RefID = sqlRefID.Value.ToString();
                }
                else
                {
                    PanelError.Visible = true;
                    PanelError.Controls.Add(new LiteralControl(sqlMsg.Value.ToString()));
                    return;
                }
            }
        }

        UrlDataSet.UrlVersDataTable dt = new UrlDataSet.UrlVersDataTable();
        UrlDataSet.UrlVersRow oRow = dt.NewUrlVersRow();               

        oRow.Amount = Amount + EmiInterest;
        if (PayWithCharge) oRow.Amount = Amount + ServiceCharge+ EmiInterest;

        oRow.UID = Merchant;
        oRow.Password = Password;
        oRow.RefID = RefID;
        oRow.Type = PaymentType;


        if (PaymentType == "MB")
        {
            Redirect = Common.getValueOfKey("MB_PaymentURL");

            Redirect = getReplacedUrl(Redirect, oRow); // dynamically parameter change. only webconfig url parameter have to change
                                                       //string.Format("{0}&uid={1}&password={2}&amount={3}&billcode={4}", Redirect,Merchant, Password, TotalCost, RefID);
            Response.Redirect(Redirect, true);
        }
        else if (PaymentType == "ITCL")
        {
            string ReqXmlDoc = "";
            String path = "/Exec";
            ReqXmlDoc = getReqXmlDoc(oRow.Amount, "050", hidMerchantID.Value.Trim() + " " + RefID, Merchant);
            string _ORDERID = "";
            string _SESSIONID = "";
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

                //ServicePointManager.CertificatePolicy = new MyPolicy();
                //ServicePointManager.CheckCertificateRevocationList = false;
                //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                //     | SecurityProtocolType.Ssl3
                //      | SecurityProtocolType.Tls11
                //       | SecurityProtocolType.Tls12;
                //ServicePointManager.Expect100Continue = true;
                //ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };




                //ITCL_PaymentURL = Common.getValueOfKey("ITCL_PaymentURL");
                //string ITCL_PostUrl = Common.getValueOfKey("ITCL_PostUrl");
                //req = (HttpWebRequest)WebRequest.Create(ITCL_PostUrl);
                //req.KeepAlive = false;
                //req.AllowAutoRedirect = true;
                //req.ProtocolVersion = HttpVersion.Version11;
                //req.Method = "POST";                    
                //req.ContentType = "application/x-www-form-urlencoded";

                ////---------------

                //byte[] postBytes = Encoding.ASCII.GetBytes("Request=" + ReqXmlDoc);
                ////req.ContentType = "application/x-www-form-urlencoded";
                //req.ContentLength = postBytes.Length;

                //if (PROXY_SERVER.Trim() != "")
                //{
                //    WebProxy wp = new WebProxy(PROXY_SERVER, PROXY_PORT);
                //    req.Proxy = wp;
                //}

                ////------------

                //TransportContext tc;
                //Stream requestStream = req.GetRequestStream(out tc);
                //requestStream.Write(postBytes, 0, postBytes.Length);
                //requestStream.Close();
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

                //}
                //catch (Exception ex)
                //{
                //    PanelError.Visible = true;
                //    PanelError.Controls.Add(new LiteralControl(ex.Message + "<br />" + "Error Accessing ITCL Card Server, please try later. (1)"));                    
                //    return;
                //}

                //try
                //{
                response = streamReader.ReadToEnd();
                ItclFunction objFunction = new ItclFunction();
                List<string> objList = objFunction.xml_to_list(objFunction.msg_get(response));
                _ORDERID = objList[0];
                _SESSIONID = objList[1];
                ITCL_PaymentURL = objList[2];

                //using (HttpWebResponse response = (HttpWebResponse)req.GetResponse())
                //{
                //    using (Stream resStream = response.GetResponseStream())
                //    {
                //        try
                //        {
                //            string requestUrlQuery = string.Join(string.Empty, response.ResponseUri.AbsoluteUri.Split('?').Skip(1));
                //            //PanelError.Visible = true;
                //            _ORDERID = HttpUtility.ParseQueryString(requestUrlQuery)["ORDERID"];
                //            _SESSIONID = HttpUtility.ParseQueryString(requestUrlQuery)["SESSIONID"];

                //            if (_ORDERID == null || _SESSIONID == null)
                //            {
                //                PanelError.Visible = true;
                //                var sr = new StreamReader(response.GetResponseStream());
                //                string responseText = sr.ReadToEnd();                                    
                //                PanelError.Controls.Add(new LiteralControl(responseText));
                //                return;
                //            }
                //        }
                //        catch (Exception)
                //        {
                //            PanelError.Visible = true;
                //            var sr = new StreamReader(response.GetResponseStream());
                //            string responseText = sr.ReadToEnd();
                //            PanelError.Controls.Add(new LiteralControl(responseText));
                //            return;
                //        }
                //    }
                //}

                if (_ORDERID.Length > 0 && _SESSIONID.Length > 0)
                {
                    //Insert ITCL Order ID and Session ID
                    bool isSaved = false;
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Payments_Checkout_Update_OrderID";
                        conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                            cmd.Parameters.Add("@ItclOrderID", System.Data.SqlDbType.VarChar).Value = _ORDERID;
                            cmd.Parameters.Add("@SessionID", System.Data.SqlDbType.VarChar).Value = _SESSIONID;

                            SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                            sqlDone.Direction = ParameterDirection.InputOutput;
                            sqlDone.Value = false;
                            cmd.Parameters.Add(sqlDone);

                            cmd.Connection = conn;
                            conn.Open();

                            cmd.ExecuteNonQuery();
                            isSaved = (bool)sqlDone.Value;
                        }
                    }

                    //Redirect to ITCL Payment Page
                    if (isSaved)
                    {

                        //string a = string.Format("{0}?ORDERID={1}&SESSIONID={2}",
                        //    ITCL_PaymentURL, _ORDERID, _SESSIONID);
                        Response.Redirect(string.Format("{0}?ORDERID={1}&SESSIONID={2}",
                            ITCL_PaymentURL, _ORDERID, _SESSIONID), true);
                        //  Response.Redirect(objList[2] + "?ORDERID=" + _ORDERID + "&SESSIONID=" + _SESSIONID);
                        tcpClient.Close();
                    }
                    else
                    {
                        PanelError.Visible = true;
                        PanelError.Controls.Add(new LiteralControl("Error Saving Order ID is Database, please try later."));
                        return;
                    }
                }
                else
                {
                    PanelError.Visible = true;
                    PanelError.Controls.Add(new LiteralControl("Error Accessing ITCL Card Server, please try later."));
                    return;
                }
            }
            catch (Exception ee)
            {
                PanelError.Visible = true;
                PanelError.Controls.Add(new LiteralControl(ee.Message + "<br />" + "Error Accessing ITCL Card Server, please try later."));
                return;
            }
        }       
    }
    protected void ddlEMI_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (ddlEMI.SelectedValue != "")
        //    ltVatCharge.Text = "Commission:";
        //else
        //    ltVatCharge.Text = "Charge + Vat:";

        //Amount = double.Parse((hidAmount.Value == "" ? "0" : hidAmount.Value));
        using (SqlConnection conn = new SqlConnection())
        {
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
         
          string  Query = "Select dbo.f_Checkout_Service_Charge ('" + Amount + "','" + hidMerchantID.Value + "','ITCL','" + ddlEMI.SelectedValue + "') as Charge";
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.Connection = conn;
                conn.Open();
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        lblVisa_Charge.Text = string.Format("{0:N2}", sdr["Charge"]);
                    }
                }
            }
            Query = "Select dbo.f_Checkout_Emi_Interest ('" + Amount + "','" + hidMerchantID.Value + "','ITCL','" + ddlEMI.SelectedValue + "') as EmiInterest";
            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.Connection = conn;

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        lblVisa_Emi_Interest.Text = string.Format("{0:N2}", sdr["EmiInterest"]);
                    }
                }
            }
        }

        lblTBMM_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblTBMM_Charge.Text));
        lblVisa_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblVisa_Charge.Text)+ double.Parse(lblVisa_Emi_Interest.Text));
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

    private static bool ValidateRemoteCertificate(
        object sender, 
        X509Certificate certificate, 
        X509Chain chain, 
        SslPolicyErrors policyErrors)
    { return true; }

    private string getReqXmlDoc(double _Amount, string _Currency, string _Description, string _MerchantID)
    {
        XmlDocument doc = new XmlDocument();
        
        XmlNode docNode = doc.CreateXmlDeclaration("1.0", null, null);
        doc.AppendChild(docNode);

        XmlNode TKKPGNode = doc.CreateElement("TKKPG");
        doc.AppendChild(TKKPGNode);

        XmlNode RequestChild = doc.CreateElement("Request");
        TKKPGNode.AppendChild(RequestChild);

        XmlNode OperationChild = doc.CreateElement("Operation");
        OperationChild.InnerText = "CreateOrder";
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

        XmlNode AmountChild = doc.CreateElement("Amount");
        AmountChild.InnerText = string.Format("{0:N0}", _Amount * 100).Replace(",", "");
        OrderChild.AppendChild(AmountChild);

        XmlNode CurreccyChild = doc.CreateElement("Currency");
        CurreccyChild.InnerText = _Currency;
        OrderChild.AppendChild(CurreccyChild);

        XmlNode DescriptionChild = doc.CreateElement("Description");
        DescriptionChild.InnerText = _Description;
        OrderChild.AppendChild(DescriptionChild);

        XmlNode ApproveURLChild = doc.CreateElement("ApproveURL");
        ApproveURLChild.InnerText = Common.getValueOfKey("ITCL_ApproveURL");
        OrderChild.AppendChild(ApproveURLChild);

        XmlNode CancelledURLChild = doc.CreateElement("CancelURL");
        CancelledURLChild.InnerText = Common.getValueOfKey("ITCL_CancelURL");
        OrderChild.AppendChild(CancelledURLChild);

        XmlNode DeclineURLChild = doc.CreateElement("DeclineURL");
        DeclineURLChild.InnerText = Common.getValueOfKey("ITCL_DeclineURL");
        OrderChild.AppendChild(DeclineURLChild);

        return doc.OuterXml;
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        System.Threading.Thread.Sleep(5000);
        Button1.Text = DateTime.Now.ToLongTimeString();
    }
}


//public class MyPolicy : ICertificatePolicy
//{
//    public bool CheckValidationResult(ServicePoint srvPoint,
//      X509Certificate certificate, WebRequest request,
//      int certificateProblem)
//    {
//        //Return True to force the certificate to be accepted.
//        return true;
//    }
//}