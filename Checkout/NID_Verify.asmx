<%@ WebService Language="C#" Class="NID_Verify" %>

using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;
using System.Web.Services;

/// <summary>
/// Summary description for NID_Verify
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class NID_Verify : System.Web.Services.WebService {

    [WebMethod(Description = "Service Task: RefID Mark as Used"
        + "<br>" + "Returns:"
        + "<br>" + "-2: Invalid KeyCode"
        + "<br>" + "0: Verification Successful"        
        + "<br>" + "1: Already Used"
        + "<br>" + "3: Amount Mismatch"
        + "<br>" + "4: Ref No Mismatch"
        + "<br>" + "9: Other Reasons/Failed to Update"
      )]
    public string NID_PaymentVerify(string NID, string RefID, double Amount, string KeyCode) 
    {
        string RetVal = "";

        if (KeyCode != getValueOfKey("NID_KeyCode_Public"))
            return "-2";
        
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_NID_CheckPayment";
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@NID", System.Data.SqlDbType.VarChar).Value = NID;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;                

                SqlParameter sqlMsg = new SqlParameter("@Msg", System.Data.SqlDbType.VarChar, 10);
                sqlMsg.Direction = System.Data.ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();
                RetVal = sqlMsg.Value.ToString();
            }
        }

        if (RetVal == "") RetVal = "";
        return RetVal;
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }      
}