using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;

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
                    Amount = x.GetElementsByTagName("PurchaseAmount")[0].InnerText;
                    OrderStatus = x.GetElementsByTagName("OrderStatus")[0].InnerText;
                    ResponseDescription = x.GetElementsByTagName("ResponseDescription")[0].InnerText;
                    PAN = x.GetElementsByTagName("PAN")[0].InnerText;

                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("OrderID")[0].InnerText;
                    cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("TransactionType")[0].InnerText;
                    cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Currency")[0].InnerText;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = decimal.Parse(Amount) / 100;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ResponseCode")[0].InnerText;
                    cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Name")[0].InnerText;
                    cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value = ResponseDescription;
                    cmd.Parameters.Add("@OrderDescription", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("OrderDescription")[0].InnerText; ;
                    cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = OrderStatus;
                    cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ApprovalCode")[0].InnerText;
                    cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                    cmd.Parameters.Add("@AcqFee", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("AcqFee")[0].InnerText;
                    cmd.Parameters.Add("@Brand", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("Brand")[0].InnerText; ;
                    cmd.Parameters.Add("@MerchantTranID", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("MerchantTranID")[0].InnerText; ;
                    cmd.Parameters.Add("@ThreeDSVerificaion", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ThreeDSVerificaion")[0].InnerText; ;
                    cmd.Parameters.Add("@ThreeDSStatus", System.Data.SqlDbType.VarChar).Value = x.GetElementsByTagName("ThreeDSStatus")[0].InnerText; ;
                    cmd.Parameters.Add("@xmlmsg", System.Data.SqlDbType.VarChar).Value = xmlstr;

                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception ex) { Label1.Text += "<br>"+ ex.Message; }

        Label1.Text = string.Format("<table><tr><td>Amount:</td><td>{0:N2}</td></tr><tr><td>Card:</td><td>{1}</td></tr><tr><td>Status:</td><td>{2}</td></tr><tr><td>Description:</td><td>{3}</td></tr></table>",
               decimal.Parse(Amount) / 100,
               PAN,
               OrderStatus,
               ResponseDescription);
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