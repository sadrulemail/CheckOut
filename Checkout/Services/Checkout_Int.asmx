<%@ WebService Language="C#" Class="Checkout_Int" %>

using System;
using System.Web;
using System.Web.Services;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;
using System.Data;

[WebService(Namespace = "https://ibanking.tblbd.com/CheckOut")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class Checkout_Int  : System.Web.Services.WebService {


    [WebMethod(Description = "Service Task: Checkout Order Response"
         + "<br>" + "Returns:"
         + "<br>" + "XmlMsg"
       )]
    public string GetCheckoutOrder(string CheckoutXmlMsg)
    {

        DataTable dt = new DataTable();
        DataTable dt_chield = new DataTable();
        XmlDataDocument doc = new XmlDataDocument();
        doc.LoadXml(CreateCheckoutOrder());
        XmlReader xmlReader = new XmlNodeReader(doc);
        DataSet ds = new DataSet();
        ds.ReadXml(xmlReader);
        dt = ds.Tables[0];
        PayServiceResult payObj = new PayServiceResult();
        try
        {
            string OrderID = dt.Rows[0]["OrderID"].ToString();
            decimal Amount = decimal.Parse( dt.Rows[0]["Amount"].ToString());
            string MerchantID = dt.Rows[0]["MerchantID"].ToString();
            string FullName = dt.Rows[0]["FullName"].ToString();
            string Email = dt.Rows[0]["Email"].ToString();
            string PaymentSuccessUrl = dt.Rows[0]["PaymentSuccessUrl"].ToString();
            payObj= GetCheckoutRefID(OrderID, Amount,MerchantID,FullName,Email,PaymentSuccessUrl);
        }
        catch (Exception ex)
        {
            CommonPayXml();
            // error return to merchant
        }
        if (payObj.RefID != "")
        {
            if (ds.Tables.Count == 2)
                dt_chield = ds.Tables[1];

            string Chield_Tag = "";
            string Chield_TagValue = "";
            try
            {
                foreach (DataColumn column in dt_chield.Columns)
                {
                    Chield_Tag = column.ToString().Trim();
                    Chield_TagValue = dt_chield.Rows[0][column].ToString();
                    if (Chield_Tag != "Request_Id")
                        SaveOrderIdDetails(payObj.RefID, Chield_Tag, Chield_TagValue);
                }
            }
            catch(Exception ex)
            {
                    CommonPayXml();
            }

        }
        //else
        //{
        //    //error
        //}

        return payObj.XmlMsg.ToString();
        // return EncodeTo64(payObj.XmlMsg.ToString());
    }

    private string CommonPayXml()
    {
        return "<OrderResponse><RefID></RefID><KeyCode></KeyCode><PaymentUrl>https://ibanking.tblbd.com/checkout/Payment.aspx</PaymentUrl><StatusCode>10</StatusCode><Status>Internal Error,Try again</Status></OrderResponse>";

    }

    private PayServiceResult GetCheckoutRefID(string OrderID,decimal Amount,string MerchantID,string FullName, string Email, string PaymentSuccessUrl)
    {
        PayServiceResult payObj = new PayServiceResult();
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

                    SqlParameter sqlXml = new SqlParameter("@XmlMsg", SqlDbType.VarChar,255);
                    sqlXml.Direction = ParameterDirection.InputOutput;
                    sqlXml.Value = "";
                    cmd.Parameters.Add(sqlXml);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    // RefID = sqlRefID.Value.ToString();
                    payObj.RefID=sqlRefID.Value.ToString();
                    payObj.XmlMsg=sqlXml.Value.ToString();
                }
            }
        }
        catch (Exception ex)
        {

        }
        return payObj;
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

             Random random = new Random();  
    Int64 a= random.Next(0, 10000000);  
        XmlNode OrderIDChild = doc.CreateElement("OrderID");
        OrderIDChild.InnerText = "TEST_" + a.ToString().ToUpper();
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

    static public string EncodeTo64(string toEncode)
    {
        byte[] toEncodeAsBytes
              = System.Text.ASCIIEncoding.ASCII.GetBytes(toEncode);
        string returnValue
              = System.Convert.ToBase64String(toEncodeAsBytes);
        return returnValue;
    }

}

struct PayServiceResult
{
    public string RefID { get; set; }
    public string XmlMsg { get; set; }

};