using System;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Net;
using System.Text;
using System.IO;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using System.Xml;
using System.Net.Sockets;
using System.Collections.Generic;

public partial class Passport_Payment : System.Web.UI.Page
{
    string FullName = "";
    string OnlineID = "";
    string Email = "";
    string Keycode = "";
    string Referrer = "";
    string PageUrl = "";
    double Amount = 0;
    string RefID = "";
    string SID = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        FullName = string.Format("{0}", Request.QueryString["fullname"]);
        OnlineID = string.Format("{0}", Request.QueryString["onlineid"]);
        Email = string.Format("{0}", Request.QueryString["email"]);
        Keycode = string.Format("{0}", Request.QueryString["keycode"]);
        SID = string.Format("{0}", Request.QueryString["SID"]);

        System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();

        Button1.Visible = false;
            
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

        if (Common.isEmailAddress(Email))
            PanelEmail.Visible = false;
        else
        {
            if (IsPostBack)
            {
                Email = txtEmail.Text;
                if (!Common.isEmailAddress(Email))
                {
                    Response.Clear();
                    Response.Write("Invalid Email Address");
                    Response.End();
                    return;
                }
            }
        }

        if (OnlineID.Length < 1)
        {
            Response.Clear();
            Response.Write("Online ID is Needed.");
            Response.End();
            return;
        }
        
        try
        {
            Amount = double.Parse(string.Format("{0:N2}", Request.QueryString["amount"]));
        }
        catch (Exception)
        {
            Response.Write("Invalid Amount.");
            Response.End();
            return;
        }

        SqlConnection.ClearAllPools();

        if (!IsPostBack)
        {
            lblTitle.Text = string.Format("{0}", FullName);
            bool visible = false;
            

            lblTBMM_PaymentAmount.Text = lblVisa_PaymentAmount.Text = string.Format("{0:N2}", Amount);

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Path_Check";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
                    cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;

                    cmd.Connection = conn;
                    conn.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            string sql_Referrer = sdr["Referrer"].ToString();
                            if (Referrer.ToLower().StartsWith(sql_Referrer.ToLower()) || sql_Referrer == "")
                            {
                                visible = true;
                            }
                        }
                    }
                }

                visible = true;

                //Get Service Charges

                Query = "Select dbo.f_Passport_Service_Charge ('" + Amount + "','MB') as Charge";
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.Connection = conn;

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            lblTBMM_Charge.Text = string.Format("{0:N2}", sdr["Charge"]);
                        }
                    }
                }

                Query = "Select dbo.f_Passport_Service_Charge ('" + Amount + "','ITCL') as Charge";
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
            }

            lblTBMM_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblTBMM_Charge.Text));
            lblVisa_Total.Text = string.Format("{0:N2}", Amount + double.Parse(lblVisa_Charge.Text));
            


            if (!visible)
            {
                Response.Clear();
                Response.Write("Invalid Request<br>Referer: " + Referrer);
                Common.WriteLog(PageUrl, PageUrl);
                Response.End();
            }
        }


        

        //txtxml.Visible = true;
        //txtxml.InnerHtml = getReqXmlDoc(100.54, "050", "Test Description", "POS_999");
    }

    protected void lnk_Command(object sender, CommandEventArgs e)
    {
        string Redirect = "";
        string PaymentType = string.Format("{0}", e.CommandArgument);
        string Merchant = "";
        Int16 hostPort = Int16.Parse(Common.getValueOfKey("Passport_ITCL_PORT")); 
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Path_Check";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
                cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    while (sdr.Read())
                    {
                        Redirect = string.Format("{0}", sdr["Redirect"]);
                        Merchant = string.Format("{0}", sdr["Merchant"]);
                    }
                }
            }
        }

        double ServiceCharge = 0;
        double TotalCost = 0;

        if (Redirect.Trim() != "")
        {            
            //RefID = Common.getNewRefID();
            //Redirect = string.Format("{0}&amount={1}&billingcode={2}", Redirect, Amount, RefID);
            //Response.Redirect(Redirect, true);
            

            if (PaymentType == "MB")
            {
                ServiceCharge = double.Parse(lblTBMM_Charge.Text);
                TotalCost = double.Parse(lblTBMM_Total.Text);                
            }
            else if (PaymentType == "ITCL")
            {
                ServiceCharge = double.Parse(lblVisa_Charge.Text);
                TotalCost = double.Parse(lblVisa_Total.Text);
            }

            if (ServiceCharge < 0 || TotalCost <= 0 || Amount <= 0) return;

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Payments_Passport_Insert";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = FullName;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = Email;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                    cmd.Parameters.Add("@PassportOnlineID", System.Data.SqlDbType.VarChar).Value = OnlineID;
                    cmd.Parameters.Add("@SID", System.Data.SqlDbType.VarChar).Value = SID;
                    cmd.Parameters.Add("@ServiceCharge", SqlDbType.Decimal).Value = ServiceCharge;


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
            if (PaymentType == "MB")
            {
                Redirect = string.Format("{0}&amount={1}&billcode={2}", Redirect, TotalCost, RefID);
                Response.Redirect(Redirect, true);
            }
            else if (PaymentType == "ITCL")
            {
                string ReqXmlDoc = "";
                ReqXmlDoc = getReqXmlDoc(TotalCost, "050", "MRP/V Payment: " + RefID, Merchant);
                string _ORDERID = "";
                string _SESSIONID = "";
                string ITCL_PaymentURL = "";
                HttpWebRequest req = null;

                try
                {
                    //ServicePointManager.CertificatePolicy = new MyPolicy();
                    //ServicePointManager.CheckCertificateRevocationList = false;
                    //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls | SecurityProtocolType.Tls12;
                    //ServicePointManager.Expect100Continue = true;
                    //ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };


                    //ITCL_PaymentURL = Common.getValueOfKey("ITCL_PaymentURL");
                    //string url = string.Format("{0}", Redirect);
                    //req = (HttpWebRequest)WebRequest.Create(url);
                    //req.KeepAlive = false;
                    //req.AllowAutoRedirect = true;
                    //req.ProtocolVersion = HttpVersion.Version11;
                    //req.Method = "POST";
                    //req.ContentType = "application/x-www-form-urlencoded";
                    //byte[] postBytes = Encoding.ASCII.GetBytes("Request=" + ReqXmlDoc);
                    ////req.ContentType = "application/x-www-form-urlencoded";
                    //req.ContentLength = postBytes.Length;
                    //Stream requestStream = req.GetRequestStream();
                    //requestStream.Write(postBytes, 0, postBytes.Length);
                    //requestStream.Close();

                    string hostName = Common.getValueOfKey("Itcl_hostName"); ;

                    string headers;
                    string response = "";
                    String path = "/Exec";

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
                    ItclFunction objFunction = new ItclFunction();
                    List<string> objList = objFunction.xml_to_list(objFunction.msg_get(response));
                    _ORDERID = objList[0];
                    _SESSIONID = objList[1];
                    ITCL_PaymentURL = objList[2];


                    //}
                    //catch (Exception ex)
                    //{
                    //    PanelError.Visible = true;
                    //    PanelError.Controls.Add(new LiteralControl(ex.Message + "<br />" + "Error Accessing Q-Cash Server, please try later. (1)"));                    
                    //    return;
                    //}

                    try
                    {
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
                                string Query = "s_Payments_Passport_Update_OrderID";
                                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                                using (SqlCommand cmd = new SqlCommand())
                                {
                                    cmd.CommandText = Query;
                                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = _ORDERID;
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
                                //Response.Redirect(string.Format("{0}?ORDERID={1}&SESSIONID={2}",
                                //    ITCL_PaymentURL, _ORDERID, _SESSIONID), true);
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
                            PanelError.Controls.Add(new LiteralControl("Error Accessing Q-Cash Server, please try later."));
                            return;
                        }
                    }
                    catch (Exception ee)
                    {
                        PanelError.Visible = true;
                        PanelError.Controls.Add(new LiteralControl(ee.Message + "<br />" + "Error Accessing Q-Cash Server, please try later."));
                        return;
                    }
                }
                catch (Exception ex)
                {
                    PanelError.Visible = true;
                    PanelError.Controls.Add(new LiteralControl(ex.Message + "<br />" + "Error Accessing Q-Cash Server, please try later. (1)"));
                    return;
                }
            }
        }        
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
        AmountChild.InnerText = string.Format("{0:N2}", _Amount).Replace(",", "").Replace(".", "");
        OrderChild.AppendChild(AmountChild);

        XmlNode CurreccyChild = doc.CreateElement("Currency");
        CurreccyChild.InnerText = _Currency;
        OrderChild.AppendChild(CurreccyChild);

        XmlNode DescriptionChild = doc.CreateElement("Description");
        DescriptionChild.InnerText = _Description;
        OrderChild.AppendChild(DescriptionChild);

        XmlNode ApproveURLChild = doc.CreateElement("ApproveURL");
        ApproveURLChild.InnerText = Common.getValueOfKey("ITCL_ApproveURL_Passport");
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

