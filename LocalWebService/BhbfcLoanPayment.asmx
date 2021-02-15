<%@ WebService Language="C#" Class="BhbfcLoanPayment" %>

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
public class BhbfcLoanPayment : System.Web.Services.WebService
{


    [WebMethod(Description = "Service Task: BHBFC Loan RePayment Installment"
        + "<br>" + "Returns:"
        + "<br>" + "RefID"+ "|" + "Status"
        + "<br>" + "1: " + "Success"
        + "<br>" + "-1: " + "Failed to Update"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "-3: " + "TrnID Already Exists"
        + "<br>" + "10: " + "Insert Fail"
        + "<br>" + "-10: " + "Loan Acc not matched"
      )]
    public string PayBhbfcLoanInstallment(
        string AccountNo,
        string AccountName,
        string BranchName,
        string PaymentPurpose,
        double Amount,
        double ServiceCharge,
        string TrnID,
        string Email,
        string MobileNo,
        string KeyCode)
    {
        if (KeyCode != getValueOfKey("BHBFC_KeyCode"))
            return "-2";

        string RefID = "";
        string PaymentType = "MB_OFF";
        string MarchentID = "BHBFC";
        string RetVal = "";
        if (CheckBhbfcLoanAccInfo(AccountNo) != true)
            return "-10";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Payments_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = AccountName;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount + ServiceCharge;
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = Email;
                    //cmd.Parameters.Add("@NotifyMobile", System.Data.SqlDbType.VarChar).Value = MobileNo;
                    cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = AccountNo;
                    cmd.Parameters.Add("@Meta2", System.Data.SqlDbType.VarChar).Value = BranchName;
                    cmd.Parameters.Add("@Meta3", System.Data.SqlDbType.VarChar).Value = PaymentPurpose;

                    cmd.Parameters.Add("@ServiceCharge", SqlDbType.Decimal).Value = ServiceCharge;
                    cmd.Parameters.Add("@MarchentID", SqlDbType.VarChar).Value = MarchentID;
                    cmd.Parameters.Add("@Type", SqlDbType.VarChar).Value = PaymentType;
                    cmd.Parameters.Add("@Fees", System.Data.SqlDbType.Decimal).Value = Amount;


                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = false;
                    cmd.Parameters.Add(sqlDone);

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = "";
                    cmd.Parameters.Add(sqlMsg);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    if ((bool)sqlDone.Value == true)
                    {
                        RefID = sqlRefID.Value.ToString();
                    }
                    else
                    {
                        RetVal = "10";
                    }
                }
            }
            Payment_Verify PV = new Payment_Verify();
            DataTable Checkout_DT = PV.GetCheckout_Ref_Details(RefID);
            string merchant_acc = "";
            double TotalAmount = 0;
            if (Checkout_DT.Rows.Count > 0)
            {
                merchant_acc = Checkout_DT.Rows[0]["AccountNo"].ToString();
                TotalAmount = Double.Parse(Checkout_DT.Rows[0]["TotalAmount"].ToString());
            }

            if (!PV.TBMMpaymentInfoCheck(TrnID, merchant_acc, TotalAmount, RefID))

            {

                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Checkout_Payment_Req_to_Paid";  //Mark as Paid
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                        cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "MB_OFF";
                        cmd.Parameters.Add("@TrnID", System.Data.SqlDbType.VarChar).Value = TrnID;
                        cmd.Parameters.Add("@MobileNo", System.Data.SqlDbType.VarChar).Value = MobileNo;
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
                RetVal = "-1";
            }

        }
        catch(Exception ex)
        {
            Common.WriteLog("PayBhbfcLoanInstallment",
                   string.Format("Error: 205:,ref_id: {0},Error: {1}",
                   RefID,

                   ex.Message));

        }

        return string.Format("{0}|{1}", RefID, RetVal);
    }

    private bool CheckBhbfcLoanAccInfo(string AccountNo)
    {
        String loanType = "";
        String loanCat = "";
        String loanProduct = "";
        bool Done = false;
        try
        {


            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Bhbfc_CustLoan_Info";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@LoanAccountNo", System.Data.SqlDbType.VarChar).Value = AccountNo;

                    SqlParameter sqlloanType = new SqlParameter("@loanType", System.Data.SqlDbType.VarChar, 50);
                    sqlloanType.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanType.Value = "";
                    cmd.Parameters.Add(sqlloanType);

                    SqlParameter sqlloanCat = new SqlParameter("@loanCat", System.Data.SqlDbType.VarChar, 50);
                    sqlloanCat.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanCat.Value = "";
                    cmd.Parameters.Add(sqlloanCat);

                    SqlParameter sqlloanProduct = new SqlParameter("@loanProduct", System.Data.SqlDbType.VarChar, 50);
                    sqlloanProduct.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanProduct.Value = "";
                    cmd.Parameters.Add(sqlloanProduct);

                    cmd.Connection = conn;
                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();
                    cmd.ExecuteNonQuery();

                    loanType = string.Format("{0}", sqlloanType.Value);
                    loanCat = string.Format("{0}", sqlloanCat.Value);
                    loanProduct = string.Format("{0}", sqlloanProduct.Value);

                }
            }



        }
        catch (Exception ex)
        {
            Common.WriteLog("s_Bhbfc_CustLoan_Info", string.Format("{0}", ex.Message));
            Done = false;
        }

        if (loanType != "" && loanCat != "" && loanProduct != "")
        {
            Done = true;
        }
        return Done;
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