<%@ WebService Language="C#" Class="CBS" %>

using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for CBS
/// </summary>
[WebService(Namespace = "http://172.20.1.87")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class CBS : System.Web.Services.WebService
{
    [WebMethod]
    public AccInfo GetDepositAccInfo(string AccountNo, string KeyCode)
    {
        AccInfo t = new AccInfo();
        if (KeyCode != getValueOfKey("CBS_KeyCode"))
        {
            t.Status = "401";   //Unauthorised"
            t.Msg = "Invalid Key Code";
            t.AccountNo = AccountNo;
            return t;
        }

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["CBS_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = "s_Account_Info_Depositable";
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@AccountNo", System.Data.SqlDbType.VarChar, 20).Value = AccountNo;
                    cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar, 100).Value = KeyCode;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed) conn.Open();

                    SqlDataReader oReader = cmd.ExecuteReader();
                    if (oReader.HasRows)
                    {
                        while (oReader.Read())
                        {
                            t.AccountNo = string.Format("{0}", oReader["AccountNo"]);
                            t.AccName = string.Format("{0}", oReader["AccName"]);
                            t.Currency = string.Format("{0}", oReader["Currency"]);
                            t.Mobile = string.Format("{0}", oReader["Mobile1"]);
                            t.Status = "1";
                            t.Msg = "Valid";
                        }
                    }
                    else
                    {
                        t.Status = "404";   //"Not Found"
                        t.Msg = "Invalid Account";
                        t.AccountNo = AccountNo;
                        return t;
                    }
                }
            }
        }
        catch(Exception ex)
        {
            t.Status = "408";   //Request Timeout
            t.Msg = "Unable to process (" + ex.Message + ")";
            t.AccountNo = AccountNo;
            return t;
        }

        return t;
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

public struct AccInfo
{
    public string Status;
    public string Msg;
    public string AccountNo;
    public string AccName;
    public string Currency;
    public string Mobile;
}
