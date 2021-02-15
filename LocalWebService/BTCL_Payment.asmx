<%@ WebService Language="C#" Class="BTCL_Payment" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Web.Script.Serialization;


/// <summary>
/// Summary description for NID_GetDueAmount
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class BTCL_Payment : System.Web.Services.WebService
{
    int LoginAttem = 0;


    [WebMethod(Description = "Service Task: Get amount from BTCL Server"
        + "<br>" + "Exchange Code: of specific ph no"
              + "<br>" + "Phone Number: of specific bill req"
              + "<br>" + "Last PayDate: [Sample: 20140430]"
              //+ "<br>" + "PayStatus: (Optional)"
              + "<br>" + "Key Code:"
        + "<br>" + "Returns:"
         //+ "<br>" + "RefID" + "|" + "Amount" + "|" + "Response Code"
         + "<br>" + "Json object"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "1: " + "For Success otherwise error"
      )]
    public string GetBtclDueAmount(
        string Exchange_Code,
        string Phone_Number,
        string Last_PayDate,
        //string PayStatus,
        string KeyCode)
    {

        int BtclResponseCode =-1; //error
        String Response_code = "401";
        String Message = "Fail";
        string RefID = "";
        int RefID_Merchant = 0;
        string token_number = GetTokenNumber();
        double TotalBillAmount = 0;
        if (KeyCode != getValueOfKey("SLMS_KeyCode"))
            return "-2";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_get_New_RefID_Merchant";  //Auto ID
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BTCL";
                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 18);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    SqlParameter sqlRefID_Merchant = new SqlParameter("@RefID_Merchant", SqlDbType.VarChar, 18);
                    sqlRefID_Merchant.Direction = ParameterDirection.InputOutput;
                    sqlRefID_Merchant.Value = "";
                    cmd.Parameters.Add(sqlRefID_Merchant);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    RefID = string.Format("{0}", sqlRefID.Value);
                    RefID_Merchant = int.Parse(sqlRefID_Merchant.Value.ToString());
                }
            }

            SLMSServices.SLMSService slms_obj = new SLMSServices.SLMSService();
            SLMSServices.BillRequest bill_ledger = slms_obj.GetBillLedger(RefID_Merchant, true, getValueOfKey("btcl_userid"), token_number, Exchange_Code, Phone_Number, Last_PayDate, "U");
            //    SLMSServices.BillRequest bill_ledger = slms_obj.GetBillLedger(RefID_Merchant, true, getValueOfKey("btcl_userid"), token_number, Exchange_Code, Phone_Number, Last_PayDate, ""); // test
            BtclResponseCode = bill_ledger.ResponseCode;
            if (bill_ledger.ResponseCode == 0)
            {
                TotalBillAmount = Save_BillLedgersAndGetTotalAmount(bill_ledger,RefID, RefID_Merchant);
                Response_code = "1";
                Message = "Success";
            }
            else
            {
                Response_code = bill_ledger.ResponseCode.ToString();
                Message = bill_ledger.Message==null?GetMessage(bill_ledger.ResponseCode.ToString()): bill_ledger.Message.ToString();
            }
        }
        catch (Exception ex)
        {
            Common.WriteLog("BTCL Due Amount",
                string.Format("Error: 205:,ref_id: {0},Error: {1}",
                RefID_Merchant,
                ex.Message));
            return string.Format("{0}|{1}|{2}|{3}", RefID, TotalBillAmount,Response_code,Message);

        }
        SaveCheckoutParamLog(RefID,"BTCL","GetBtclDueAmount","","Exchange_Code:"+Exchange_Code+"|Phone:"+Phone_Number+"|LastPayDT:"+Last_PayDate+"|ResponseCode:"+BtclResponseCode+"");
        return string.Format("{0}|{1}|{2}|{3}", RefID, TotalBillAmount,Response_code,Message);
    }

    private string GetMessage(string responsecode)
    {
        string retMsg = "";
        switch(responsecode) {
            case "3":
                retMsg = "Invalid Request";
                break;
            case "5":
                retMsg = "Internal Server Error";
                break;
            case "7":
                retMsg = "Token Expaired/Invalid User";
                break;
            case "9":
                retMsg = "Invalid Data/Data not found";
                break;
            case "13":
                retMsg = "System is Busy";
                break;
            case "15":
                retMsg = "Already Paid";
                break;
            default:
                retMsg="Fail";
                break;
        }
        return retMsg;
    }

    private double Save_BillLedgersAndGetTotalAmount(SLMSServices.BillRequest bill_ledger, string RefID,int RefID_Merchant)
    {
        double TotalBillAmount = 0;
        double BTCLAmount = 0;
        double VatAmount = 0;
        int db_save_count = 0;
        int child_item = 0;

        try
        {

            SLMSServices.BillLedger[] BL_List = bill_ledger.BillDetails;

            foreach (SLMSServices.BillLedger BL in BL_List)
            {
                //    //Save Child Item

                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_BTCL_Bill_Ledger_Insert";  //Bill ledger insert

                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                        cmd.Parameters.Add("@RefID_Merchant", System.Data.SqlDbType.Int).Value = RefID_Merchant;
                        cmd.Parameters.Add("@RowNumber", System.Data.SqlDbType.VarChar).Value = BL.RowNumber;
                        cmd.Parameters.Add("@BillID", System.Data.SqlDbType.VarChar).Value = BL.BillNo;
                        cmd.Parameters.Add("@ExchangeCode", System.Data.SqlDbType.VarChar).Value = BL.ExchangeCode;
                        cmd.Parameters.Add("@PhoneNumber", System.Data.SqlDbType.VarChar).Value = BL.PhoneNumber;
                        cmd.Parameters.Add("@LastPayDate", System.Data.SqlDbType.DateTime).Value = BL.LastPayDate;
                        cmd.Parameters.Add("@BillMonth", System.Data.SqlDbType.VarChar).Value = BL.BillMonth;
                        cmd.Parameters.Add("@BillYear", System.Data.SqlDbType.VarChar).Value = BL.BillYear;
                        cmd.Parameters.Add("@BTCLAmount", System.Data.SqlDbType.Decimal).Value = BL.BTCL_Amount;
                        cmd.Parameters.Add("@VatAmount", System.Data.SqlDbType.Decimal).Value = BL.VAT;
                        cmd.Parameters.Add("@BillPayStatus", System.Data.SqlDbType.VarChar).Value = BL.BillPayStatus;
                        cmd.Parameters.Add("@BillStatus", System.Data.SqlDbType.VarChar).Value = BL.BillStatus;

                        SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                        sqlDone.Direction = ParameterDirection.InputOutput;
                        sqlDone.Value = "";
                        cmd.Parameters.Add(sqlDone);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                        // RetVal = string.Format("{0}", sqlDone.Value);
                    }
                }

                BTCLAmount += (double)BL.BTCL_Amount;
                VatAmount += (double)BL.VAT;
                child_item++;
                db_save_count++;
            } // end for 
            TotalBillAmount = BTCLAmount + VatAmount;
        }
        catch(Exception ex)
        {
            BTCLAmount = 0;
            VatAmount = 0;
            TotalBillAmount = 0;
            Common.WriteLog("s_BTCL_Bill_Ledger_Insert",
                         string.Format("Error: 205:,ref_id: {0},Error: {1}",
                         RefID,
                         ex.Message));

        }

        bool SaveStatus = false;
        //Save Total Amount in PaymentCheckout
        if(TotalBillAmount>0 && child_item==db_save_count)
        {
            SaveStatus=  SaveCheckoutPayment(RefID,BTCLAmount,VatAmount,RefID_Merchant);
        }
        if (!SaveStatus)
            TotalBillAmount = 0;

        return TotalBillAmount;

    }

    private bool SaveCheckoutPayment(string RefID,double BTCLAmount,double VatAmount,int RefID_Merchant )
    {
        bool SaveStatus = false;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_BTCL_Payments_Insert";  //Due bill info save 
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = BTCLAmount+VatAmount;
                    cmd.Parameters.Add("@VatAmount", System.Data.SqlDbType.Decimal).Value = VatAmount;
                    cmd.Parameters.Add("@Fees", System.Data.SqlDbType.Decimal).Value = BTCLAmount;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BTCL";
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "MB_OFF";
                    cmd.Parameters.Add("@RefID_Merchant", System.Data.SqlDbType.Int).Value = RefID_Merchant;
                    // cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = token_number;

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = false;
                    cmd.Parameters.Add(sqlDone);



                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    SaveStatus = true;

                }
            }


        }
        catch (Exception ex)
        {
            SaveStatus = false;
            Common.WriteLog("s_BTCL_Payments_Insert",
                         string.Format("Error: 205:,ref_id: {0},Error: {1}",
                         RefID,
                         ex.Message));
        }
        return SaveStatus;
    }

    private string GetTokenNumber()
    {
        string token_number = "";
        try
        {
            SLMSServices.SLMSService slms_obj = new SLMSServices.SLMSService();
            SLMSServices.TokenRequest tokennumber = slms_obj.GetTokenByUser(getValueOfKey("btcl_userid"), getValueOfKey("btcl_password"));
            token_number = tokennumber.TokenNumber;

        }
        catch (Exception ex)
        {
            Common.WriteLog("BTCL Token Number",
                     string.Format("Error: 205:,Error: {0}",
                     ex.Message));
        }
        return token_number;
    }

    private void SaveCheckoutParamLog(string RefID,string MerchantID,string MethodName,string IPAddress,string Paramvalue )
    {

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_CheckoutServiceParam_Log";  //save parameter log 
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;
                    cmd.Parameters.Add("@MethodName", System.Data.SqlDbType.VarChar).Value = MethodName;
                    cmd.Parameters.Add("@IPAddress", System.Data.SqlDbType.VarChar).Value = IPAddress;
                    cmd.Parameters.Add("@ParamValue", System.Data.SqlDbType.VarChar).Value = Paramvalue;

                    //SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    //sqlDone.Direction = ParameterDirection.InputOutput;
                    //sqlDone.Value = false;
                    //cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                }
            }


        }
        catch (Exception ex)
        {

            Common.WriteLog("s_CheckoutServiceParam_Log",
                         string.Format("Error: 205:,ref_id: {0},Error: {1}",
                         RefID,
                         ex.Message));
        }

    }

    [WebMethod(Description = "Service Task: Mark Transaction as Paid"
        + "<br>" + "Returns:"
         + "<br>" + "Json Object"
        + "<br>" + "1: " + "Success"
        + "<br>" + "-1: " + "Failed to Update"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "-3: " + "TrnID Already Exists"
        + "<br>" + "-4: " + "Payment is not found"
        + "<br>" + "-11: " + "Merchant Branch Code not Found"

      )]
    public string ConfirmBtclPayment_MB_OFF(
        string RefID,
        string KeyCode,
        string TrnID,
        string Mobile,
        string MerchantBranchCode)
    {
        DateTime CallDateTime = DateTime.Now;
        string RetVal = "";
        string RetMessage = "Fail";
        string PayStatus = "";
        string merchant_acc = "";
        double Amount = 0;

        Boolean check_pay = false;
        Payment_Verify pv = new Payment_Verify();
        try {
            if (KeyCode != getValueOfKey("SLMS_KeyCode"))
                return "-2";
            string BranchCode_Btcl=  CheckMerchantBrCode(MerchantBranchCode);
            if(BranchCode_Btcl=="")
                return "-11";

            DataTable Checkout_DT = pv.GetCheckout_Ref_Details(RefID);
            if (Checkout_DT.Rows.Count > 0)
            {
                merchant_acc = Checkout_DT.Rows[0]["AccountNo"].ToString();
                Amount =Double.Parse( Checkout_DT.Rows[0]["TotalAmount"].ToString());
            }
            check_pay = pv.TBMMpaymentInfoCheck(TrnID, merchant_acc, Amount, RefID);
            //L  check_pay = true; // have to remove before live environment
            if (check_pay)
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
                        cmd.Parameters.Add("@MobileNo", System.Data.SqlDbType.VarChar).Value = Mobile;
                        cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = MerchantBranchCode; // tbl branch code
                        cmd.Parameters.Add("@MerchantBrCode", System.Data.SqlDbType.VarChar).Value =BranchCode_Btcl ;
                        //cmd.Parameters.Add("@Verified", System.Data.SqlDbType.Bit).Value = PaymentStatus;

                        SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                        sqlDone.Direction = ParameterDirection.InputOutput;
                        sqlDone.Value = "";
                        cmd.Parameters.Add(sqlDone);

                        cmd.Connection = conn;
                        conn.Open();

                        cmd.ExecuteNonQuery();

                        PayStatus = string.Format("{0}", sqlDone.Value);
                    }
                }
                if (PayStatus == "1")
                {

                    if (UpdatePaymentToBtclServer(RefID))
                    {
                        RetVal = "1"; //Success
                        RetMessage = "Success";
                    }
                    else
                    {
                        RetVal = "403"; // Update failed to Btcl Server
                        RetMessage = "Fail to Update Btcl Server";
                    }
                }
                else
                {
                    RetVal = "-5";
                    RetMessage = "Payment Status Fail";
                }
            }
            else
            {
                RetVal = "-4";
                RetMessage = "Payment Verification Fail";
            }
        }
        catch(Exception ex)
        {

            Common.WriteLog("s_Checkout_Payment_Req_to_Paid BTCL",
                        string.Format("Error: 205:,ref_id: {0},Error: {1}",
                        RefID,
                        ex.Message));
            RetVal = "404"; //Unable to update data
            RetMessage = "Fail";
        }
        finally
        {
            Common.SaveReqResponseData(RefID, "ConfirmBtclPayment_MB_OFF", CallDateTime, "KeyCode:"+KeyCode+",TrnID:"+Mobile+",MerchantBranchCode:"+MerchantBranchCode, "RetVal:"+RetVal+",RetMessage:"+RetMessage, RetVal, RetMessage);
        }
        //Context.Response.Clear();
        //Context.Response.ContentType = "text/plain";
        return("[{ \"RefID\":\""+RefID+"\", \"Responsecode\":\""+RetVal+"\", \"Message\":\""+RetMessage+"\" }]");
        //Context.Response.End();
        //return "";

        //  return string.Format("{0}|{1}|{2}",RefID, RetVal, RetMessage);
    }

    private string CheckMerchantBrCode(string merchantBrCode)
    {
        string Btcl_BrCode = "";
        try
        {
            DataTable BtclPaymentDT = new DataTable();

            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "[s_Get_Btcl_BranchCode]";
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@MerchantBrCode", System.Data.SqlDbType.VarChar).Value = merchantBrCode;
                        cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BTCL";

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(BtclPaymentDT);
                    }
                }
            }

            if (BtclPaymentDT.Rows.Count > 0)
                Btcl_BrCode = BtclPaymentDT.Rows[0]["MerchantBranchCode"].ToString();

        }
        catch(Exception ex)
        {
            Btcl_BrCode = "";
        }

        return Btcl_BrCode.Trim();

    }

    private Boolean UpdatePaymentToBtclServer(string RefID)
    {

        // string BillStatus = "R";
        Boolean MasterUsed = false;
        DataTable BtclPaymentDT = new DataTable();
        try
        {
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "[s_Btcl_Ledger_Ref_Wise]";
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(BtclPaymentDT);
                    }
                }
            }
            //Common.WriteLog("MMM", RefID +" "+BtclPaymentDT.Rows.Count);
            int btcl_response_count = 0;
            for (int i = 0; i < BtclPaymentDT.Rows.Count; i++)
            {
                string ID = BtclPaymentDT.Rows[i]["ID"].ToString();
                int RefID_Merchant = int.Parse(BtclPaymentDT.Rows[i]["RefID_Merchant"].ToString());
                string UserId = getValueOfKey("btcl_userid");
                string token_number = GetTokenNumber();
                string ExchangeCode = BtclPaymentDT.Rows[i]["ExchangeCode"].ToString();
                string PhoneNumber = BtclPaymentDT.Rows[i]["PhoneNumber"].ToString();
                //  string LastPayDate=String.Format("{0:YYYYMMDD/dd/yyyy HH:mm:ss tt}", BtclPaymentDT.Rows[i]["LastPayDate"]);
                string LastPayDate = String.Format("{0:yyyyMMdd}", BtclPaymentDT.Rows[i]["LastPayDate"]);
                //string LastPayDate =String.Format("{0:yyyyMMdd}", a);
                decimal PaidAmount = Decimal.Parse(BtclPaymentDT.Rows[i]["PaidAmount"].ToString());
                string BillStatus = BtclPaymentDT.Rows[i]["BillStatus"].ToString();
                string branchCode = BtclPaymentDT.Rows[i]["Meta2"].ToString().Trim();

                SLMSServices.SLMSService payment = new SLMSServices.SLMSService();
                SLMSServices.BillPaymentResponse payment_response = payment.BillPaymentRequest(RefID_Merchant, true, UserId, token_number, branchCode, ExchangeCode, PhoneNumber, LastPayDate, PaidAmount, true, BillStatus);
                if (payment_response.ResponseCode == 0)
                {
                    btcl_response_count++;
                    if (BtclPaymentDT.Rows.Count == btcl_response_count)
                    {
                        MasterUsed = true;
                    }
                    UpdateBtclLedgerResponseWise(ID, RefID, payment_response, true, MasterUsed, PaidAmount);
                }
                else
                {
                    UpdateBtclLedgerResponseWise(ID, RefID, payment_response, false, MasterUsed, PaidAmount);
                }
            }


        }
        catch(Exception ex)
        {
            MasterUsed = false;
            Common.WriteLog("UpdatePaymentToBtclServer",
               string.Format("Error: 205:,Error: {0}",
               ex.Message));

        }
        return MasterUsed;
    }
    private void UpdateBtclLedgerResponseWise(string ID,string RefID,SLMSServices.BillPaymentResponse response,bool ServiceStatus,bool MasterUsed,Decimal Amount )
    {
        Common.WriteLog("s_Btcl_Ledger_Update", RefID);
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Btcl_Ledger_Update";  //Mark as Paid to BTCL Ledger 

                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@ID", System.Data.SqlDbType.VarChar).Value = ID;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BTCL";
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = response.ResponseCode + "|" + response.Message;
                    cmd.Parameters.Add("@ServiceStatus", System.Data.SqlDbType.Bit).Value = ServiceStatus;
                    cmd.Parameters.Add("@MasterUsed", System.Data.SqlDbType.Bit).Value = MasterUsed;

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = "";
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    // RetVal = string.Format("{0}", sqlDone.Value);
                }
            }
        }
        catch(Exception ex)
        {
            Common.WriteLog("s_Btcl_Ledger_Update", RefID + " " + ex.Message);
        }
    }


    [WebMethod(Description = "Service Task: Btcl Payment Cancel"
       + "<br>" + "Returns:"
       + "<br>" + "1: " + "Success"
       + "<br>" + "-1: " + "Failed to Update"
       + "<br>" + "-2: " + "Invalid KeyCode"
       + "<br>" + "-3: " + "TrnID Already Exists"
       + "<br>" + "-4: " + "Payment is not found"
       + "<br>" + "-11: " + "Merchant Branch Code not Found"

     )]
    public string BtclPaymentCancel(
       string RefID,
       string KeyCode,
       string CancelBy,
       string Cancelreason
      )
    {
        string RetVal = "";
        DateTime CallDateTime = DateTime.Now;
        if (KeyCode != getValueOfKey("SLMS_KeyCode_Cancel"))
            return "-2";

        try {

            if( CancelePaymentToBtclServer(RefID, CancelBy, Cancelreason))
                RetVal = "1"; //Success
            else
                RetVal = "405"; // Cancel failed to Btcl Server
        }
        catch(Exception ex)
        {
            Common.WriteLog("BtclPaymentCancel",
                string.Format("Error: 205:,Error: {0}",
                ex.Message));
            RetVal = "404"; //Unable to update data
        }
        finally
        {
            Common.SaveReqResponseData(RefID, "ConfirmBtclPayment_MB_OFF", CallDateTime, "KeyCode:"+KeyCode+",Cancelreason:"+Cancelreason, "RetVal:"+RetVal, RetVal, "");
        }

        return RetVal;
    }

    private Boolean CancelePaymentToBtclServer(string RefID,string CancelBy,string CancelReason)
    {

        // string BillStatus = "R";
        Boolean MasterUsed = false;
        DataTable BtclPaymentDT = new DataTable();
        try
        {
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "[s_Btcl_LedgerCancel_Ref_Wise]";
                    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                        cmd.Connection = conn;
                        conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(BtclPaymentDT);
                    }
                }
            }

            int btcl_response_count = 0;
            for(int i=0; i<BtclPaymentDT.Rows.Count;i++)
            {
                string ID =BtclPaymentDT.Rows[i]["ID"].ToString();
                int RefID_Merchant = int.Parse(BtclPaymentDT.Rows[i]["RefID_Merchant"].ToString());
                string UserId = getValueOfKey("btcl_userid");
                string token_number = GetTokenNumber();
                string ExchangeCode= BtclPaymentDT.Rows[i]["ExchangeCode"].ToString();
                string PhoneNumber= BtclPaymentDT.Rows[i]["PhoneNumber"].ToString();
                //  string LastPayDate=String.Format("{0:YYYYMMDD/dd/yyyy HH:mm:ss tt}", BtclPaymentDT.Rows[i]["LastPayDate"]);
                string LastPayDate =String.Format("{0:yyyyMMdd}", BtclPaymentDT.Rows[i]["LastPayDate"]);
                //string LastPayDate =String.Format("{0:yyyyMMdd}", a);
                decimal PaidAmount=Decimal.Parse( BtclPaymentDT.Rows[i]["PaidAmount"].ToString());
                string BillStatus=BtclPaymentDT.Rows[i]["BillStatus"].ToString();
                string branchCode = BtclPaymentDT.Rows[i]["Meta2"].ToString().Trim();

                SLMSServices.SLMSService paymentCancel = new SLMSServices.SLMSService();
                SLMSServices.PaymentCancelResponse payment_response=
                                paymentCancel.PaymentCancelRequest(RefID_Merchant,true,UserId,token_number,branchCode,ExchangeCode,PhoneNumber,LastPayDate,BillStatus);
                if (payment_response.ResponseCode == 0)
                {
                    btcl_response_count++;
                    if (BtclPaymentDT.Rows.Count == btcl_response_count)
                    {
                        MasterUsed = true;
                    }

                    CancelBtclLedgerResponseWise(ID, RefID, payment_response, true, MasterUsed, PaidAmount,CancelBy,CancelReason);
                }
                else
                {
                    CancelBtclLedgerResponseWise(ID, RefID, payment_response, false, MasterUsed, PaidAmount,CancelBy,CancelReason);
                }
            }



        }
        catch(Exception ex)
        {
            MasterUsed = false;
            Common.WriteLog("CancelPaymentToBtclServer",
               string.Format("Error: 205:,Error: {0}",
               ex.Message));

        }
        return MasterUsed;
    }

    private void CancelBtclLedgerResponseWise(string ID,string RefID,SLMSServices.BillPaymentResponse response,bool ServiceStatus,bool MasterUsed,Decimal Amount,string CancelBy,string CancelReason )
    {
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Btcl_Ledger_Cancel";  //Cancel to BTCL Ledger 

            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@ID", System.Data.SqlDbType.VarChar).Value = ID;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BTCL";
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = response.ResponseCode+"|"+response.Message;
                cmd.Parameters.Add("@ServiceStatus", System.Data.SqlDbType.Bit).Value = ServiceStatus;
                cmd.Parameters.Add("@MasterUsed", System.Data.SqlDbType.Bit).Value = MasterUsed;
                cmd.Parameters.Add("@CancelBy", System.Data.SqlDbType.VarChar).Value = CancelBy;
                cmd.Parameters.Add("@CancelReason", System.Data.SqlDbType.VarChar).Value = CancelReason;

                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                // RetVal = string.Format("{0}", sqlDone.Value);
            }
        }
    }

    [WebMethod(Description = "Service Task: Btcl Payment Collection History"
+ "<br>" + "Returns:"
+ "<br>" + "1: " + "Success"
+ "<br>" + "-2: " + "Invalid KeyCode"
+ "<br>" + "-11: " + "Merchant Branch Code not Found"

)]
    public string BtclPaymentHistory(
string KeyCode,
DateTime FromDate,
DateTime ToDate,
string BranchCode,
string UserID
)
    {
        string RetVal = "";

        if (KeyCode != getValueOfKey("SLMS_KeyCode_Cancel"))
            return "-2";

        try {
            string ranDT=  String.Format("{0:yyMMdd}", DateTime.Now);
            Random rnd = new Random();
            int card = rnd.Next(999);
            int txn_number = int.Parse((ranDT + card.ToString()));
            DataTable BranchList=   BtclBranchCodeDateWise(FromDate,ToDate,BranchCode);
            string token_number = GetTokenNumber();
            SLMSServices.SLMSService slms_obj = new SLMSServices.SLMSService();
            for (int i = 0; i < BranchList.Rows.Count; i++)
            {
                SLMSServices.BillPaidHistory pay_history = slms_obj.GetPaymentCollectionHistory(txn_number, true, getValueOfKey("btcl_userid"), token_number, String.Format("{0:yyyyMMdd}", FromDate), String.Format("{0:yyyyMMdd}", ToDate), BranchList.Rows[i]["Meta2"].ToString());

                if (pay_history.BillDetails != null)
                {
                    SaveBulkData(pay_history, UserID, (FromDate), (ToDate));

                    //RetVal = txn_number.ToString();
                }
                //else
                //    RetVal = "-1";
            }
        }
        catch(Exception ex)
        {
            Common.WriteLog("BtclPaymentHistory",
                string.Format("Error: 205:,Error: {0}",
                ex.Message));
            RetVal = "-3";
        }

        return RetVal;
    }


    private void SaveBulkData( SLMSServices.BillPaidHistory payHistoryDtl ,string userid,DateTime FromDT,DateTime ToDT)
    {
        // int curdate = int.Parse(DateTime.Now);
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("TxnNumber", typeof(int));
        dt_mtr.Columns.Add("RowNumber", typeof(string));
        dt_mtr.Columns.Add("BillID", typeof(string));
        dt_mtr.Columns.Add("ExchangeCode", typeof(string));
        dt_mtr.Columns.Add("PhoneNumber", typeof(string));
        dt_mtr.Columns.Add("LastPayDate", typeof(DateTime));
        dt_mtr.Columns.Add("BillMonth", typeof(string));
        dt_mtr.Columns.Add("BillYear", typeof(string));
        dt_mtr.Columns.Add("BTCLAmount", typeof(decimal));
        dt_mtr.Columns.Add("VatAmount", typeof(decimal));
        dt_mtr.Columns.Add("BillPayStatus", typeof(string));
        dt_mtr.Columns.Add("BillStatus", typeof(string));
        dt_mtr.Columns.Add("BankName", typeof(string));
        dt_mtr.Columns.Add("InsertBy", typeof(string));
        dt_mtr.Columns.Add("InsertDT", typeof(string));
        dt_mtr.Columns.Add("FromDate", typeof(DateTime));
        dt_mtr.Columns.Add("ToDate", typeof(DateTime));

        SLMSServices.BillLedgerHistory[] historyList= payHistoryDtl.BillDetails;
        foreach (SLMSServices.BillLedgerHistory ledgerHistory in historyList)
        {
            dt_mtr.Rows.Add(ledgerHistory.TXNNumber,ledgerHistory.RowNumber,ledgerHistory.BillNo,ledgerHistory.ExchangeCode,ledgerHistory.PhoneNumber,
                ledgerHistory.LastPayDate,ledgerHistory.BillMonth,ledgerHistory.BillYear,ledgerHistory.BTCL_Amount,ledgerHistory.VAT,
                ledgerHistory.BillPayStatus,ledgerHistory.BillStatus,ledgerHistory.Name,userid,DateTime.Now,FromDT,ToDT);
        }

        if (dt_mtr.Rows.Count > 0)
        {
            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            // open the destination data
            using (SqlConnection destinationConnection = new SqlConnection(connString))
            {
                // open the connection
                destinationConnection.Open();
                using (SqlBulkCopy bulkCopy =
                     new SqlBulkCopy(destinationConnection.ConnectionString,
                            SqlBulkCopyOptions.TableLock))
                {
                    bulkCopy.BulkCopyTimeout = 0;
                    bulkCopy.DestinationTableName = "BTCL_Ledger_PayHistory";
                    bulkCopy.WriteToServer(dt_mtr);
                }

            }

        }
        //else
        //    TrustControl1.ClientMsg("Data Not Found");

    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    private DataTable BtclBranchCodeDateWise(DateTime FromDate,DateTime ToDate,string BranchCode)
    {
        DataTable BtclPaymentDT = new DataTable();
        using (SqlDataAdapter da = new SqlDataAdapter())
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "[s_BtclBranchCodeDateWise]";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@FromDate", System.Data.SqlDbType.VarChar).Value = FromDate;
                    cmd.Parameters.Add("@ToDate", System.Data.SqlDbType.VarChar).Value = ToDate;
                    cmd.Parameters.Add("@BtclBranchCode", System.Data.SqlDbType.VarChar).Value = BranchCode;


                    cmd.Connection = conn;
                    conn.Open();

                    da.SelectCommand = cmd;
                    da.Fill(BtclPaymentDT);
                }
            }
        }
        return BtclPaymentDT;

    }

}