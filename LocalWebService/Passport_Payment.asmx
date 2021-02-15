<%@ WebService Language="C#" Class="Passport_Payment_Service" %>

using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System;
using System.Web;

/// <summary>
/// Summary description for Passport_Payment
/// </summary>
[WebService(Namespace = "http://mobile.trustbanklimited.com/checkout/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class Passport_Payment_Service : System.Web.Services.WebService
{

    //public Passport_Payment_Service()
    //{

    //    //Uncomment the following line if using designed components 
    //    //InitializeComponent(); 
    //}
    //[WebMethod(EnableSession = true)]
    [WebMethod(Description = "Service Task: Save Transation and return 14 Digit PassportRefID"
        + "<br>" + "Other Returns:"
        + "<br>" + "-1 = TransationID Already Used"
        + "<br>" + "-2 = Invalid Keycode"
        + "<br>" + "-4 = SenderMobile Missing"
        + "<br>" + "-5 = Unable to Retrive from DB"
      )]
    //[System.Web.Services.Protocols.SoapDocumentMethod(OneWay = false)]
    public string getPassportRefID(
            decimal Amount,
            string FullName,
            string TransactionID,
            string NotifyMobile,
            string SenderMobile,
            string SenderAccType,
            string EmailAddress,
            string Keycode
        )
    {
        string RefID = "";
        string PageUrl = Context.Request.Url.OriginalString.Split('?')[0];
        string PaymentType = "MB_OFF";
        long? _NotifyMobile = null;
        long? _SenderMobile;
        string Referrer = "";
        bool isVisible = false;

        if (Keycode.Trim().Length < 10) return "-1";

        if (Keycode != getValueOfKey("Passport_KeyCode"))
            return "-2";

        try
        {
            Common.WriteLog(Context.Request.Url.OriginalString, string.Format("HTTP_ORIGIN: {0}", HttpContext.Current.Request.ServerVariables["HTTP_ORIGIN"]));
        }
        catch (Exception)
        {
        }

        try
        {
            _NotifyMobile = long.Parse(NotifyMobile);
        }
        catch (Exception)
        {
            //return "-3";
        }

        try
        {
            _SenderMobile = long.Parse(SenderMobile);
        }
        catch (Exception)
        {
            return "-4";    //SenderMobile Missing
        }


        SqlConnection.ClearAllPools();

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

        //        using (SqlDataReader sdr = cmd.ExecuteReader())
        //        {

        //            {


        //                if (!sdr.HasRows)
        //                {
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_PageURL=" + PageUrl);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_Keycode=" + Keycode);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_PaymentType=" + PaymentType);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_Referrer=" + Referrer);

        //                    return "-2";
        //                }
        //            }
        //        }
        //    }
        //}

        //if (!isVisible) return "-2";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Payments_Passport_Insert";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    //EmailAddress = Common.purifyEmailAddress(EmailAddress);

                    if (Common.isEmailAddress(EmailAddress) == false) EmailAddress = "";

                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = FullName;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = EmailAddress;
                    cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = TransactionID;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                    cmd.Parameters.Add("@Status", System.Data.SqlDbType.SmallInt).Value = 0;
                    cmd.Parameters.Add("@NotifyMobile", System.Data.SqlDbType.BigInt).Value = _NotifyMobile;
                    cmd.Parameters.Add("@SenderMobile", System.Data.SqlDbType.BigInt).Value = _SenderMobile;
                    cmd.Parameters.Add("@SenderAccType", System.Data.SqlDbType.VarChar).Value = SenderAccType;

                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 14);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = " ";
                    cmd.Parameters.Add(sqlRefID);

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = false;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    if ((bool)sqlDone.Value == true)
                    {
                        RefID = sqlRefID.Value.ToString().Trim();
                        //Common.WriteLog(Context.Request.Url.OriginalString, "Done_PageURL=" + PageUrl);
                        //Common.WriteLog(Context.Request.Url.OriginalString, "Done_Keycode=" + Keycode);
                        //Common.WriteLog(Context.Request.Url.OriginalString, "Done_PaymentType=" + PaymentType);
                        //Common.WriteLog(Context.Request.Url.OriginalString, "Done_Referrer=" + Referrer);
                    }
                    else
                    {
                        RefID = "-5";
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Common.WriteLog(
    string.Format(
        "s_Payments_Passport_Insert: TransactionID: {0}"

        , TransactionID

        )
, ex.Message);

        }
        //
        return RefID;
    }

    //[WebMethod(EnableSession = true)]
    [WebMethod(Description = "Service Task: Mark as UNUSED of a REQ PassportRefID"
        + "<br>" + "Other Returns:"
        + "<br>" + "1 = UNUSED mark Successfull"
        + "<br>" + "2 = Already Verified by Passport Office (Cancel Not Possible)"
        + "<br>" + "-1 = PassportRefID Not Found"
        + "<br>" + "-2 = Invalid Keycode"
        + "<br>" + "-5 = Unable to Retrive from DB"
      )]
    //[System.Web.Services.Protocols.SoapDocumentMethod(OneWay = false)]
    public string ConfirmPassportRefID(
        string PassportRefID,
        //double TotalAmount,
        //string TransactionID,
        string Keycode,
        string MobileMoneyStatus
        )
    {
        string PageUrl = Context.Request.Url.OriginalString.Split('?')[0];
        string PaymentType = "MB_OFF";
        string Referrer = "";
        bool isVisible = false;

        if (Keycode.Trim().Length < 10) return "-2";
        if (PassportRefID.Trim().Length < 14) return "2";


        try
        {
            Common.WriteLog(Context.Request.Url.OriginalString, string.Format("HTTP_ORIGIN: {0}", HttpContext.Current.Request.ServerVariables["HTTP_ORIGIN"]));
        }
        catch (Exception)
        {
        }

        //try
        //{
        //    Referrer = HttpContext.Current.Request.UserHostAddress;
        //}
        //catch (Exception) { }

        SqlConnection.ClearAllPools();

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

        //        using (SqlDataReader sdr = cmd.ExecuteReader())
        //        {

        //            {


        //                if (!sdr.HasRows)
        //                {
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_PageURL=" + PageUrl);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_Keycode=" + Keycode);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_PaymentType=" + PaymentType);
        //                    Common.WriteLog(Context.Request.Url.OriginalString, "-2_Referrer=" + Referrer);

        //                    return "-2";
        //                }
        //            }
        //        }
        //    }
        //}

        string TransactionID = "";
        double Amount = 0;
        string done = "";
        DataTable PassportDT = getPassport_Ref_Details(PassportRefID);
        if (PassportDT.Rows.Count > 0)
        {
            TransactionID = PassportDT.Rows[0]["TransactionID"].ToString();
            Amount = double.Parse(PassportDT.Rows[0]["Amount"].ToString());
        }

        if (    //TBMM Webservice check
                      TBMMpaymentInfoCheck(
                      TransactionID,
                      getValueOfKey("TBMM_DIP_ACC"),
                      Amount,
                      PassportRefID
                      ) == true
                      )
        {

            try
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Passport_Payment_REQ_to_UNUSED";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = PassportRefID;
                        cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                        cmd.Parameters.Add("@MobileMoneyStatus", System.Data.SqlDbType.VarChar).Value = MobileMoneyStatus;

                        SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                        sqlDone.Direction = ParameterDirection.InputOutput;
                        sqlDone.Value = "";
                        cmd.Parameters.Add(sqlDone);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                        done = string.Format("{0}", sqlDone.Value);
                    }
                }

            }
            catch (Exception ex)
            {
                Common.WriteLog(
         string.Format(
             "s_Passport_Payment_REQ_to_UNUSED: RefID: {0}"
             , PassportRefID

             )
     , ex.Message);
            }
        }

        else
        {
            Common.WriteLog(Context.Request.Url.OriginalString, "Error 327 False " + PageUrl);
        }
        return done;
    }



    private DataTable getPassport_Ref_Details(string RefID)
    {
        DataTable PassportPaymentDT = new DataTable();
        try
        {
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Passport_Ref_Details";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(PassportPaymentDT);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Common.WriteLog(
              string.Format(
                  "s_Passport_Ref_Details: RefID: {0}"

                  , RefID

                  )
          , ex.Message);
        }
        return PassportPaymentDT;
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    private bool TBMMpaymentInfoCheck(string TrnID, string AccNo, double _Amount, string PassportRefID)
    {
        //return true;

        bool RetVal = false;
        double TBMM_Amount = 0;
        string TBMM_Amount_S = "";

        try
        {
            Common.WriteLog("TBMMpaymentInfoCheck", PassportRefID);
            CheckMerchantTransaction.CheckMerchantTransactionSoapClient service
                = new CheckMerchantTransaction.CheckMerchantTransactionSoapClient();
            //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");
            TBMM_Amount_S = service.GetTransactionInfo(TrnID, AccNo);

            TBMM_Amount = double.Parse(TBMM_Amount_S.Trim());
            if (TBMM_Amount == _Amount && _Amount > 0)
                RetVal = true;

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
        finally
        {
            Tbmm_PaymentVerifyLog(PassportRefID, TrnID, AccNo, _Amount, TBMM_Amount);
        }

        return RetVal;
    }


    private void Tbmm_PaymentVerifyLog(string PassportRefID, string TrnID, string AccNo, double _Amount, double Return_Amount)
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
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = PassportRefID;
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

            Common.WriteLog("s_TBMM_GetTransactionInfo_Log", string.Format("{0}", ex.Message));
        }
    }

}