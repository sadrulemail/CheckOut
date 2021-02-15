using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography.X509Certificates;
using System.Net.Security;
using System.Xml;
using System.Data;
using System.Data.SqlClient;

public partial class TestPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));


            string a = "PFJlc3BvbnNlIGRhdGU9IjIwMTgtMDctMzEgMTY6MzA6NDcuNDIwIj48VHJhbnNhY3Rpb25JbmZvPjxSZWZJRD4xMzNFRUZBMDA0NTdFODwvUmVmSUQ+PE9yZGVySUQ+U1A1YjVmMmNhMDE1MzNjPC9PcmRlcklEPjxOYW1lPjE8L05hbWU+PEVtYWlsPjwvRW1haWw+PEFtb3VudD4yNjUwLjAwPC9BbW91bnQ+PFNlcnZpY2VDaGFyZ2U+MjAuMDA8L1NlcnZpY2VDaGFyZ2U+PFRvdGFsQW1vdW50PjI2NzAuMDA8L1RvdGFsQW1vdW50PjxTdGF0dXM+MTwvU3RhdHVzPjxTdGF0dXNUZXh0PlBBSUQ8L1N0YXR1c1RleHQ+PFVzZWQ+MDwvVXNlZD48VmVyaWZpZWQ+MTwvVmVyaWZpZWQ+PFBheW1lbnRUeXBlPk1CPC9QYXltZW50VHlwZT48UEFOPjwvUEFOPjxUQk1NX0FjY291bnQ+ODgwMTcxNzIxNjcyNzwvVEJNTV9BY2NvdW50PjxNYXJjaGVudElEPkJJU0M8L01hcmNoZW50SUQ+PE9yZGVyRGF0ZVRpbWU+MjAxOC0wNy0zMCAyMToxOTo1MS40NTM8L09yZGVyRGF0ZVRpbWU+PFBheW1lbnREYXRlVGltZT4yMDE4LTA3LTMwIDIxOjIwOjM0Ljc4MzwvUGF5bWVudERhdGVUaW1lPjxFTUlfTm8+MDwvRU1JX05vPjxJbnRlcmVzdEFtb3VudD4wLjAwPC9JbnRlcmVzdEFtb3VudD48UGF5V2l0aENoYXJnZT4xPC9QYXlXaXRoQ2hhcmdlPjwvVHJhbnNhY3Rpb25JbmZvPjwvUmVzcG9uc2U+";
            DecodeFrom64(a);
        }

    }


    protected void cmdSubmit2_Click(object sender, EventArgs e)
    {

        if (ddlMethod.SelectedItem.Value == "GET")
        {
            if (ddlMarchentType.SelectedValue == "1")
            {
                Response.Redirect(string.Format("Passport_Payment.aspx?keycode={0}&onlineid={1}&enrolmentdate={2}&amount={3}&fullname={4}&email={5}&SID={6}"
                    , "19C9C9BF-7E40-40C6-8991-D87D814AA552"
                    , "TEST_" + Session.SessionID.ToString().ToUpper()
                    , string.Format("{0:dd/MM/yyyy}", DateTime.Today)
                    , txtAmount.Text
                    , txtName.Text
                    , txtEmail.Text
                    , Session.SessionID.ToString().ToUpper()), true);
            }
            else
            {
                Response.Redirect(string.Format("Checkout_Payment.aspx?orderid={0}&amount={1}&fullname={2}&email={3}&marchentID={4}&RefID={4}"

                  , "TEST_" + Session.SessionID.ToString().ToUpper()
                  , txtAmount.Text.Trim()
                  , txtName.Text.Trim()
                  , txtEmail.Text.Trim()
                  , ddlMarchentType.Text.ToString()
                  , txtPaymentSuccessUrl.Text.Trim().ToString()), true);
            }
        }
        else if (ddlMethod.SelectedItem.Value == "POST")
        {
            string postbackUrl = "Checkout_Payment.aspx";
            Response.Clear();
            StringBuilder sb = new StringBuilder();
            sb.Append("<html>");
            sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
            sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
            sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", "TEST_" + Session.SessionID.ToString().ToUpper());
            sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", txtAmount.Text);
            sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", ddlMarchentType.Text.ToString());
            sb.AppendFormat("<input type='hidden' name='FullName' value='{0}'>", txtName.Text.Trim());
            sb.AppendFormat("<input type='hidden' name='Email' value='{0}'>", txtEmail.Text.Trim());
            sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", txtPaymentSuccessUrl.Text.Trim());
            // Other params go here
            sb.Append("</form>");
            sb.Append("</body>");
            sb.Append("</html>");
            Response.Write(sb.ToString());
            Response.End();



        }

        else if (ddlMethod.SelectedItem.Value == "Service")
        {
            string RefID = "";
            DataTable dt = new DataTable();
        DataTable dt_chield = new DataTable();
        XmlDataDocument doc = new XmlDataDocument();
            doc.LoadXml(CreateCheckoutOrder());
            XmlReader xmlReader = new XmlNodeReader(doc);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlReader);
            dt = ds.Tables[0];
           
            try
            {
                string OrderID = dt.Rows[0]["OrderID"].ToString();
                string Amount = dt.Rows[0]["Amount"].ToString();
                string MerchantID = dt.Rows[0]["MerchantID"].ToString();
                string FullName = dt.Rows[0]["FullName"].ToString();
                string Email = dt.Rows[0]["Email"].ToString();
                string PaymentSuccessUrl = dt.Rows[0]["PaymentSuccessUrl"].ToString();
                RefID= GetCheckoutRefID(OrderID, decimal.Parse(Amount),MerchantID,FullName,Email,PaymentSuccessUrl);
            }
            catch (Exception ex)
            {
                // error return to merchant
            }
            if (RefID != "")
            {
                if (ds.Tables.Count == 2)
                    dt_chield = ds.Tables[1];

                string Chield_Tag = "";
                string Chield_TagValue = "";
                foreach (DataColumn column in dt_chield.Columns)
                {
                    Chield_Tag = column.ToString().Trim();
                    Chield_TagValue = dt_chield.Rows[0][column].ToString();
                    if (Chield_Tag != "Request_Id")
                        SaveOrderIdDetails(RefID, Chield_Tag, Chield_TagValue);
                }

                Response.Redirect(string.Format("Payment.aspx?keycode={0}&refid={1}"
                  , "19C9C9BF-7E40-40C6-8991-D87D814AA552"
                  , RefID
                  ));

            }
            else
            {
                //error
            }

        }
}

    private string GetCheckoutRefID(string OrderID,decimal Amount,string MerchantID,string FullName, string Email, string PaymentSuccessUrl)
    {
        string RefID = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_ServicePay_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@Fee", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = FullName;
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = Email;
                    cmd.Parameters.Add("@PaymentSuccessUrl", System.Data.SqlDbType.VarChar).Value = PaymentSuccessUrl;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "";

                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    //SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    //sqlDone.Direction = ParameterDirection.InputOutput;
                    //sqlDone.Value = "";
                    //cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    //if ((bool)sqlDone.Value == true)
                    //{
                    //    RefID = sqlRefID.Value.ToString();
                    //}
                    //else
                    //{
                    //    RefID = "";
                    //}
                    RefID = sqlRefID.Value.ToString();
                }
            }
        }
        catch (Exception ex)
        {

        }
        return RefID;
    }


    private void SaveOrderIdDetails(string RefID,string TagName, string TagValue)
    {

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_CheckoutOrderDetails";//***
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                cmd.Parameters.Add("@TagName", System.Data.SqlDbType.VarChar).Value = TagName;
                cmd.Parameters.Add("@Value", System.Data.SqlDbType.VarChar).Value = TagValue;



                //SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                //sqlRefID.Direction = ParameterDirection.InputOutput;
                //sqlRefID.Value = "";
                //cmd.Parameters.Add(sqlRefID);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();


            }
        }
    }

    private string CreateCheckoutOrder()
    {
        XmlDocument doc = new XmlDocument();

        XmlNode docNode = doc.CreateXmlDeclaration("1.0", null, null);
        doc.AppendChild(docNode);

        XmlNode RequestChild = doc.CreateElement("Request");
        doc.AppendChild(RequestChild);
                
        XmlNode MerchantChild = doc.CreateElement("MerchantID");
        MerchantChild.InnerText = "Test";
        RequestChild.AppendChild(MerchantChild);

        XmlNode OrderIDChild = doc.CreateElement("OrderID");
        OrderIDChild.InnerText = "TEST_" + Session.SessionID.ToString().ToUpper();
        RequestChild.AppendChild(OrderIDChild);

        XmlNode AmountChild = doc.CreateElement("Amount");
        AmountChild.InnerText = "100";
        RequestChild.AppendChild(AmountChild);

        XmlNode FullNameChild = doc.CreateElement("FullName");
        FullNameChild.InnerText = "Mejbahur";
        RequestChild.AppendChild(FullNameChild);

        XmlNode EmailChild = doc.CreateElement("Email");
        EmailChild.InnerText = "metun_ice04@yahoo.com";
        RequestChild.AppendChild(EmailChild);


        XmlNode PaymentSuccessUrlChild = doc.CreateElement("PaymentSuccessUrl");
        PaymentSuccessUrlChild.InnerText = "https://ibanking.tblbd.com/Checkout/MerchantPaymentConfirmation.aspx";
        RequestChild.AppendChild(PaymentSuccessUrlChild);

        XmlNode OrderDetailsChild = doc.CreateElement("OrderDetails");
        OrderDetailsChild.InnerText = "OrderDetails";
        RequestChild.AppendChild(OrderDetailsChild);

        XmlNode StudentIDChild = doc.CreateElement("StudentID");
        StudentIDChild.InnerText = "2214";
        OrderDetailsChild.AppendChild(StudentIDChild);
     
        XmlNode RollChild = doc.CreateElement("Roll");
        RollChild.InnerText = "124777";
        OrderDetailsChild.AppendChild(RollChild);

        XmlNode RegChild = doc.CreateElement("Reg");
        RegChild.InnerText = "2018";
        OrderDetailsChild.AppendChild(RegChild);



        return doc.OuterXml;
       
    }

    static public string DecodeFrom64(string encodedData)
    {
        byte[] encodedDataAsBytes
            = System.Convert.FromBase64String(encodedData);
        string returnValue =
           System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes);
        return returnValue;
    }
}