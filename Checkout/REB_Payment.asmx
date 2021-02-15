<%@ WebService Language="C#" Class="REB_Payment" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for REB_Payment
/// </summary>
[WebService(Namespace = "http://mobile.trustbanklimited.com/checkout/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class REB_Payment : System.Web.Services.WebService
{

    public REB_Payment()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod(Description = "Service Task: Get REB Bill Amount"
        + "<br>" + "-1 = Error"
        + "<br>" + "-2 = UrlReferrer is not Allowed"
        + "<br>" + "-3 = Bill Number not Found"
        + "<br>" + "-4 = Bill Already Paid"
      )]
    public string getRebBillAmount(string BillNumber, string KeyCode)
    {

        if (string.IsNullOrWhiteSpace(BillNumber)) return "-1";
        if (string.IsNullOrWhiteSpace(KeyCode)) return "-1";

        if (BillNumber.Trim().Length < 10) return "-1";
        if (KeyCode.Trim().Length < 10) return "-1";


        string PageUrl = Context.Request.Url.OriginalString.Split('?')[0];
        string PaymentType = "MB_OFF";
        string Referrer = "";
        string Msg = "";
        string Amount = "0";

        try
        {
            Referrer = HttpContext.Current.Request.UserHostAddress;
        }
        catch (Exception) { }

        SqlConnection.ClearAllPools();


        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Path_Check";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
                cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = KeyCode;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                cmd.Parameters.Add("@Caller", System.Data.SqlDbType.VarChar).Value = Referrer;

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    if (!sdr.HasRows)
                    {
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_PageURL=" + PageUrl);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_Keycode=" + KeyCode);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_PaymentType=" + PaymentType);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_Referrer=" + Referrer);

                        return "-2";                        
                    }
                }
            }
        }


       


        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_REB_Get_Bill_Amount";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@BillNumber", System.Data.SqlDbType.VarChar, 50).Value = BillNumber.Trim();

                SqlParameter sqlAmount = new SqlParameter("@Amount", SqlDbType.Money);
                sqlAmount.Direction = ParameterDirection.InputOutput;
                sqlAmount.Value = 0;
                cmd.Parameters.Add(sqlAmount);


                SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                sqlMsg.Direction = ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                Amount = string.Format("{0:N2}", sqlAmount.Value);
                Msg = sqlMsg.Value.ToString();                
            }
        }

        if (Msg != "1")
            return Msg;
        else
            return Amount;
    }

    [WebMethod(Description = "Service Task: REB Bill Payment Mark as Paid"
         + "<br>" + "1 = Successfully Bill Paid"
         + "<br>" + "0 = Unable to Paid"
         + "<br>" + "-1 = Error"
         + "<br>" + "-2 = UrlReferrer is not Allowed"                       
      )]
    public string RebPaymentMarkAsPaid(
        string BillNumber,
        double Amount, 
        string TransactionID,
        string AccountNo,        
        string KeyCode
        )
    {

        if (string.IsNullOrWhiteSpace(BillNumber)) return "-1";
        if (string.IsNullOrWhiteSpace(KeyCode)) return "-1";

        if (BillNumber.Trim().Length < 10) return "-1";
        if (KeyCode.Trim().Length < 10) return "-1";
        if (Amount <= 0) return "0";
        if (TransactionID.Trim().Length < 5) return "-1";
        if (AccountNo.Trim().Length < 5) return "-1";


        string PageUrl = Context.Request.Url.OriginalString.Split('?')[0];
        string PaymentType = "MB_OFF";
        string Referrer = "";
        string Msg = "";
        //string Amount = "0";

        try
        {
            Referrer = HttpContext.Current.Request.UserHostAddress;
        }
        catch (Exception) { }

        SqlConnection.ClearAllPools();


        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Path_Check";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
                cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = KeyCode;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                cmd.Parameters.Add("@Caller", System.Data.SqlDbType.VarChar).Value = Referrer;

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    if (!sdr.HasRows)
                    {
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_PageURL=" + PageUrl);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_Keycode=" + KeyCode);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_PaymentType=" + PaymentType);
                        Common.WriteLog(Context.Request.Url.OriginalString, "-2_Referrer=" + Referrer);

                        return "-2";
                    }                    
                }
            }
        }

        


        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_REB_Mark_As_Paid";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@BillNumber", System.Data.SqlDbType.VarChar, 50).Value = BillNumber.Trim();
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Money).Value = Amount;
                cmd.Parameters.Add("@AccountNo", System.Data.SqlDbType.VarChar).Value = AccountNo;
                cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = TransactionID;
                cmd.Parameters.Add("@PaymentType", System.Data.SqlDbType.VarChar).Value = PaymentType;


                SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 10);
                sqlMsg.Direction = ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                Msg = sqlMsg.Value.ToString();
            }
        }

       return Msg;       
    }
}
    

