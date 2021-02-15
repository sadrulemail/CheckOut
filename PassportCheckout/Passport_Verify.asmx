<%@ WebService Language="C#" Class="Passport_Verify" %>

using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;


/// <summary>
/// Summary description for Passport_Verify
/// </summary>
//[WebService(Namespace = "http://test.webapi.tblbd.com")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class Passport_Verify : System.Web.Services.WebService{
    public Passport_Verify () {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    //[System.Web.Services.Protocols.SoapDocumentMethod]
    public string CheckPayment(
            string PaymentReferenceNumber,
            //DateTime PaymentDate,
            string FullName,
            decimal PaymentAmount,
            string EnrolmentID,
            DateTime EnrolmentDate,
            string Keycode
        )
    {
        //string PageUrl = Context.Request.Url.OriginalString.Split('?')[0];
        //string PaymentType = "*";
        string RetVal = "";
        string Passport_KeyCode = getValueOfKey("Passport_KeyCode");

        if (Passport_KeyCode == Keycode)
        {

            //string Referrer = "";

            //SqlConnection.ClearAllPools();

            //try
            //{
            //    Referrer = HttpContext.Current.Request.UserHostAddress;
            //}
            //catch (Exception) { }


            //using (SqlConnection conn = new SqlConnection())
            //{
            //    string Query = "s_Checkout_Path_Check";
            //    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            //    using (SqlCommand cmd = new SqlCommand())
            //    {
            //        cmd.CommandText = Query;
            //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
            //        cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
            //        cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;
            //        cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
            //        cmd.Parameters.Add("@Caller", System.Data.SqlDbType.VarChar).Value = Referrer;

            //        cmd.Connection = conn;
            //        conn.Open();

            //        SqlDataReader sdr = cmd.ExecuteReader();

            //        if (!sdr.HasRows)
            //            RetVal = "-1";

            //        sdr.Close();

            //    }
            //}

            //if (RetVal != "")
            //{
            //    Common.WriteLog(Context.Request.Url.OriginalString, string.Format("HTTP_ORIGIN: {0}", HttpContext.Current.Request.ServerVariables["HTTP_HOST"]));
            //    Common.WriteLog(PageUrl, "Keycode:" + Keycode + " PaymentType:" + PaymentType);

            //    return RetVal;
            //}

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Passport_CheckPayment";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = FullName;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = PaymentAmount;
                    cmd.Parameters.Add("@EID", System.Data.SqlDbType.VarChar).Value = EnrolmentID;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = PaymentReferenceNumber;
                    cmd.Parameters.Add("@PassportEnrolmentDate", System.Data.SqlDbType.DateTime).Value = EnrolmentDate;
                    //cmd.Parameters.Add("@PassportPaymentDate", System.Data.SqlDbType.DateTime).Value = PaymentDate;

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 10);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = "";
                    cmd.Parameters.Add(sqlMsg);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    RetVal = sqlMsg.Value.ToString();
                }
            }
        }
        else
        {
            RetVal = "-1";
        }

        if (RetVal == "") RetVal = "";
        return RetVal;
    }   

    private string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }
}