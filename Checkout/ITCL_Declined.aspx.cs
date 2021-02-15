using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;
using System.Text;

public partial class ITCL_Declined : System.Web.UI.Page
{
    string xmlstr = "";
    string xmlmsg = "";
    string Amount = "0";
    string OrderStatus = "";
    string ResponseDescription = "";
    string PAN = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = string.Format("{0}", "Transaction Declined");

        try
        {
            xmlmsg = Request.Form["xmlmsg"];

            if (!xmlmsg.Contains("<"))
                xmlstr = DecryptConnectionString(xmlmsg);
            else
                xmlstr = xmlmsg;
        }
        catch (Exception ex) { Label1.Text = ex.Message; }

        SqlConnection.ClearAllPools();

        try
        {
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

                    x.LoadXml(xmlstr);
                    try
                    {
                        Amount = x.GetElementsByTagName("PurchaseAmount")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        OrderStatus = x.GetElementsByTagName("OrderStatus")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        ResponseDescription = x.GetElementsByTagName("ResponseDescription")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        PAN = x.GetElementsByTagName("PAN")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        order_id = x.GetElementsByTagName("OrderID")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = order_id;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("TransactionType")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Currency")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = decimal.Parse(Amount) / 100;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ResponseCode")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Name")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value = ResponseDescription;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@OrderDescription", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("OrderDescription")[0].InnerText; ;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = OrderStatus;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ApprovalCode")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@AcqFee", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("AcqFee")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@Brand", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Brand")[0].InnerText;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@MerchantTranID", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("MerchantTranID")[0].InnerText; ;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@ThreeDSVerificaion", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ThreeDSVerificaion")[0].InnerText; ;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@ThreeDSStatus", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ThreeDSStatus")[0].InnerText; ;
                    }
                    catch (Exception) { }
                    try
                    {
                        cmd.Parameters.Add("@xmlmsg", System.Data.SqlDbType.VarChar).Value = xmlstr;
                    }
                    catch (Exception) { }

                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }

            string _payment_success_url = "";
            string _merchant_order_id = "";
            string _payment_status = "0";
            string _payment_type = "";
            string _ref_id = "";
            string _merchant_id = "";
            string _xmlresponse_Msg = "";
            bool _xmlresponse = false;
            double _amount = 0;
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Get_XML_Response_Param";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ItclOrderID", System.Data.SqlDbType.VarChar).Value = order_id;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = null;

                    cmd.Connection = conn;
                    conn.Open();

                    using (SqlDataReader sdr = cmd.ExecuteReader())
                    {
                        while (sdr.Read())
                        {
                            _payment_success_url = sdr["PaymentSuccessUrl"].ToString();
                            _merchant_order_id = sdr["OrderID"].ToString();
                            _payment_status = sdr["Status"].ToString();
                            _payment_type = sdr["Type"].ToString();
                            _ref_id = sdr["RefID"].ToString();
                            _merchant_id = sdr["MarchentID"].ToString();
                            _xmlresponse = (bool)sdr["AllowXmlResponce"];
                            _xmlresponse_Msg = EncodeTo64(sdr["Checkout_Xml_Msg"].ToString());
                            _amount = double.Parse(sdr["Amount"].ToString());
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
                Post_XMLResponse_Msg(_payment_success_url, _xmlresponse_Msg, _merchant_order_id, _payment_status, _payment_type, _ref_id, _merchant_id, _amount);
            }

            Label1.Text = string.Format("<table><tr><td>Amount:</td><td>{0:N2}</td></tr><tr><td>Card:</td><td>{1}</td></tr><tr><td>Status:</td><td>{2}</td></tr><tr><td>Description:</td><td>{3}</td></tr></table>",
               decimal.Parse(Amount) / 100,
               PAN,
               OrderStatus,
               ResponseDescription);
        }
        catch (Exception ex) { Label1.Text += "<br>"+ ex.Message; }

        
    }

    static public string EncodeTo64(string toEncode)
    {
        byte[] toEncodeAsBytes
              = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
        string returnValue
              = System.Convert.ToBase64String(toEncodeAsBytes);
        return returnValue;
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
    private void Post_XMLResponse_Msg(string _payment_success_url, string _xmlresponse_Msg, string _merchant_order_id, string _payment_status, string _payment_type, string _ref_id, string _merchant_id, Double Amount)
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
}