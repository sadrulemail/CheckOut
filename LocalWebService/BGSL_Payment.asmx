<%@ WebService Language="C#" Class="BGSL_Payment" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;



/// <summary>
/// Summary description for NID_GetDueAmount
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class BGSL_Payment : System.Web.Services.WebService
{
    int LoginAttem = 0;

    [WebMethod(Description = "Service Task: Get amount from BGSL Server and 14 Digit new RefID"
        + "<br>" + "Customer Code:"
              + "<br>" + "Start Year:"
              + "<br>" + "End Year:"
              + "<br>" + "Start Month:"
              + "<br>" + "End Month:"
              + "<br>" + "Key Code:"
        + "<br>" + "Returns:"
        + "<br>" + "RefID" + "|" + "Amount"
        + "<br>" + "-2: " + "Invalid KeyCode"
      )]
    public string GetDueAmountWithRefID(
        string Customer_Code,
        string From_Year,
        string From_Month,
        string End_Year,
        string End_Month,
        //string Meter_Type,
        string KeyCode)
    {
        //  decimal Amount = 0;
        //  string RefID = "";
        string Due_Amount = "0";

        string RefID = "";
        string PaymentType = "MB_OFF";
        //string MarchentID = "BGSL";
        //decimal ServiceCharge = 0;
        //decimal VatAmount = 0;
        //decimal Fees = 0;
        //decimal SurCharge = 0;
        //string Meter_Type = "NM";

        try
        {
            From_Year = Int32.Parse(From_Year).ToString();
            End_Year = Int32.Parse(End_Year).ToString();
            Int32 f_month = Int32.Parse(From_Month);
            Int32 e_month = Int32.Parse(End_Month);

            if (f_month >= 1 && f_month <= 12 && e_month >= 1 && e_month <= 12)
            {
                From_Month = "0" + f_month.ToString();
                From_Month = From_Month.Substring(From_Month.Length - 2);

                End_Month = "0" + e_month.ToString();
                End_Month = End_Month.Substring(End_Month.Length - 2);

            }
            else
                return "0";



        }
        catch
        {
            return "0";
        }


        if (KeyCode != getValueOfKey("NID_KeyCode"))
            return "0";
        try
        {

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_BGSL_GetDues_Amount1";  //Due amount
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Customer_Code", System.Data.SqlDbType.VarChar).Value = Customer_Code;
                    cmd.Parameters.Add("@Y_Start", System.Data.SqlDbType.VarChar).Value = From_Year;
                    cmd.Parameters.Add("@Y_End", System.Data.SqlDbType.VarChar).Value = End_Year;
                    cmd.Parameters.Add("@M_Start", System.Data.SqlDbType.VarChar).Value = From_Month;
                    cmd.Parameters.Add("@M_End", System.Data.SqlDbType.VarChar).Value = End_Month;
                    cmd.Parameters.Add("@PaymentType", System.Data.SqlDbType.VarChar).Value = PaymentType;
                    SqlParameter sqlDueAmount = new SqlParameter("Due_Amount", SqlDbType.VarChar, 18);
                    sqlDueAmount.Direction = ParameterDirection.InputOutput;
                    sqlDueAmount.Value = "";
                    cmd.Parameters.Add(sqlDueAmount);

                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 18);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    Due_Amount = string.Format("{0}", sqlDueAmount.Value);
                    RefID = string.Format("{0}", sqlRefID.Value);
                }
            }

        }
        catch (Exception ex)
        {
            return string.Format("{0}|{1}", RefID, Due_Amount);
        }



        return string.Format("{0}|{1}", RefID, Due_Amount);
    }

    [WebMethod(Description = "Service Task: Mark Transaction as Paid"
        + "<br>" + "Returns:"
        + "<br>" + "1: " + "Success"
        + "<br>" + "-1: " + "Failed to Update"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "-3: " + "TrnID Already Exists"
        + "<br>" + "-4: " + "Payment is not found"

      )]
    public string ConfirmPayment_MM(
        string RefID,
        string KeyCode,
        string TrnID,
        string Mobile)
    {
        string RetVal = "";
        //string PaymentType = "MB_OFF";
        //bool PaymentStatus = false;
        //string voterID = "";
        //decimal fees = 0;

        string merchant_acc = "";
        //  string sessionUid = "";
        if (KeyCode != getValueOfKey("NID_KeyCode"))
            return "-2";


        Boolean check_pay = false;
        Payment_Verify pv = new Payment_Verify();
        DataTable Checkout_DT = pv.GetCheckout_Ref_Details(RefID);
        if (Checkout_DT.Rows.Count > 0)
            merchant_acc = Checkout_DT.Rows[0]["AccountNo"].ToString();
        check_pay = pv.TBMMpaymentInfoCheck("DIPQ718TOJQWK6663000", "8800000000001", 1, RefID);
        check_pay = true; // have to remove before live environment
        if (check_pay)
        {

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_BGSL_PayBill_Temp";  //Mark as Paid to BILL No
                                                       //s_BGSL_PayBill
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "MB_OFF";
                    cmd.Parameters.Add("@TrnID", System.Data.SqlDbType.VarChar).Value = TrnID;
                    cmd.Parameters.Add("@MobileNo", System.Data.SqlDbType.VarChar).Value = Mobile;
                    //cmd.Parameters.Add("@Verified", System.Data.SqlDbType.Bit).Value = PaymentStatus;

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = "";
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    RetVal = string.Format("{0}", sqlDone.Value);
                }
            }
        }
        else
        {
            RetVal = "-4";
        }

        return RetVal;
    }

    [WebMethod(Description = "Service Task: Mark Transaction as Paid through e-Commerce"
       + "<br>" + "Returns:"
       + "<br>" + "1: " + "Success"
       + "<br>" + "-1: " + "Failed to Update"
       + "<br>" + "-2: " + "Invalid KeyCode"
       + "<br>" + "-3: " + "TrnID Already Exists"
       + "<br>" + "-4: " + "Payment is not found"

     )]
    public string ConfirmPayment_Online( string RefID, string KeyCode)
    {
        string RetVal = "";


        //if (KeyCode != getValueOfKey("NID_KeyCode"))
        //    return "-2";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_BGSL_PayBill_Online_Temp";  //Mark as Paid to BILL No
                                                          //s_BGSL_PayBill
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                //cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PayType;
                //cmd.Parameters.Add("@TrnID", System.Data.SqlDbType.VarChar).Value = TrnID;
                //cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar).Value = KeyCode;
                //cmd.Parameters.Add("@Verified", System.Data.SqlDbType.Bit).Value = PaymentStatus;

                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                RetVal = string.Format("{0}", sqlDone.Value);
            }
        }


        //}
        //else
        //{
        //    RetVal = "-4";
        //}

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

    string sessionUuid = "";
    public string GetBGSLDueAmount(string Customer_Code, string From_Year, string From_Month, string End_Year, string End_Month, string Meter_Type)
    {
        string Due_Amount = "0";
        //   string Meter_Type = "nm";
        string SurCharge = "0";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_BGSL_GetDues_Amount1";  //Due amount
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Customer_Code", System.Data.SqlDbType.VarChar).Value = Customer_Code;
                    cmd.Parameters.Add("@Y_Start", System.Data.SqlDbType.VarChar).Value = From_Year;
                    cmd.Parameters.Add("@Y_End", System.Data.SqlDbType.VarChar).Value = End_Year;
                    cmd.Parameters.Add("@M_Start", System.Data.SqlDbType.VarChar).Value = From_Month;
                    cmd.Parameters.Add("@M_End", System.Data.SqlDbType.VarChar).Value = End_Month;
                    cmd.Parameters.Add("@Meter_Type", System.Data.SqlDbType.VarChar).Value = Meter_Type;
                    SqlParameter sqlDone = new SqlParameter("Due_Amount", SqlDbType.VarChar, 18);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = "";
                    cmd.Parameters.Add(sqlDone);

                    SqlParameter sqlSurCharge = new SqlParameter("SurCharge", SqlDbType.VarChar, 18);
                    sqlSurCharge.Direction = ParameterDirection.InputOutput;
                    sqlSurCharge.Value = "";
                    cmd.Parameters.Add(sqlSurCharge);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    Due_Amount = string.Format("{0}", sqlDone.Value);
                    SurCharge = string.Format("{0}", sqlSurCharge.Value);
                }
            }

            return Due_Amount + "-" + SurCharge;
        }
        catch (Exception ex)
        {
            return Due_Amount + "-" + SurCharge;
        }


    }



}