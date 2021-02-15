<%@ WebService Language="C#" Class="MbillPlus_payment" %>

using System;
using System.IO;
using System.Net;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Collections.Generic;
/// <summary>
/// Summary description for MbillPlus_payment
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class MbillPlus_payment : System.Web.Services.WebService
{
    //string pc_code = "28";
    //string pc_br_code = "";
    //string org_code = "WZPDCL";
    //string org_br_code = "";
    //string user_name = "TBL_MFS"; //Given By SRL
    //string customer_code = "tbluser";//Given By SRL
    //string password = "tbluser1234";//Given By SRL

    string pc_code = "";
    string pc_br_code = "";
    string pc_br_code_recons = "";
    string org_code = "";
    string org_br_code = "";
    //string user_name = ""; //Given By SRL for otc=1
    //string user_name_mfs = ""; //Given By SRL for otc=0
    string customer_code = "";//Given By SRL
    string password = "";//Given By SRL

    public MbillPlus_payment()
    {
        pc_code = getValueOfKey("mBill_Pc_KeyCode");
        //   pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode");
        pc_br_code_recons = getValueOfKey("mBill_Pc_Br_Recons_KeyCode");
        org_code = getValueOfKey("mBill_Org_KeyCode");
        //user_name = getValueOfKey("mBill_User_name_keycode");
        //user_name_mfs = getValueOfKey("mBill_User_name_mfs_keycode");
        customer_code = getValueOfKey("mBill_Customer_Keycode");
        password = getValueOfKey("mBill_Password_Keycode");

    }

    [WebMethod(Description = "Service Task: Bill due Information"
        + "<br>" + "Returns:"
        + "<br>" + "400: " + "Success"
        + "<br>" + "448: " + "Data Not Found"
        + "<br>" + "450: " + "More than one bill"
        + "<br>" + "420: " + "Insert Failed"
        + "<br>" + "421: " + "Update Failed"
        + "<br>" + "444: " + "User name Mismatch"
        + "<br>" + "410: " + "Mandatory field NULL"
        + "<br>" + "460: " + "Data Mismatch"
        + "<br>" + "-2: " + "Invalid Keycode"
      )]
    public string Get_Bill_Due_Info(
        string acc_num,
        string billcycle,
        string otc,
        string KeyCode

        )
    {


        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";

        string ref_amt = "Code:101,Msg:Unable to connect to the remote server.";
        string xmlPayload = "";
        string json_result = "";
        string user_name = "";
        org_br_code = acc_num.Substring(0, 3);
        if (otc.Trim() == "1")
        {
            user_name = getValueOfKey("mBill_User_name_keycode");
            pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode");
        }
        if (otc.Trim() == "0")
        {
            user_name = getValueOfKey("mBill_User_name_mfs_keycode");
            pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode0");
        }
        try
        {
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Payment_Gateway.php?org_code=" + org_code + "&customer_code=" + customer_code + "&password=" + password + "&org_br_code=" + org_br_code + "&acc_num=" + acc_num + "&billcycle=" + billcycle + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code + "&user_name=" + user_name + "&otc=" + otc + "&v=1&format=json";

            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it

            //try
            //{
            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }



            JavaScriptSerializer serializer = new JavaScriptSerializer();

            //var result = serializer.DeserializeObject(json_result);



            PymentInfo result = serializer.Deserialize<PymentInfo>(json_result);

            //string name = result.Name;
            //principle_amount = result.Principle_Amount;
            if (result.Account_Number != null && result.Bill_Number != null)
                ref_amt = SaveDueBillInfo(result, otc, "");


        }
        catch (Exception e)
        {
            Common.WriteLog("West Zone Get_Bill_Due_Info",
                                 e.Message);
            //   xmlResult;  //TODO: returns an XML with the error message
        }
        return ref_amt;
    }

    [WebMethod(Description = "Service Task: Bill due Information through MB"
         + "<br>" + "Returns:"
         + "<br>" + "400: " + "Success"
         + "<br>" + "448: " + "Data Not Found"
         + "<br>" + "450: " + "More than one bill"
         + "<br>" + "420: " + "Insert Failed"
         + "<br>" + "421: " + "Update Failed"
         + "<br>" + "444: " + "User name Mismatch"
         + "<br>" + "410: " + "Mandatory field NULL"
         + "<br>" + "460: " + "Data Mismatch"
         + "<br>" + "-2: " + "Invalid Keycode"
       )]
    public string Get_Bill_Due_Info_MB(
         string acc_num,
         string billcycle,
         string otc,
         string KeyCode

         )
    {
        Common.WriteLog("Get_Bill_Due_Info_MB",
                    "keycode:" + KeyCode+"acc_num:"+acc_num+"billcycle"+billcycle+"otc"+otc);

        if (KeyCode != getValueOfKey("mBill_KeyCode"))
        {

            return "-2";
        }

        string ref_amt = "Code:101,Msg:Unable to connect to the remote server.";
        string xmlPayload = "";
        string json_result = "";
        string user_name = "";
        string otc_type = "MB";

        org_br_code = acc_num.Substring(0, 3);
        if (otc.Trim() == "1")
        {
            user_name = getValueOfKey("mBill_User_name_keycode");
            pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode");
        }
        else if (otc.Trim() == "0")
        {
            user_name = getValueOfKey("mBill_User_name_mfs_keycode");
            pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode0");
        }
        else  if (otc.Trim() == "10")
        {
            user_name = getValueOfKey("mBill_User_name_mfs_keycode");
            pc_br_code = getValueOfKey("mBill_Pc_Br_KeyCode0");
            otc_type = "Agent";
            otc = "0";
        }
        try
        {
            //    string url = "http://192.168.20.204/mBillPlus_api/RestAPI/Payment_Gateway.php?org_code=" + org_code + "&customer_code=" + customer_code + "&password=" + password + "&org_br_code=" + org_br_code + "&acc_num=" + acc_num + "&billcycle=" + billcycle + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code + "&user_name=" + user_name + "&otc=" + otc + "&v=1&format=json";
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Payment_Gateway.php?org_code=" + org_code + "&customer_code=" + customer_code + "&password=" + password + "&org_br_code=" + org_br_code + "&acc_num=" + acc_num + "&billcycle=" + billcycle + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code + "&user_name=" + user_name + "&otc=" + otc + "&v=1&format=json";
            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it

            //try
            //{
            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }



            JavaScriptSerializer serializer = new JavaScriptSerializer();

            //var result = serializer.DeserializeObject(json_result);



            PymentInfo result = serializer.Deserialize<PymentInfo>(json_result);

            //string name = result.Name;
            //principle_amount = result.Principle_Amount;
            if (result.Account_Number != null && result.Bill_Number != null)
                ref_amt = SaveDueBillInfo(result, otc, otc_type);
            else
                ref_amt = result.Code+","+result.Msg;

        }
        catch (Exception e)
        {
            Common.WriteLog("West Zone Get_Bill_Due_Info_MB",
                           e.Message);
            //   xmlResult;  //TODO: returns an XML with the error message
        }
        return ref_amt;
    }

    private string SaveDueBillInfo(PymentInfo bill_result, string otc, string type)
    {
        string OtcTypeCode = otc;
        double ServiceCharge = bill_result.Service_Chrg;
        double DueAmount = bill_result.Principle_Amount + bill_result.Vat_Amount;
        if (type == "MB")
        {
            DueAmount = bill_result.Principle_Amount + bill_result.Vat_Amount + ServiceCharge;
        }
        if (type == "Agent")
        {
            ServiceCharge = ServiceCharge * .3;
            DueAmount = bill_result.Principle_Amount + bill_result.Vat_Amount + ServiceCharge;
            OtcTypeCode = "10";
        }

        string RefID = "0";
        string PaymentType = "MB_OFF";

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_mBillPlus_Due_Bill";  //Due bill info save 
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = bill_result.Name;
                    cmd.Parameters.Add("@Account_number", System.Data.SqlDbType.VarChar).Value = bill_result.Account_Number;
                    cmd.Parameters.Add("@Req_Order_Id", System.Data.SqlDbType.VarChar).Value = bill_result.Req_Id;
                    cmd.Parameters.Add("@Bill_Month", System.Data.SqlDbType.VarChar).Value = bill_result.Bill_Month;
                    cmd.Parameters.Add("@Bill_Number", System.Data.SqlDbType.VarChar).Value = bill_result.Bill_Number;
                    cmd.Parameters.Add("@Principal_Amount", System.Data.SqlDbType.VarChar).Value = bill_result.Principle_Amount;
                    cmd.Parameters.Add("@Vat_Amount", System.Data.SqlDbType.VarChar).Value = bill_result.Vat_Amount;
                    cmd.Parameters.Add("@Service_Chrg", System.Data.SqlDbType.Float).Value = ServiceCharge;
                    cmd.Parameters.Add("@Otc", System.Data.SqlDbType.VarChar).Value = otc; // vat acc no field will be otp
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = org_code;
                    cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                    cmd.Parameters.Add("@OtcTypeCode", System.Data.SqlDbType.VarChar).Value = OtcTypeCode;

                    SqlParameter sqlRef = new SqlParameter("@RefID", SqlDbType.VarChar, 18);
                    sqlRef.Direction = ParameterDirection.InputOutput;
                    sqlRef.Value = "";
                    cmd.Parameters.Add(sqlRef);



                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    RefID = string.Format("{0}", sqlRef.Value);

                }
            }

            return RefID + "|" + DueAmount;
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone SaveDueBillInfo,Code:420,Msg:Insert failed-L101.",
                        ex.Message);
            return "Code:420,Msg:Insert failed-L101.";
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
    public string GetCheckout_Ref_Account_Wise(string acc_num, string bill_cycle)
    {
        string RefID = "";

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Ref_Account_Wise";  // Get Ref No.
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Acc_num", System.Data.SqlDbType.VarChar).Value = acc_num;
                    cmd.Parameters.Add("@Bill_cycle", System.Data.SqlDbType.VarChar).Value = bill_cycle;

                    SqlParameter sqlRef = new SqlParameter("@RefID", SqlDbType.VarChar, 18);
                    sqlRef.Direction = ParameterDirection.InputOutput;
                    sqlRef.Value = "";
                    cmd.Parameters.Add(sqlRef);



                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                    RefID = string.Format("{0}", sqlRef.Value);

                }
            }

            return RefID;
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone GetCheckout_Ref_Account_Wise",
                           ex.Message);
            return RefID;
        }

    }


    [WebMethod(Description = "Service Task: Payment Confirmation through MB"
       + "<br>" + "Returns:"
       + "<br>" + "400: " + "Success"
       + "<br>" + "448: " + "Data Not Found"
       + "<br>" + "450: " + "More than one bill"
       + "<br>" + "420: " + "Insert Failed"
       + "<br>" + "421: " + "Update Failed"
       + "<br>" + "444: " + "User name Mismatch"
       + "<br>" + "410: " + "Mandatory field NULL"
       + "<br>" + "460: " + "Data Mismatch"
       + "<br>" + "-1: " + "Payment already Used by another Trxn"
       + "<br>" + "-2: " + "Invalid Keycode"
       + "<br>" + "-3: " + "Payment Not Completed"
       + "<br>" + "-4: " + "Ref id not found"

       + "<br>" + "L101: " + "Payment not Verified"
     )]
    public string Confirm_Payment_MB(
            //string ref_id,
            string Account_Number,
            string Bill_Cycle,
            string KeyCode,
            string TrnID,
            string MobileNo
        )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string req_id = "";
        string acc_num = "";
        string ref_id = "";

        string xmlPayload = "";
        string json_result = "";
        string otc = "0";
        string srv_chrg = "0";
        string pay_type = "";
        string Merchant_AccNo = "";
        double fees = 0;
        double vat_amount = 0;
        string pay_date = "";

        string Code = "101";
        string Msg = "";


     
        Payment_Verify pay_verify = new Payment_Verify();
        try
        {
             ref_id = GetCheckout_Ref_Account_Wise(Account_Number, Bill_Cycle);
            DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(ref_id);
            if (dt_verify.Rows.Count > 0)
            {
                req_id = dt_verify.Rows[0]["OrderID"].ToString();
                acc_num = dt_verify.Rows[0]["Meta3"].ToString();
                otc = dt_verify.Rows[0]["Meta5"].ToString();
                fees = double.Parse(dt_verify.Rows[0]["Fees"].ToString());
                Merchant_AccNo = dt_verify.Rows[0]["AccountNo"].ToString();

                vat_amount = double.Parse(dt_verify.Rows[0]["VatAmount"].ToString());
                pay_type = dt_verify.Rows[0]["Type"].ToString();
            }

            //    Payment_Verify PV = new Payment_Verify();
            if (pay_verify.TBMMpaymentInfoCheck(TrnID, Merchant_AccNo, fees, ref_id))
            {
                PaymentStatusInfo pInfo = MarkAsPaid(ref_id, TrnID, pay_type, MobileNo);
                if (pInfo.PaidStatus == "1")
                {
                    pay_date = string.Format("{0:dd/MM/yyyy}", pInfo.TrnDate);
                    try
                    {
                        string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Payment_Gateway.php?acc_num=" + acc_num + "&customer_code=" + customer_code + "&pc_code=" + pc_code + "&password=" + password + "&trns_id=" + ref_id + "&srv_chrg=" + srv_chrg + "&req_id=" + req_id + "&pc_prin_amt=" + fees + "&pc_vat_amt=" + vat_amount + "&pay_date=" + pay_date + "&otc=" + otc + "&v=1&format=json";
                        //  mBillPlusService.checkValidation xc = new mBillPlusService.checkValidation();

                        // Create the web request
                        HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

                        // Set type to POST
                        request.Method = "POST";
                        request.ContentType = "application/xml";

                        // Create the data we want to send
                        StringBuilder data = new StringBuilder();
                        data.Append(xmlPayload);
                        byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
                        request.ContentLength = byteData.Length;                        // Set the content length in the request headers

                        // Write data to request
                        using (Stream postStream = request.GetRequestStream())
                        {
                            postStream.Write(byteData, 0, byteData.Length);
                        }

                        // Get response and return it

                        //try
                        //{
                        using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
                        {
                            StreamReader reader = new StreamReader(response.GetResponseStream());
                            json_result = reader.ReadToEnd();
                            reader.Close();
                        }



                        JavaScriptSerializer serializer = new JavaScriptSerializer();
                        PymentConfirn result = serializer.Deserialize<PymentConfirn>(json_result);

                        Code = result.Code;
                        Msg = result.Msg;
                        SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, Code, Msg, "");
                    }
                    catch (Exception e)
                    {
                        Common.WriteLog("West Zone Confirm_Payment_MB",
                                      e.Message);
                        //   xmlResult;  //TODO: returns an XML with the error message
                    }
                    //  return Code;
                }

                else
                {
                    Code = "-4";
                }
            }
            else
            {
                Code = "L101";
            }
        }
        catch(Exception ex)
        {
            Common.WriteLog("West Zone Confirm_Payment_MB", ex.Message);
        }
        finally
        {
           
            pay_verify.ServiceReqResponseLog("WZPDCL",ref_id,"Account:" + Account_Number+",billcycle:"+Bill_Cycle+",KeyCode:"+KeyCode+",TrnID:"+TrnID+",Mobile:"+MobileNo,Code,Code);
        }

        return Code;
    }

    [WebMethod(Description = "Service Task: Online Payment Confirmation "
     + "<br>" + "Returns:"
     + "<br>" + "400: " + "Success"
     + "<br>" + "448: " + "Data Not Found"
     + "<br>" + "450: " + "More than one bill"
     + "<br>" + "420: " + "Insert Failed"
     + "<br>" + "421: " + "Update Failed"
     + "<br>" + "444: " + "User name Mismatch"
     + "<br>" + "410: " + "Mandatory field NULL"
     + "<br>" + "460: " + "Data Mismatch"
     + "<br>" + "-1: " + "Payment already Used by another Trxn"
     + "<br>" + "-2: " + "Invalid Keycode"
     + "<br>" + "-3: " + "Payment not Completed"
     + "<br>" + "L101: " + "Payment not Verified"
    )]
    public string Confirm_Payment_Online(
     string ref_id,
     string KeyCode

      )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string req_id = "";
        string acc_num = "";

        string xmlPayload = "";
        string json_result = "";
        string otc = "0";
        string srv_chrg = "0";
        // string pay_type = "MB_OFF";
        //string Merchant_AccNo = "";
        //double fees = 0;

        string Pay_status = "0";
        Boolean Pay_used = false;
        string Code = "L101";
        string Msg = "";

        Payment_Verify pay_verify = new Payment_Verify();
        DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(ref_id);
        if (dt_verify.Rows.Count > 0)
        {
            req_id = dt_verify.Rows[0]["OrderID"].ToString();
            acc_num = dt_verify.Rows[0]["Meta3"].ToString();
            otc = dt_verify.Rows[0]["Meta5"].ToString();
            Pay_status = dt_verify.Rows[0]["Status"].ToString();
            Pay_used = (Boolean)dt_verify.Rows[0]["Used"];
        }


        if (Pay_status == "1")
        {
            //string isPaidMark = MarkAsPaid(ref_id, TrnID, pay_type, MobileNo);
            if (!Pay_used)
            {
                string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Payment_Gateway.php?acc_num=" + acc_num + "&customer_code=" + customer_code + "&pc_code=" + pc_code + "&password=" + password + "&trns_id=" + ref_id + "&srv_chrg=" + srv_chrg + "&req_id=" + req_id + "&otc=" + otc + "&v=1&format=json";
                //  mBillPlusService.checkValidation xc = new mBillPlusService.checkValidation();

                // Create the web request
                HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

                // Set type to POST
                request.Method = "POST";
                request.ContentType = "application/xml";

                // Create the data we want to send
                StringBuilder data = new StringBuilder();
                data.Append(xmlPayload);
                byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
                request.ContentLength = byteData.Length;                        // Set the content length in the request headers

                // Write data to request
                using (Stream postStream = request.GetRequestStream())
                {
                    postStream.Write(byteData, 0, byteData.Length);
                }

                // Get response and return it

                try
                {
                    using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
                    {
                        StreamReader reader = new StreamReader(response.GetResponseStream());
                        json_result = reader.ReadToEnd();
                        reader.Close();
                    }



                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    PymentConfirn result = serializer.Deserialize<PymentConfirn>(json_result);

                    Code = result.Code;
                    Msg = result.Msg;
                    SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, Code, Msg, "");
                }
                catch (Exception e)
                {
                    SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, Code, Msg, "");
                    //  return Code;
                    //   xmlResult;  //TODO: returns an XML with the error message
                }
                //  return Code;
            }

            else
            {
                SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, "-1", Msg, "Payment already Used by another Trxn");
                return "-1";
            }
        }
        else
        {
            SaveMbillPushServiceLog(ref_id, customer_code, req_id, srv_chrg, acc_num, "-3", Msg, "Payment not Completed");
            return "-3";
        }

        return Code;
    }




    private PaymentStatusInfo MarkAsPaid(string ref_id, string trn_id, string pay_type, string mobileNo)
    {
        PaymentStatusInfo RetVal = new PaymentStatusInfo();
        RetVal.PaidStatus = "0";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Payment_Req_to_Paid";  //Mark as Paid
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = ref_id;
                cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = pay_type;
                cmd.Parameters.Add("@TrnID", System.Data.SqlDbType.VarChar).Value = trn_id;
                cmd.Parameters.Add("@MobileNo", System.Data.SqlDbType.VarChar).Value = mobileNo;
                //cmd.Parameters.Add("@Verified", System.Data.SqlDbType.Bit).Value = PaymentStatus;

                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                SqlParameter sqlTrnDate = new SqlParameter("@TrnDate", SqlDbType.Date);
                sqlTrnDate.Direction = ParameterDirection.InputOutput;
                cmd.Parameters.Add(sqlTrnDate);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                RetVal.PaidStatus = string.Format("{0}", sqlDone.Value);
                try {
                    RetVal.TrnDate = (DateTime)sqlTrnDate.Value;
                }
                catch(Exception ex)
                {
                    RetVal.TrnDate = null;
                }
            }
        }
        return RetVal;
    }

    private void SaveMbillPushServiceLog(string refID, string customer_code, string req_id, string srv_chrg, string acc_num, string Code, string Msg, string remarks)
    {
        Boolean Service_Status = false;
        if (Code == "400")
            Service_Status = true;

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
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "WZPDCL";
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = srv_chrg;
                    cmd.Parameters.Add("@ServiceResult", System.Data.SqlDbType.VarChar).Value = Code + "-" + Msg;
                    cmd.Parameters.Add("@ServiceStatus", System.Data.SqlDbType.Bit).Value = Service_Status;
                    cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = req_id;
                    cmd.Parameters.Add("@Meta2", System.Data.SqlDbType.VarChar).Value = customer_code;
                    cmd.Parameters.Add("@Meta3", System.Data.SqlDbType.VarChar).Value = acc_num;
                    cmd.Parameters.Add("@Meta4", System.Data.SqlDbType.VarChar).Value = remarks;


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
            Common.WriteLog("West Zone SaveMbillPushServiceLog",
                           ex.Message);
        }
    }

    private void SaveMbillCancelLog(string refID, string customer_code, string req_id, string acc_num, string Code, string Msg)
    {
        Boolean Service_Status = false;
        if (Code == "400")
            Service_Status = true;

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Merchant_Service_Cancel_Log_Insert";  //insert confirmation log
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = refID;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "WZPDCL";
                    //  cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = srv_chrg;
                    cmd.Parameters.Add("@ServiceResult", System.Data.SqlDbType.VarChar).Value = Code + "-" + Msg;
                    cmd.Parameters.Add("@ServiceStatus", System.Data.SqlDbType.Bit).Value = Service_Status;
                    cmd.Parameters.Add("@Meta1", System.Data.SqlDbType.VarChar).Value = req_id;
                    cmd.Parameters.Add("@Meta2", System.Data.SqlDbType.VarChar).Value = customer_code;
                    cmd.Parameters.Add("@Meta3", System.Data.SqlDbType.VarChar).Value = acc_num;
                    cmd.Parameters.Add("@Meta4", System.Data.SqlDbType.VarChar).Value = "cancel";
                    //cmd.Parameters.Add("@CancelBy", System.Data.SqlDbType.VarChar).Value = CancelBy;
                    //cmd.Parameters.Add("@Reasion", System.Data.SqlDbType.VarChar).Value = remarks;

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
            Common.WriteLog("West Zone SaveMbillCancelLog",
                             ex.Message);
        }
    }

    [WebMethod(Description = "Service Task: Payment Cancel"
       + "<br>" + "Returns:"
       + "<br>" + "400: " + "Success"
       + "<br>" + "448: " + "Data Not Found"
       + "<br>" + "450: " + "More than one bill"
       + "<br>" + "420: " + "Insert Failed"
       + "<br>" + "421: " + "Update Failed"
       + "<br>" + "444: " + "User name Mismatch"
       + "<br>" + "410: " + "Mandatory field NULL"
       + "<br>" + "460: " + "Data Mismatch"
       + "<br>" + "-2: " + "Invalid Keycode"
     )]
    public string Payment_Cancelled(
       string ref_id,
        string KeyCode
      )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string xmlPayload = "";
        string json_result = "";
        string req_id = "";
        string acc_num = "";
        string otc = "0";
        string Code = "101";
        string Msg = "";
        //   string RefID = "";
        Payment_Verify pay_verify = new Payment_Verify();
        try
        {
            // DataTable dt_verify = pay_verify.GetCheckout_DetailsBy_TransID(trans_id);
            DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(ref_id);
            if (dt_verify.Rows.Count > 0)
            {
                req_id = dt_verify.Rows[0]["OrderID"].ToString();
                acc_num = dt_verify.Rows[0]["Meta3"].ToString();
                otc = dt_verify.Rows[0]["Meta5"].ToString();
                //  RefID = dt_verify.Rows[0]["RefID"].ToString();
            }
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Payment_Gateway_Reversal.php?trans_id=" + ref_id + "&pc_code=" + pc_code + "&customer_code=" + customer_code + "&password=" + password + "&req_id=" + req_id + "&otc=" + otc + "&v=1&format=json";


            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it


            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }



            JavaScriptSerializer serializer = new JavaScriptSerializer();
            PymentConfirn result = serializer.Deserialize<PymentConfirn>(json_result);

            Code = result.Code;
            Msg = result.Msg;
            SaveMbillCancelLog(ref_id, customer_code, req_id, acc_num, Code, Msg);


        }
        catch (Exception e)
        {

            Common.WriteLog("West Zone Payment_Cancelled",
                             e.Message);
            return Code;
            //   xmlResult;  //TODO: returns an XML with the error message
        }

        return Code;
    }


    [WebMethod(Description = "Service Task: Reconcile Summary"
     + "<br>" + "Returns:"
     + "<br>" + "400: " + "Success"
     + "<br>" + "410: " + "Mandatory field NULL"
     + "<br>" + "409: " + "Not permitted for this action"
     + "<br>" + "449: " + "Confirmation failed"
     + "<br>" + "460: " + "Data Mismatch"
     + "<br>" + "460: " + "Already Reconciled"
     + "<br>" + "-2: " + "Invalid Keycode"
    )]
    public string Reconcile_Summary(
      string PayDate,
      string KeyCode,
       int otc,
       string UserID

    )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string xmlPayload = "";
        string json_result = "";

        string Page_ID= string.Format("{0}",  Guid.NewGuid());

        try
        {
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Reconcile_Smry.php?org_code=" + org_code + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code_recons + "&customer_code=" + customer_code + "&password=" + password + "&otc=" + otc + "&pay_date=" + PayDate + "&v=1&format=json";
            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it


            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }



            JavaScriptSerializer serializer = new JavaScriptSerializer();
            ReconcileSummary result = serializer.Deserialize<ReconcileSummary>(json_result);
            SaveReconcileSummaryData(result,Page_ID,UserID,otc);
            //OrgCode = result.Org_Code;
            //Pay_date = result.Pay_Date;
            //   SaveMbillCancelLog(trans_id, customer_code, req_id, acc_num, Code, Msg, cancel_by, reasion);


        }
        catch (Exception e)
        {

            Common.WriteLog("West Zone Reconcile Summary",
                             e.Message);
            return Page_ID;
            //   xmlResult;  //TODO: returns an XML with the error message
        }

        return Page_ID;
    }


    [WebMethod(Description = "Service Task: Reconcile Details"
    + "<br>" + "Returns:"
    + "<br>" + "400: " + "Success"
    + "<br>" + "410: " + "Mandatory field NULL"
    + "<br>" + "409: " + "Not permitted for this action"
    + "<br>" + "449: " + "Confirmation failed"
    + "<br>" + "460: " + "Data Mismatch"
    + "<br>" + "460: " + "Already Reconciled"
    + "<br>" + "-2: " + "Invalid Keycode"
    )]
    public string Reconcile_Details(
    string PayDate,
    string KeyCode,
    string otc,
    string UserID

    )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string xmlPayload = "";
        string json_result = "";
        string Page_ID= string.Format("{0}",  Guid.NewGuid());
        try
        {
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Reconcile_Dtl.php?org_code=" + org_code + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code_recons + "&customer_code=" + customer_code + "&password=" + password + "&otc=" + otc + "&pay_date=" + PayDate + "&v=1&format=json";
            //  string url = "http://192.168.20.22//mBillPlus_api/RestAPI/Reconcile_Dtl.php?org_code=" + org_code + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code_recons + "&customer_code=" + customer_code + "&password=" + password + "&otc=" + otc + "&pay_date=" + PayDate + "&v=1&format=json";
            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it


            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }


            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<ReconcileDetail> result = serializer.Deserialize<List<ReconcileDetail>>(json_result);


            SaveBulkData(result,Page_ID,otc,UserID);

        }
        catch (Exception e)
        {

            Common.WriteLog("West Zone Reconcile Details",
                             e.Message);
            return Page_ID;
            //   xmlResult;  //TODO: returns an XML with the error message
        }

        return Page_ID;
    }


    [WebMethod(Description = "Service Task: Reconcile Confirmation"
    + "<br>" + "Returns:"
    + "<br>" + "400: " + "Success"
    + "<br>" + "410: " + "Mandatory field NULL"
    + "<br>" + "409: " + "Not permitted for this action"
    + "<br>" + "449: " + "Confirmation failed"
    + "<br>" + "460: " + "Data Mismatch"
    + "<br>" + "460: " + "Already Reconciled"
    + "<br>" + "-2: " + "Invalid Keycode"
    )]
    public string Reconcile_Confirmation(
    string PayDate,
    string KeyCode,
    string otc

    )
    {
        if (KeyCode != getValueOfKey("mBill_KeyCode"))
            return "-2";
        string xmlPayload = "";
        string json_result = "";
        string ConfirmCode = "";
        try
        {
            string url = "http://192.168.20.22/mBillPlus_api/live/RestAPI/Reconcile_Conf.php?org_code=" + org_code + "&pc_code=" + pc_code + "&pc_br_code=" + pc_br_code_recons + "&customer_code=" + customer_code + "&password=" + password + "&otc=" + otc + "&pay_date=" + PayDate + "&v=1&format=json";
            // Create the web request
            HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

            // Set type to POST
            request.Method = "POST";
            request.ContentType = "application/xml";

            // Create the data we want to send
            StringBuilder data = new StringBuilder();
            data.Append(xmlPayload);
            byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
            request.ContentLength = byteData.Length;                        // Set the content length in the request headers

            // Write data to request
            using (Stream postStream = request.GetRequestStream())
            {
                postStream.Write(byteData, 0, byteData.Length);
            }

            // Get response and return it


            using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            {
                StreamReader reader = new StreamReader(response.GetResponseStream());
                json_result = reader.ReadToEnd();
                reader.Close();
            }



            JavaScriptSerializer serializer = new JavaScriptSerializer();
            PymentConfirn result = serializer.Deserialize<PymentConfirn>(json_result);

            ConfirmCode = result.Code;
            //Pay_date = result.Msg;
            //   SaveMbillCancelLog(trans_id, customer_code, req_id, acc_num, Code, Msg, cancel_by, reasion);


        }
        catch (Exception e)
        {

            Common.WriteLog("West Zone Reconcile Confirmation",
                             e.Message);
            return "";
            //   xmlResult;  //TODO: returns an XML with the error message
        }

        return ConfirmCode;
    }


    private void SaveReconcileSummaryData(ReconcileSummary summaryResult,string pageID,string userID,int otc)
    {

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Reconcile_Summary_Insert";  //insert summary log
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Page_ID", System.Data.SqlDbType.VarChar).Value = pageID;
                    cmd.Parameters.Add("@Org_Code", System.Data.SqlDbType.VarChar).Value =summaryResult.Org_Code;
                    cmd.Parameters.Add("@Pay_Date", System.Data.SqlDbType.Date).Value = summaryResult.Pay_Date;
                    cmd.Parameters.Add("@Otc", System.Data.SqlDbType.Int).Value =otc;
                    cmd.Parameters.Add("@Bank_Name", System.Data.SqlDbType.VarChar).Value = summaryResult.Bank_Name;
                    cmd.Parameters.Add("@Branch_Name", System.Data.SqlDbType.VarChar).Value = summaryResult.Branch_Name;
                    cmd.Parameters.Add("@Org_Principal_Amount", System.Data.SqlDbType.Decimal).Value = summaryResult.Org_Principle_Amount;
                    cmd.Parameters.Add("@Vat_Amount", System.Data.SqlDbType.Decimal).Value = summaryResult.Vat_Amount;
                    cmd.Parameters.Add("@Org_Total_Amount", System.Data.SqlDbType.Decimal).Value = summaryResult.Org_Total_Amount;
                    cmd.Parameters.Add("@Revenue_Stamp_Amount", System.Data.SqlDbType.VarChar).Value = summaryResult.Revenue_Stamp_Amount;
                    cmd.Parameters.Add("@Net_Org_Amount", System.Data.SqlDbType.Decimal).Value = summaryResult.Net_Org_Amount;
                    cmd.Parameters.Add("@Total_Trans", System.Data.SqlDbType.Int).Value = summaryResult.Total_Trans;
                    cmd.Parameters.Add("@Insert_By", System.Data.SqlDbType.VarChar).Value = userID;


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
            Common.WriteLog("West Zone s_Reconcile_Summary_Insert",
                           ex.Message);
        }
    }

    private void SaveBulkData(List<ReconcileDetail> reconDtl, string page_id,string otc,string userid)
    {
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("Page_ID", typeof(Guid));
        dt_mtr.Columns.Add("Org_Code", typeof(string));
        dt_mtr.Columns.Add("Pay_Date", typeof(DateTime));
        dt_mtr.Columns.Add("Otc", typeof(int));
        dt_mtr.Columns.Add("Bank_Name", typeof(string));
        dt_mtr.Columns.Add("Branch_Name", typeof(string));
        dt_mtr.Columns.Add("Consumer_No", typeof(string));
        dt_mtr.Columns.Add("Bill_No", typeof(decimal));
        dt_mtr.Columns.Add("Pay_Bill_Month", typeof(string));
        dt_mtr.Columns.Add("Principal_Amount", typeof(decimal));
        dt_mtr.Columns.Add("Vat_Amount", typeof(decimal));
        dt_mtr.Columns.Add("Total_Amount", typeof(decimal));
        dt_mtr.Columns.Add("Rev_Stamp_Amount", typeof(decimal));
        dt_mtr.Columns.Add("Bank_Trans_Id", typeof(string));
        dt_mtr.Columns.Add("Mbp_Trans_Id", typeof(string));
        dt_mtr.Columns.Add("Insert_By", typeof(string));


        foreach (ReconcileDetail recons in reconDtl)
        {
            dt_mtr.Rows.Add(page_id,recons.Org_Code,recons.Pay_Date,otc,recons.Bank_Name,recons.Branch_Name,recons.Consumer_No,recons.Bill_No,recons.Pay_Bill_Month,recons.Principle_Amount,recons.Vat_Amount,recons.Total_Amount,recons.Rev_Stamp_Amount,recons.Bank_Trans_ID,recons.Mbp_Trans_ID,userid);
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
                    bulkCopy.DestinationTableName = "Reconcile_Details";
                    bulkCopy.WriteToServer(dt_mtr);
                }

            }

        }
        //else
        //    TrustControl1.ClientMsg("Data Not Found");

    }

}



struct PymentInfo
{
    public string Name { get; set; }
    public string Account_Number { get; set; }
    public string Req_Id { get; set; }
    public string Bill_Month { get; set; }

    public string Bill_Number { get; set; }
    public double Principle_Amount { get; set; }
    public string Vat { get; set; }
    public double Vat_Amount { get; set; }
    public double Service_Chrg { get; set; }

    public string Org_Account { get; set; }
    public string Principle_Acc_Num { get; set; }
    public string Vat_Acc_Num { get; set; }

    public string Code { get; set; }
    public string Msg { get; set; }
}

struct PymentConfirn
{
    public string Code { get; set; }
    public string Msg { get; set; }
}

struct ReconcileSummary
{
    public string Org_Code { get; set; }
    public DateTime Pay_Date { get; set; }
    public string Bank_Name { get; set; }
    public string Branch_Name { get; set; }
    public double Org_Principle_Amount { get; set; }

    public double Vat_Amount { get; set; }
    public double Org_Total_Amount { get; set; }
    public double Revenue_Stamp_Amount { get; set; }
    public double Net_Org_Amount { get; set; }
    public int Total_Trans { get; set; }
}



public struct ReconcileDetail
{
    public string Org_Code { get; set; }
    public string Pay_Date { get; set; }
    public string Bank_Name { get; set; }
    public string Branch_Name { get; set; }
    public string Consumer_No { get; set; }
    public string Bill_No { get; set; }
    public string Pay_Bill_Month { get; set; }
    public string Principle_Amount { get; set; }
    public string Vat_Amount { get; set; }
    public string Total_Amount { get; set; }
    public string Rev_Stamp_Amount { get; set; }
    public string Bank_Trans_ID { get; set; }
    public string Mbp_Trans_ID { get; set; }
}



struct PaymentStatusInfo
{
    public string PaidStatus { get; set; }
    public DateTime? TrnDate { get; set; }
}

