<%@ WebService Language="C#" Class="Payment_Info" %>

using System;
using System.Web;
using System.Web.Services;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;

[WebService(Namespace = "https://ibanking.tblbd.com/CheckOut")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class Payment_Info  : System.Web.Services.WebService {

    
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
    public string Get_Transaction_Ref(string OrderID, string MerchantID, string KeyCode)
    {
        bool Done = false;
        StringBuilder XmlMsg = new StringBuilder();
        string Msg = "";
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

                SqlParameter sqlDone = new SqlParameter("@Done", System.Data.SqlDbType.Bit);
                sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                sqlDone.Value = Done;
                cmd.Parameters.Add(sqlDone);

                SqlParameter sqlMsg = new SqlParameter("@XmlMsg", System.Data.SqlDbType.NVarChar, -1);
                sqlMsg.Direction = System.Data.ParameterDirection.InputOutput;
                sqlMsg.Value = Msg;
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                //cmd.ExecuteNonQuery();
                //Done = string.Format("{0}", sqlXmlMsg.Value);
                cmd.ExecuteNonQuery();
                //{
                //    Done = (bool)sqlDone.Value;
                //    //if (Done == "1")
                //    //{
                //    while (sdr.Read())
                //    {
                //        XmlMsg.Append(string.Format("{0}", sdr["xml_return"]));
                //    }
                //    //}
                //    //else
                //    //{
                //    //    XmlMsg = "KeyCode Error";
                //    //}
                //}
                //if (XmlMsg.Length == 0)
                //{
                XmlMsg.Append(sqlMsg.Value.ToString());
                //}

                //XmlMsg.Append();
            }
        }
        //return ("<Response date='" + DateTime.Now + "'>" + XmlMsg.ToString() + "</Response>".ToString());
        //return EncodeTo64(XmlMsg.ToString());

        return EncodeTo64(XmlMsg.ToString());
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