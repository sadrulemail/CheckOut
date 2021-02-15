<%@ WebHandler Language="C#" Class="Checkout_Payment_Success_TBMM" %>

using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.Web;

public class Checkout_Payment_Success_TBMM : IHttpHandler
{
    DataTable CheckoutPaymentDT;
    string RefID = "";

    public void ProcessRequest (HttpContext context)
    {
        try
        {
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("1");
            //context.Response.End();
            //return;

            string LogText = "";

            foreach (string key in context.Request.Form.Keys)
            {
                LogText += String.Format("FORM:{0}:{1}\n", key, context.Request.Form[key]);
            }

            if (context.Request.QueryString.Count > 0)
            {
                LogText += String.Format("QueryString:{0}\n", context.Request.QueryString);
            }

            Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", LogText);
        }
        catch (Exception ex)
        {
            Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", ex.Message);
        }

        RefID = string.Format("{0}", context.Request.Form["application_id"]);
        string TransactionID = string.Format("{0}", context.Request.Form["transaction_id"]);
        string Status = string.Format("{0}", context.Request.Form["status"]);
        Status = Status.Replace("{", "").Replace("}", "");
        string SenderAcc = "0";
        try
        {
            SenderAcc = string.Format("{0}", context.Request.Form["SenderAcc"]);
        }
        catch (Exception) { }

        CheckoutPaymentDT = new DataTable();
        getCheckout_Ref_Details();


        using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_TBMM_Response_Insert";
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.Add("@transaction_id", System.Data.SqlDbType.VarChar).Value = TransactionID;
                cmd.Parameters.Add("@application_id", System.Data.SqlDbType.VarChar).Value = RefID;
                //cmd.Parameters.Add("@BillingCode", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", RefID);
                //cmd.Parameters.Add("@success", System.Data.SqlDbType.VarChar).Value = Status;
                cmd.Parameters.Add("@status", System.Data.SqlDbType.VarChar).Value = Status;

                cmd.Connection = conn;

                if (conn.State == System.Data.ConnectionState.Closed)
                    conn.Open();

                cmd.ExecuteNonQuery();
                //isSaved = true;

            }
        }


        if (TransactionID.Length < 5 || RefID.Length < 10)
        {

            Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", string.Format("TransactionID/txid: {0},RefID/Billcode: {1}, Status: {2}, Keycode: {3}",
               TransactionID,
               RefID,
               Status,
               ""));
            //  llbStatus.Text = "Invalid Request.";
            return;
        }


        if (Status.ToUpper().Trim() == "SUCCESS")
        {
            double Amount = 0;
            try
            {
                try
                {
                    Amount = double.Parse(CheckoutPaymentDT.Rows[0]["Amount"].ToString());
                }
                catch(Exception eee)
                {
                    Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", "Amount Parse Failed: " + eee.Message);
                }


                if (
                    //TBMM Webservice check
                    TBMMpaymentInfoCheck(
                    TransactionID,
                    CheckoutPaymentDT.Rows[0]["AccountNo"].ToString(),
                    Amount)
                    )
                {
                    //Payment Found in TBMM
                    bool Done = Save_Payments_Checkout_Success(RefID, null, TransactionID, null, "MB", long.Parse(SenderAcc));
                    if (Done)
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("1");
                        context.Response.End();
                        return;
                    }
                    else
                    {
                        //   Response.Clear();
                        Common.WriteLog("Checkout_Payment_Success_TBMM.ashx",
                            string.Format("Failed to update the Transaction: {0}, RefID: {1}",
                            TransactionID,
                            RefID));
                        //   llbStatus.Text = "Failed to update the Transaction. (3)";

                        context.Response.ContentType = "text/plain";
                        context.Response.Write("0");
                        context.Response.End();
                        return;
                    }
                }
                else
                {
                    Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", "Error 420 ashx");
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("0");
                    context.Response.End();
                    return;
                }
            }
            catch (Exception ex)
            {
                Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", "Error 25: " + ex.Message);
            }
            //Redirect = string.Format("{0}&billcode={1}", Redirect, RefID);
            //Response.Redirect(Redirect, true);
        }
        else
        {
            Common.WriteLog("Checkout_Payment_Success_TBMM.ashx", "Invalid Status:" + Status);
        }

    }
    private bool Save_Payments_Checkout_Success(string _RefID, string _ItclOrderID, string _TransactionID, string _PAN, string _TransactionType, long SenderAcc)
    {
        bool RetVal = false;

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Success";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = _TransactionID;
                cmd.Parameters.Add("@ItclOrderID", System.Data.SqlDbType.VarChar).Value = _ItclOrderID;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = _RefID;
                cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = _PAN;
                cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = _TransactionType;
                if (SenderAcc > 0)
                    cmd.Parameters.Add("@SenderAcc", System.Data.SqlDbType.BigInt).Value = SenderAcc;


                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = false;
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                //using (SqlDataReader dr = cmd.ExecuteReader())
                //{
                //    var tb = new DataTable();
                //    tb.Load(dr);
                //    //return tb;
                //}

                int i=cmd.ExecuteNonQuery();

                RetVal = (bool)sqlDone.Value;
            }
        }

        return RetVal;
    }
    private bool TBMMpaymentInfoCheck(string TrnID, string AccNo, double _Amount)
    {
        //return true;

        bool RetVal = false;
        double TBMM_Amount = 0;
        string TBMM_Amount_S = "";

        try
        {
            MBPayCheckService.CheckMerchantTransaction service
           = new MBPayCheckService.CheckMerchantTransaction();
            //CheckMerchantTransaction.CheckMerchantTransactionSoapClient service
            //    = new CheckMerchantTransaction.CheckMerchantTransactionSoapClient();
            //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");
            TBMM_Amount_S = service.GetTransactionInfo(TrnID, AccNo);

            TBMM_Amount = double.Parse(TBMM_Amount_S.Trim());
            if (TBMM_Amount >= _Amount)
                RetVal = true;

            Tbmm_PaymentVerifyLog(TrnID, AccNo, _Amount, TBMM_Amount);
        }
        catch (Exception ex)
        {
            Common.WriteLog(
                    string.Format(
                        "CheckMerchantTransactionService: TrnID: {0}, AccNo: {1}, TBMM_Amount: {2}, _Amount: {3}"
                        , TrnID
                        , AccNo
                        , TBMM_Amount_S
                        , _Amount)
                , ex.Message);
        }

        return RetVal;
    }

    private void Tbmm_PaymentVerifyLog(string TrnID, string AccNo, double _Amount, double Return_Amount)
    {

        try
        {
            using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMM_GetTransactionInfo_Log";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@TxCode", System.Data.SqlDbType.VarChar).Value = TrnID;
                    cmd.Parameters.Add("@MerchantMobile", System.Data.SqlDbType.VarChar).Value = AccNo;
                    cmd.Parameters.Add("@PaidAmount", System.Data.SqlDbType.Decimal).Value = _Amount;
                    cmd.Parameters.Add("@ReturnAmount", System.Data.SqlDbType.Decimal).Value = Return_Amount;

                    cmd.Connection = conn;

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                    //isSaved = true;

                }
            }
        }
        catch (Exception ex)
        {

            Common.WriteLog("s_Itcl_GetOrderStatus_Log", string.Format("{0}", ex.Message));
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

    private void getCheckout_Ref_Details()
    {
        using (SqlDataAdapter da = new SqlDataAdapter())
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Ref_Details";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed)
                        conn.Open();

                    da.SelectCommand = cmd;
                    da.Fill(CheckoutPaymentDT);
                }
            }
        }
    }

}