using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

/// <summary>
/// Summary description for Payment_Verify
/// </summary>
public class Payment_Verify
{
    public Payment_Verify()
    {
        //
        // TODO: Add constructor logic here
        //
    }

    //public bool TBMMpaymentInfoCheck(string TrnID, string Merchant_AccNo, double _Amount, string RefID)
    //{
    //    //return true;
    //    bool RetVal = false;
    //    double TBMM_Amount = 0;
    //    string TBMM_Amount_S = "0";

    //    try
    //    {
    //        CheckMerchantTransaction.CheckMerchantTransactionSoapClient service
    //            = new CheckMerchantTransaction.CheckMerchantTransactionSoapClient();
    //        //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");
    //        TBMM_Amount_S = service.GetTransactionInfo(TrnID, Merchant_AccNo);

    //        TBMM_Amount = double.Parse(TBMM_Amount_S.Trim() == "" ? "0" : TBMM_Amount_S.Trim());
    //        if (TBMM_Amount >= _Amount && _Amount > 0)
    //            RetVal = true;

    //        Tbmm_PaymentVerifyLog(TrnID, Merchant_AccNo, _Amount, TBMM_Amount, RefID);
    //    }
    //    catch (Exception ex)
    //    {
    //        Common.WriteLog(
    //                string.Format(
    //                    "CheckMerchantTransactionService: TrnID: {0}, AccNo: {1}, TBMM_Amount: {2}, _Amount: {3}"
    //                    , TrnID
    //                    , Merchant_AccNo
    //                    , TBMM_Amount_S
    //                    , _Amount)
    //            , ex.Message);
    //    }

    //    return RetVal;
    //}
    private void Tbmm_PaymentVerifyLog(string TrnID, string AccNo, double _Amount, double Return_Amount,string RefID)
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

    public DataTable GetCheckout_Ref_Details(string RefID)
    {
        DataTable CheckoutPaymentDT = new DataTable();
        try
        {
         
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "[s_Checkout_Ref_Details]";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(CheckoutPaymentDT);
                    }
                }
            }
        }
        catch(Exception)
        {
            return CheckoutPaymentDT;
        }
        return CheckoutPaymentDT;
    }

    public DataTable GetCheckout_DetailsBy_TransID(string TransID)
    {
        DataTable CheckoutPaymentsDT = new DataTable();
        try
        {

            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Checkout_Details_By_TransID";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@TransID", System.Data.SqlDbType.VarChar).Value = TransID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(CheckoutPaymentsDT);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return CheckoutPaymentsDT;
        }
        return CheckoutPaymentsDT;
    }

}