<%@ WebService Language="C#" Class="Checkout_Payment_Verify" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data.SqlClient;
using System.Configuration;

[WebService(Namespace = "https://ibanking.tblbd.com/CheckOut")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class Checkout_Payment_Verify  : System.Web.Services.WebService {

    [WebMethod(Description = "Service Task: Verify the OrderID, RefID and Amount"
        + "<br>" + "Returns:"
        + "<br>" + "Status"
        + "<br>" + "1 = Successful"
        + "<br>" + "0 = Invalid"

      )]
    public string Transaction_Verify(string OrderID, string RefID, string Amount)
    {
        //double _Amount = 0;
        //try
        //{
        //    _Amount = double.Parse(Amount);
        //}
        //catch (Exception)
        //{
        //    return "0";
        //}

        String done = "0";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Verify";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.VarChar).Value = Amount;
                cmd.Parameters.Add("@isWebserviceCalled", System.Data.SqlDbType.Bit).Value = true;

                SqlParameter sqlDone = new SqlParameter("@Done", System.Data.SqlDbType.TinyInt);
                sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                sqlDone.Value = 0;
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();
                done = string.Format("{0}", sqlDone.Value);
            }
        }

        return done;
    }
    [WebMethod(Description = "Service Task: Verify the OrderID, RefID and MerchantID"
  + "<br>" + "Returns:"
  + "<br>" + "XmlMsg"
)]
    public string Transaction_Verify_Details(string OrderID, string RefID, string MerchantID)
    {
        String XmlMsg = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Verify_Details";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                SqlParameter sqlXmlMsg = new SqlParameter("@XmlMsg", System.Data.SqlDbType.VarChar, -1);
                sqlXmlMsg.Direction = System.Data.ParameterDirection.InputOutput;
                sqlXmlMsg.Value = "";
                cmd.Parameters.Add(sqlXmlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();
                XmlMsg = string.Format("{0}", sqlXmlMsg.Value);
            }
        }

        return EncodeTo64(XmlMsg);
    }
    [WebMethod(Description = "Service Task: Transaction Log the OrderID, MerchantID and KeyCode"
         + "<br>" + "Returns:"
         + "<br>" + "XmlMsg"
       )]
    public string Transaction_Log(string OrderID,  string MerchantID,string KeyCode)
    {
        String Done = "";
        string XmlMsg = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Log_OrderIdWise";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;
                cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar).Value = KeyCode;

                SqlParameter sqlDone = new SqlParameter("@Done", System.Data.SqlDbType.VarChar);
                sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                //cmd.ExecuteNonQuery();
                //Done = string.Format("{0}", sqlXmlMsg.Value);
                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    //Done = string.Format("{0}", sqlDone.Value);
                    //if (Done == "1")
                    //{
                    while (sdr.Read())
                    {
                        XmlMsg += string.Format("{0}", sdr["xml_return"]);
                    }
                    //}
                    //else
                    //{
                    //    XmlMsg = "KeyCode Error";
                    //}
                }
                if(XmlMsg=="")
                     XmlMsg=  "Data/KeyCode Not Found";
                XmlMsg = "<Response date=" + DateTime.Now + ">" + XmlMsg+"</Response>";
            }
        }

        return EncodeTo64(XmlMsg);
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