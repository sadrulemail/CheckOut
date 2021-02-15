<%@ WebService Language="C#" Class="NID_Payment" %>

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
public class NID_Payment : System.Web.Services.WebService
{
    int LoginAttem = 0;

    [WebMethod(Description = "Service Task: Get amount from NID Server and 14 Digit new RefID"
        + "<br>" + "Returns:"
        + "<br>" + "ServiceType: (R: REGULAR , E: URGENT)"
        + "<br>" + "Task ID: (2: Lost/damage , 3: Correction)"
        + "<br>" + "RefID"+ "|" + "Amount"
        + "<br>" + "-2: " + "Invalid KeyCode"
      )]
    public string GetDueAmountWithRefID(
        string NID,
        string TaskID,
        string ServiceType,
        string KeyCode)
    {
        decimal Amount = 0;  //will be replaced by NID service
        string RefID = "";
        string PaymentType = "MB_OFF";
        string MarchentID = "NID";
        decimal ServiceCharge = 0;
        decimal VatAmount = 0;
        decimal Fees = 0;

        //if (TaskID == "1" && ServiceType == "R")
        //{
        //    Amount = (decimal)115;
        //    Fees = (decimal)100;
        //}
        //else if (TaskID == "1" && ServiceType == "E")
        //{
        //    Amount = (decimal)172.50;
        //    Fees = (decimal)150;
        //}
        //else if (TaskID == "2" && ServiceType == "R")
        //{
        //    Amount = (decimal)230;
        //    Fees = (decimal)200;
        //}
        //else if (TaskID == "2" && ServiceType == "E")
        //{
        //    Amount = (decimal)345;
        //    Fees = (decimal)300;
        //}
        //else if (TaskID == "3")
        //{
        //    Amount = (decimal)230;
        //    Fees = (decimal)200;
        //}
        //else if (TaskID == "4")
        //{
        //    Amount = (decimal)115;
        //    Fees = (decimal)100;
        //}

        if (TaskID == "2")
            TaskID = "4";

        else if (TaskID == "3")
            TaskID = "1";
        else
            TaskID = "7";   // Default value 

        if (ServiceType.ToUpper().Trim() == "R")
            ServiceType = "REGULAR";

        else if (ServiceType.ToUpper().Trim() == "E")
            ServiceType = "URGENT";
        else
            ServiceType = "REGULAR";





        Fees = (decimal.Parse(GetNIDServiceFeeAmount(TaskID, NID, ServiceType)));
        VatAmount = Fees * (decimal)0.15;
        Amount = Fees + VatAmount;


        if (KeyCode != getValueOfKey("NID_KeyCode"))
            return "0";


        if (Fees != 0)
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Payments_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    //cmd.Parameters.Add("@FullName", System.Data.SqlDbType.VarChar).Value = NID.Trim();
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = NID.Trim();
                    cmd.Parameters.Add("@Meta2", System.Data.SqlDbType.VarChar).Value = TaskID;
                    cmd.Parameters.Add("@Meta3", System.Data.SqlDbType.VarChar).Value = ServiceType;
                    cmd.Parameters.Add("@Meta4", System.Data.SqlDbType.VarChar).Value = sessionUuid; //sessionUid
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                    //cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = null;
                    //cmd.Parameters.Add("@SID", System.Data.SqlDbType.VarChar).Value = null;
                    cmd.Parameters.Add("@ServiceCharge", SqlDbType.Decimal).Value = ServiceCharge;
                    cmd.Parameters.Add("@MarchentID", SqlDbType.VarChar).Value = MarchentID;
                    cmd.Parameters.Add("@VatAmount", System.Data.SqlDbType.Decimal).Value = VatAmount;
                    cmd.Parameters.Add("@Fees", System.Data.SqlDbType.Decimal).Value = Fees;


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
                        RefID = "-2";
                    }
                }
            }
        }

        return string.Format("{0}|{1}", RefID, Amount);
    }

    [WebMethod(Description = "Service Task: Mark Transaction as Paid"
        + "<br>" + "Returns:"
        + "<br>" + "1: " + "Success"
        + "<br>" + "-1: " + "Failed to Update"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "-3: " + "TrnID Already Exists"
      )]
    public string ConfirmPayment(
        string RefID,
        string KeyCode,
        string TrnID,
        string Mobile)
    {
        string RetVal = "-1";
        string PaymentType = "MB_OFF";
        bool PaymentStatus = false;
        string voterID = "";
        decimal fees = 0;
        string Merchant_AccNo = "";
        try {
            //  string sessionUid = "";
            if (KeyCode != getValueOfKey("NID_KeyCode"))
                return "-2";


            // Get Fees and NID, refID wise
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_get_fees_voterID";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;

                    SqlParameter sqlVoterID = new SqlParameter("@VoterID", SqlDbType.VarChar, 20);
                    sqlVoterID.Direction = ParameterDirection.InputOutput;
                    sqlVoterID.Value = " ";
                    cmd.Parameters.Add(sqlVoterID);

                    SqlParameter sqlAmount = new SqlParameter("@Amount", SqlDbType.Money);
                    sqlAmount.Direction = ParameterDirection.InputOutput;
                    sqlAmount.Value = 0;
                    cmd.Parameters.Add(sqlAmount);

                    SqlParameter sqlMerchant_AccNo = new SqlParameter("@Merchant_AccNo", SqlDbType.VarChar, 100);
                    sqlMerchant_AccNo.Direction = ParameterDirection.InputOutput;
                    sqlMerchant_AccNo.Value = "";
                    cmd.Parameters.Add(sqlMerchant_AccNo);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    voterID = sqlVoterID.Value.ToString();
                    fees = decimal.Parse(sqlAmount.Value.ToString());
                    Merchant_AccNo = sqlMerchant_AccNo.Value.ToString();
                    //  sessionUid = sqlSessionID.Value.ToString();
                }
            }

            Payment_Verify PV = new Payment_Verify();
            if (PV.TBMMpaymentInfoCheck(TrnID, Merchant_AccNo, (double)fees, RefID))
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

                if (RetVal == "1")
                {
                    // Post or Insert to NID Site
                    // Login

                    // get Transaction Status
                    WebReferenceNID.PartnerService cps = new WebReferenceNID.PartnerService();
                    LoginAttem = 0;
                    string sessionUuid = GetSessionID();
                    WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
                    rh.sessionUuid = sessionUuid;

                    WebReferenceNID.bulkBankTransactionServiceRequest bbReq = new WebReferenceNID.bulkBankTransactionServiceRequest();
                    bbReq.requestHeader = rh;
                    bbReq.bankCode = getValueOfKey("NIDBankCode");

                    WebReferenceNID.bankPaymentTransaction bpt = new WebReferenceNID.bankPaymentTransaction();
                    bpt.amount = fees;
                    bpt.amountSpecified = true;
                    bpt.paymentMode = getValueOfKey("NIDPaymentMode");
                    //Random rnd = new Random();
                    //int month = rnd.Next(1, 13);

                    bpt.txnId = RefID;
                    bpt.voterId = voterID;
                    WebReferenceNID.bankPaymentTransaction[] bptList = { new WebReferenceNID.bankPaymentTransaction() };
                    bptList[0] = bpt;
                    //  bpt.
                    // bpt=bbReq.transactionList.p
                    bbReq.transactionList = bptList;

                    WebReferenceNID.bulkBankTransactionServiceResponse bbResponse = cps.addBulkBankTransaction(bbReq);

                    if (bbResponse.operationResult.success)
                    {
                        PaymentStatus = true;
                        //  lblTransactionStatus.Text = bbResponse.serviceId.ToString();
                        SaveNIDPaymentConfirmationLog(RefID, voterID, fees, PaymentStatus, bbResponse.serviceId.ToString(), sessionUuid);
                    }
                    else
                    {
                        PaymentStatus = false;
                        // lblTransactionStatus.Text += bbResponse.operationResult.error.errorCode.ToString() + " (" + bbResponse.operationResult.error.errorMessage + ")<BR>";
                        SaveNIDPaymentConfirmationLog(RefID, voterID, fees, PaymentStatus, bbResponse.operationResult.error.errorCode.ToString() + "|" + bbResponse.operationResult.error.errorMessage.ToString(), sessionUuid);
                    }
                    //  
                }
            }
            else
            {
                RetVal = "-1";
            }
        }
        catch(Exception ex)
        {
            Common.WriteLog("Confirm_Payment",
                   string.Format("Error: 205:,ref_id: {0}, session Uid: {1},Error: {2}",
                   RefID,
                   sessionUuid,
                   ex.Message));
            return RetVal;
        }
        return RetVal;
    }

    [WebMethod(Description = "Service Task: Online Payment Confirmation "
   + "<br>" + "Returns:"
     + "<br>" + "1: " + "Success"
        + "<br>" + "-1: " + "Failed to Update"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "-3: " + "TrnID Already Exists"
        + "<br>" + "-4: " + "Payment Incomplete"
 )]
    public string Confirm_Payment_Online(
   string ref_id,
   string KeyCode

    )
    {

        if (KeyCode != getValueOfKey("NID_KeyCode"))
            return "-2";
        bool PaymentStatus = false;
        string voterID = "";
        decimal fees = 0;

        string Pay_status = "0";
        Boolean Pay_used = false;
        string RetVal = "-4";
        try
        {
            Payment_Verify pay_verify = new Payment_Verify();
            DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(ref_id);
            if (dt_verify.Rows.Count > 0)
            {
                voterID = dt_verify.Rows[0]["Meta1"].ToString();
                fees = decimal.Parse(dt_verify.Rows[0]["Amount"].ToString());
                //otc = dt_verify.Rows[0]["Meta5"].ToString();
                Pay_status = dt_verify.Rows[0]["Status"].ToString();
                Pay_used = (Boolean)dt_verify.Rows[0]["Used"];
            }


            if (Pay_status == "1")
            {

                if (!Pay_used)
                {
                    // Post or Insert to NID Site
                    // Login

                    // get Transaction Status
                    WebReferenceNID.PartnerService cps = new WebReferenceNID.PartnerService();
                    LoginAttem = 0;
                    string sessionUuid = GetSessionID();
                    WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
                    rh.sessionUuid = sessionUuid;

                    WebReferenceNID.bulkBankTransactionServiceRequest bbReq = new WebReferenceNID.bulkBankTransactionServiceRequest();
                    bbReq.requestHeader = rh;
                    bbReq.bankCode = getValueOfKey("NIDBankCode");

                    WebReferenceNID.bankPaymentTransaction bpt = new WebReferenceNID.bankPaymentTransaction();
                    bpt.amount = fees;
                    bpt.amountSpecified = true;
                    bpt.paymentMode = getValueOfKey("NIDPaymentMode");
                    //Random rnd = new Random();
                    //int month = rnd.Next(1, 13);

                    bpt.txnId = ref_id;
                    bpt.voterId = voterID;
                    WebReferenceNID.bankPaymentTransaction[] bptList = { new WebReferenceNID.bankPaymentTransaction() };
                    bptList[0] = bpt;
                    //  bpt.
                    // bpt=bbReq.transactionList.p
                    bbReq.transactionList = bptList;

                    WebReferenceNID.bulkBankTransactionServiceResponse bbResponse = cps.addBulkBankTransaction(bbReq);

                    if (bbResponse.operationResult.success)
                    {
                        PaymentStatus = true;
                        //  lblTransactionStatus.Text = bbResponse.serviceId.ToString();
                        SaveNIDPaymentConfirmationLog(ref_id, voterID, fees, PaymentStatus, bbResponse.serviceId.ToString(), sessionUuid);
                        RetVal = "1";
                    }
                    else
                    {
                        PaymentStatus = false;
                        // lblTransactionStatus.Text += bbResponse.operationResult.error.errorCode.ToString() + " (" + bbResponse.operationResult.error.errorMessage + ")<BR>";
                        SaveNIDPaymentConfirmationLog(ref_id, voterID, fees, PaymentStatus, bbResponse.operationResult.error.errorCode.ToString() + "|" + bbResponse.operationResult.error.errorMessage.ToString(), sessionUuid);
                        RetVal = "-1";
                    }
                    //  
                }

                else
                {
                    //SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, "-1", Msg, "Payment already Used by another Trxn");
                    RetVal = "-3";
                }
            }
            else
            {
                //SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, "-3", Msg, "Payment not Completed");
                RetVal = "-4";
            }
            return RetVal;
        }
        catch(Exception ex)
        {
            Common.WriteLog("Confirm_Payment_Online",
                       string.Format("Error: 205:,ref_id: {0}, session Uid: {1},Error: {2}",
                       ref_id,
                       sessionUuid,
                       ex.Message));
            return RetVal;
        }


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
    public string GetNIDServiceFeeAmount(string card_Issue_Type_Code,string nid_no,string delivery_type)
    {
        string Fees = "0";
        DateTime CallDateTime = DateTime.Now;
        string StatusCode = "";
        string StatusDesc = "";
        try
        {

            sessionUuid = GetSessionID();


            if (card_Issue_Type_Code == "1" || card_Issue_Type_Code == "4")
            {
                WebReferenceNID.getCardIssueCountServiceRequest sRequest = new WebReferenceNID.getCardIssueCountServiceRequest();
                WebReferenceNID.cardIssueCountSearchCriteria sc = new WebReferenceNID.cardIssueCountSearchCriteria();
                sc.cardIssueTypeCode = card_Issue_Type_Code;
                sc.nid = nid_no;
                sc.deliveryType = delivery_type;


                WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
                rh.sessionUuid = sessionUuid;
                //rh.clientIP = "172.22.1.26";
                //rh.clientName = "mmmm";
                //rh.interfaceVersion = "v1.1";

                sRequest.requestHeader = rh;
                sRequest.criteria = sc;

                WebReferenceNID.PartnerService cps = new WebReferenceNID.PartnerService();
                WebReferenceNID.getCardIssueCountServiceResponse
                sResponse = cps.getPartnerCardIssueCount(sRequest);

                if (sResponse.operationResult.success)
                {
                    // Label1.Text = "Fee:" + sResponse.cardIssueInfo.fee.ToString() + "Count:" + sResponse.cardIssueInfo.sum.ToString();
                    Fees = sResponse.cardIssueInfo.fee.ToString();
                    StatusCode = "success";
                }
                else
                {

                    StatusCode = sResponse.operationResult.error.errorCode.ToString();
                    StatusDesc = sResponse.operationResult.error.errorMessage;
                    // Label1.Text += sResponse.operationResult.error.errorCode.ToString() + " (" + sResponse.operationResult.error.errorMessage + ")<BR>";
                }
            }
            else
            {
                //  Label1.Text = "Fee:" + "0" + "Count:" + "-1";
            }
            return Fees;
        }
        catch(Exception ex)
        {
            Common.WriteLog("GetNIDServiceFeeAmount",
                           string.Format("Error: 201: Failed to get the amount,Nid no: {0}, session Uid: {1},Error: {2}",
                           nid_no,
                           sessionUuid,
                           ex.Message));
            return Fees;

        }

        finally
        {
            Common.SaveReqResponseData(nid_no, "GetNIDServiceFeeAmount", CallDateTime, "CorrectionType:"+card_Issue_Type_Code+",Service_type:"+delivery_type, "RetVal:"+Fees, StatusCode, StatusDesc);
        }


    }

    public string GetSessionID()
    {
        string sessionUuid = "";
        WebReferenceNID.loginServiceResponse lsResponse = new WebReferenceNID.loginServiceResponse();;
        try
        {
            System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();
            do
            {
                // for log in
                WebReferenceNID.loginServiceRequest lsr = new WebReferenceNID.loginServiceRequest();
                lsr.username = getValueOfKey("NIDLoginID");
                lsr.password = getValueOfKey("NIDLoginPassword");

                //  loginRequest

                //lsResponse = new WebReferenceNID.loginServiceResponse();
                WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
                lsResponse = ps.login(lsr);

                if (lsResponse.operationResult.success)
                {
                    sessionUuid = lsResponse.sessionUuid;
                    break;
                }
                else
                {
                    //   Label2.Text = lsResponse.operationResult.error.errorMessage;
                    if (lsResponse.operationResult.error.errorCode == 1019
                        && lsResponse.operationResult.error.errorMessage.Contains("Password has been expired"))
                    {
                        if (LoginAttem < 2)
                        {
                            LoginAttem++;
                            ChangeNIDPassword();
                            continue;
                        }
                        else
                            break;
                    }
                    else
                        break;
                }
            } while (true);
            return sessionUuid;
        }
        catch (Exception ex)
        {

            return sessionUuid;
        }
    }

    private void ChangeNIDPassword()
    {
        try
        {
            // for live password change
            WebReferenceNID.changeExpiredPasswordServiceResponse expRes = new WebReferenceNID.changeExpiredPasswordServiceResponse();
            WebReferenceNID.changeExpiredPasswordServiceRequest expreq = new WebReferenceNID.changeExpiredPasswordServiceRequest();
            expreq.loginName = getValueOfKey("NIDLoginID");
            expreq.oldPassword = getValueOfKey("NIDLoginPassword");
            expreq.newPassword = getValueOfKey("NIDLoginPassword");
            expreq.confirmNewPassword = getValueOfKey("NIDLoginPassword");
            WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
            expRes = ps.changeExpiredPassword(expreq);

            if (expRes.operationResult.success)
            {
                // lblTransactionStatus.Text = "new pass:" + expreq.newPassword + "Service ID:" + expRes.serviceId.ToString();
            }
            else
            {
                //lblTransactionStatus.Text += expRes.operationResult.error.errorCode.ToString() + " (" + expRes.operationResult.error.errorMessage + ")<BR>";
            }
        }
        catch (Exception ex) {
            Common.WriteLog("ChangeNIDPassword",
                           string.Format("Error: 203: Failed to ChangeNIDPassword,NIDLoginID: {0}, NIDLoginPassword: {1},Error: {2}",
                          getValueOfKey("NIDLoginID"),
                           getValueOfKey("NIDLoginPassword"),
                           ex.Message));
        }
    }

    private void SaveNIDPaymentConfirmationLog(string refID, string nid, decimal amount,bool ServiceStatus, string result, string sessionID)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Merchant_Service_Push_Update_Log_Insert";  //insert confirmation log
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = refID;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "NID";
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = amount;
                    cmd.Parameters.Add("@ServiceResult", System.Data.SqlDbType.VarChar).Value = result;
                    cmd.Parameters.Add("@ServiceStatus", System.Data.SqlDbType.Bit).Value = ServiceStatus;
                    cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = nid;
                    cmd.Parameters.Add("@Meta4", System.Data.SqlDbType.VarChar).Value = sessionID;


                    //SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                    //sqlDone.Direction = ParameterDirection.InputOutput;
                    //sqlDone.Value = "";
                    //cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                }
            }
        }
        catch (Exception ex)
        {
            Common.WriteLog("s_Merchant_Service_Push_Update_Log_Insert",
                            string.Format("Error: 204:,RefID: {0},Service result: {1},Error: {2}",
                           refID,
                            result,
                            ex.Message));
        }

    }
}