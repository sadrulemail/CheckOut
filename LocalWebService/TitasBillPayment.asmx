<%@ WebService Language="C#" Class="TitasBillPayment" %>

using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

using System.IO;
using System.Net;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Security.Cryptography;
using System.Text;

using System.Web.Script.Serialization;


/// <summary>
/// Summary description for NID_GetDueAmount
/// </summary>
[WebService(Namespace = "http://172.31.8.18/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class TitasBillPayment : System.Web.Services.WebService
{



    [WebMethod(Description = "Service Task: Get Customer Code with a specified Customer ID"
     + "<br>" + "Returns:"
     + "<br>" + "-2: " + "Invalid KeyCode"
     + "<br>" + "Response Code=RefID|" + "json"

   )]
    public string GetCustomerInformation(
    string CustomerID,
    string RoutingCode,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";

        string InvoiceUrl = "/bank/api/v1/customers/" + CustomerID;

        string json = "";
        //  string CallRefID = Guid.NewGuid().ToString();
        DateTime callDateTime = DateTime.Now;

        string Http_Status = "";

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

        string RefID = "";

        string RtnMsg = "";

        try
        {


            string json_httpStatus = GetServiceJsonData(RoutingCode, InvoiceUrl, "GetCustomerInformation");
            string[] jsonRtn = new string[2];
            jsonRtn = json_httpStatus.Split('|');
            json = jsonRtn[1];
            Http_Status = jsonRtn[0];
            if (jsonRtn[0].ToUpper() == "OK")
            {
                TtCustomerInfo payment = jsonSerializer.Deserialize<TtCustomerInfo>(json);
                RefID = SaveCustomerInformation(RoutingCode, CustomerID, payment.data.customerCode, payment.data.customerName, payment.data.applianceSummary, payment.data.connectionAddress, payment.data.mobile, 0, 0, payment.data.id, null, EmpID, "1", null);
            }
            RtnMsg = RefID + "|" + json;

        }

        catch (Exception ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            Common.WriteLog("GetCustomerInformation", ex.Message, "TITAS");

        }
        finally
        {

            Common.SaveReqResponseData(RefID, "GetCustomerInformation", callDateTime, CustomerID, json, Http_Status, Http_Status, "TITAS", EmpID);

        }
        return RtnMsg;
    }

    private string GetServiceJsonData(string RoutingCode, string PaymentUrl, string webMethod)
    {
        string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
        //  string InvoiceUrl = TitasBaseUrl + "/bank/api/v1/customers/" + CustomerID;
        string InvoiceUrl = TitasBaseUrl + PaymentUrl;
        string json = "";
        string Http_Status = "";
        try
        {
            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            //  var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            HttpWebRequest myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            //   myHttpWebRequest.Headers.Add("Authorization", token_);
            myHttpWebRequest.Accept = "application/json";

            myHttpWebRequest.Headers.Add("X-API-KEY", getValueOfKey("Titas_Api_key"));
            myHttpWebRequest.Headers.Add("X-AUTH-SECRET", getValueOfKey("Titas_Auth_Secret"));
            myHttpWebRequest.Headers.Add("X-ROUTE", RoutingCode);

            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
            Http_Status = myWebResponse.StatusCode.ToString();

            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {

                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();

                responseStream.Close();
                myWebResponse.Close();

            }
        }
        catch (WebException ex)
        {
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();

            }
            json = Http_Status;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }
        catch (Exception ex)
        {

            json = ex.Message;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }

        return Http_Status + "|" + json;
    }


    private string PostServiceJsonData(string RoutingCode, string PaymentUrl, string webMethod, string PostData)
    {
        string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
        string InvoiceUrl = TitasBaseUrl + PaymentUrl;
        string json = "";
        string Http_Status = "";
        try
        {
            var request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);


            var data = Encoding.ASCII.GetBytes(PostData);

            request.Method = "POST";
            request.ContentType = "application/x-www-form-urlencoded";
            request.ContentLength = data.Length;

            request.Headers.Add("X-API-KEY", getValueOfKey("Titas_Api_key"));
            request.Headers.Add("X-AUTH-SECRET", getValueOfKey("Titas_Auth_Secret"));
            request.Headers.Add("X-ROUTE", RoutingCode);

            using (var stream = request.GetRequestStream())
            {
                stream.Write(data, 0, data.Length);
            }

            var response = (HttpWebResponse)request.GetResponse();

            Http_Status = response.StatusCode.ToString();

            //json = new StreamReader(response_.GetResponseStream()).ReadToEnd();

            var responseStream = response.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();

                responseStream.Close();
                response.Close();
            }




        }
        catch (WebException ex)
        {
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();

            }
            json = Http_Status;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }
        catch (Exception ex)
        {

            json = ex.Message;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }

        return Http_Status + "|" + json;
    }


    private string DeleteServiceJsonData(string RoutingCode, string PaymentUrl, string webMethod)
    {
        string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
        string InvoiceUrl = TitasBaseUrl + PaymentUrl;
        string json = "";
        string Http_Status = "";
        try
        {
            ///
            // Create the web request  
            HttpWebRequest request = WebRequest.Create(InvoiceUrl) as HttpWebRequest;

            // Set type to DELETE 
            request.Method = "DELETE";
            request.KeepAlive = true;
            request.Credentials = CredentialCache.DefaultCredentials;
            //request.Headers.Add("Key1", "Value1");
            //request.Headers.Add("Key2", "Value2");
            //request.Accept = "application/xml"; // Determines the response type as XML or JSON etc

            // Get response  
            //using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
            //{
            //    Stream ResponseStream = null;
            //    ResponseStream = httpResponse.GetResponseStream();
            //    int responseCode = (int)httpResponse.StatusCode;
            //    string   responseBody = ((new StreamReader(ResponseStream)).ReadToEnd());
            //    string contentType = contentType;
            //}
            ///


            request.Headers.Add("X-API-KEY", getValueOfKey("Titas_Api_key"));
            request.Headers.Add("X-AUTH-SECRET", getValueOfKey("Titas_Auth_Secret"));
            request.Headers.Add("X-ROUTE", RoutingCode);

            //using (var stream = request.GetRequestStream())
            //{
            //    stream.Write(data, 0, data.Length);
            //}

            var response = (HttpWebResponse)request.GetResponse();

            Http_Status = response.StatusCode.ToString();

            //json = new StreamReader(response_.GetResponseStream()).ReadToEnd();

            var responseStream = response.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();

                responseStream.Close();
                response.Close();
            }




        }
        catch (WebException ex)
        {
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();


            }
            json = Http_Status;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }
        catch (Exception ex)
        {

            json = ex.Message;
            Common.WriteLog(webMethod, ex.Message, "TITAS");

        }

        return Http_Status + "|" + json;
    }


    private string SaveCustomerInformation(string routingCode, string customerId, string CustomerCode, string CustomerName, string ApplianceSummery, string ConnectionAddress, string CustomerMobile, double Amount, double SurCharge, string PaymentId, DateTime? DueDate, string empID, string BillType, string InvoiceNo)
    {
        string RefID = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TitasBillPayment_Insert";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RoutingNo", System.Data.SqlDbType.VarChar).Value = routingCode;
                    cmd.Parameters.Add("@CustomerId", System.Data.SqlDbType.VarChar).Value = customerId;
                    cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = CustomerCode;
                    cmd.Parameters.Add("@CustomerName", System.Data.SqlDbType.VarChar).Value = CustomerName;
                    cmd.Parameters.Add("@ApplianceSummery", System.Data.SqlDbType.VarChar).Value = ApplianceSummery;
                    cmd.Parameters.Add("@ConnectionAddress", System.Data.SqlDbType.VarChar).Value = ConnectionAddress;
                    cmd.Parameters.Add("@CustomerMobile", System.Data.SqlDbType.VarChar).Value = CustomerMobile;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@SurCharge", System.Data.SqlDbType.Decimal).Value = SurCharge;
                    cmd.Parameters.Add("@PaymentId", System.Data.SqlDbType.VarChar).Value = PaymentId;
                    try
                    {
                        cmd.Parameters.Add("@DueDate", System.Data.SqlDbType.Date).Value = DueDate;
                    }
                    catch (Exception ex)
                    { }
                    cmd.Parameters.Add("@InvoiceNo", System.Data.SqlDbType.VarChar).Value = InvoiceNo;
                    cmd.Parameters.Add("@BillType", System.Data.SqlDbType.VarChar).Value = BillType;
                    cmd.Parameters.Add("@IsMeter", System.Data.SqlDbType.Bit).Value = 0;
                    cmd.Parameters.Add("@InsertBy", System.Data.SqlDbType.VarChar).Value = empID;

                    SqlParameter sqlRefID = new SqlParameter("@RefID", SqlDbType.VarChar, 20);
                    sqlRefID.Direction = ParameterDirection.InputOutput;
                    sqlRefID.Value = "";
                    cmd.Parameters.Add(sqlRefID);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    RefID = sqlRefID.Value.ToString();

                }

            }
        }
        catch (Exception ex)
        {
            Common.WriteLog("s_CheckoutServiceLog_Insert", ex.Message, "TITAS");
        }
        return RefID;
    }



    private string SaveCustomerPayment(TtPaymentEntry ttPyment, string RefID, string mobile, string customerCode, string RoutingCode)
    {
        string Msg = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TitasBillPayment_Paid";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = customerCode;
                    cmd.Parameters.Add("@CustomerMobile", System.Data.SqlDbType.VarChar).Value = mobile;

                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = ttPyment.data.amount;
                    cmd.Parameters.Add("@SurCharge", System.Data.SqlDbType.Decimal).Value = ttPyment.data.surcharge;

                    cmd.Parameters.Add("@Particulars", System.Data.SqlDbType.VarChar).Value = ttPyment.data.particulars;
                    cmd.Parameters.Add("@BatchNo", System.Data.SqlDbType.VarChar).Value = ttPyment.data.batchNo;
                    try
                    {
                        if (ttPyment.data.voucherDate.Contains("-"))
                            cmd.Parameters.Add("@VoucherDate", System.Data.SqlDbType.Date).Value = DateTime.Parse(ttPyment.data.voucherDate);
                        if (ttPyment.data.voucherDate.Contains("/"))
                            cmd.Parameters.Add("@VoucherDate", System.Data.SqlDbType.Date).Value = DateTime.ParseExact(ttPyment.data.voucherDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);
                    }
                    catch (Exception ex)
                    { }
                    cmd.Parameters.Add("@PaymentId", System.Data.SqlDbType.VarChar).Value = ttPyment.data.id;
                    cmd.Parameters.Add("@BankTransactionID", System.Data.SqlDbType.VarChar).Value = ttPyment.data.bankTransactionId;
                    cmd.Parameters.Add("@ResponseStatus", System.Data.SqlDbType.VarChar).Value = ttPyment.status;
                    cmd.Parameters.Add("@RoutingCode", System.Data.SqlDbType.VarChar).Value = RoutingCode;

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 100);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = "";
                    cmd.Parameters.Add(sqlMsg);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Msg = sqlMsg.Value.ToString();

                }

            }
        }
        catch (Exception ex)
        {
            Msg = ex.Message;
            Common.WriteLog("s_TitasBillPayment_Paid", ex.Message, "TITAS");
        }
        return Common.XmlText(Msg);
    }


    private string CancelBillPayment(string RefID, string PaymentID, double? Amount, double? Surcharge, string BatchNo, string Particulars, string ResponseStatus, string Reason, string EmpID)
    {
        string Msg = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TitasBillPayment_Cancel";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@SurCharge", System.Data.SqlDbType.Decimal).Value = Surcharge;

                    cmd.Parameters.Add("@Particulars", System.Data.SqlDbType.VarChar).Value = Particulars;
                    cmd.Parameters.Add("@BatchNo", System.Data.SqlDbType.VarChar).Value = BatchNo;
                    cmd.Parameters.Add("@PaymentId", System.Data.SqlDbType.VarChar).Value = PaymentID;
                    cmd.Parameters.Add("@ResponseStatus", System.Data.SqlDbType.VarChar).Value = ResponseStatus;
                    cmd.Parameters.Add("@CancelReason", System.Data.SqlDbType.VarChar).Value = Reason;
                    cmd.Parameters.Add("@EmpID", System.Data.SqlDbType.VarChar).Value = EmpID;

                    SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 100);
                    sqlMsg.Direction = ParameterDirection.InputOutput;
                    sqlMsg.Value = "";
                    cmd.Parameters.Add(sqlMsg);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Msg = sqlMsg.Value.ToString();

                }

            }
        }
        catch (Exception ex)
        {
            Msg = ex.Message;
            Common.WriteLog("s_TitasBillPayment_Paid", ex.Message, "TITAS");
        }
        return Common.XmlText(Msg);
    }

    [WebMethod(Description = "Service Task: Create new Payment with a specified Customer ID"
        + "<br>" + "Returns:"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "Response Code=1|refid: " + "Success"

      )]
    public string PostPaymentEntry(
    string RefID,
    string PaymentID,
    string Particulars,
    string MobileNo,
    double Amount,
    double Surcharge,
    string RoutingNo,
    string CustomerCode,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string InvoiceUrl = "/bank/api/v1/payments/";

        string http_response = "";
        string ReturnMsg = "";

        string json = "";
        string Msg = "";

        DateTime callDateTime = DateTime.Now;
        try
        {

            if (RefID != "")
            {

                var postData = "customer=" + PaymentID;
                postData += "&amount=" + Amount;
                postData += "&surcharge=" + Surcharge;
                postData += "&particulars=" + Particulars;
                postData += "&bankTransactionId=" + RoutingNo + RefID;
                postData += "&cellPhone=" + MobileNo;


                string json_httpStatus = PostServiceJsonData(RoutingNo, InvoiceUrl, "PostPaymentEntry", postData);
                string[] jsonRtn = new string[2];
                jsonRtn = json_httpStatus.Split('|');
                json = jsonRtn[1];
                http_response = jsonRtn[0];
                if (jsonRtn[0] == "OK")
                {

                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                    TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

                    if (paymentEntry.status.ToUpper() == "SUCCESS")
                    {
                        Msg = SaveCustomerPayment(paymentEntry, RefID, MobileNo, CustomerCode, RoutingNo);
                        ReturnMsg = "1|" + Msg;
                    }
                    else

                        ReturnMsg = "0|" + paymentEntry.message;


                }
                else
                {
                    ReturnMsg = "0|" + jsonRtn[0];
                }
            }



        }
        catch (Exception ex)
        {
            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("PostPaymentEntry", ex.Message, "TITAS");

        }

        finally
        {
            Common.SaveReqResponseData(RefID, "PostPaymentEntry", callDateTime, CustomerCode, json, http_response, ReturnMsg, "TITAS", EmpID);
        }

        return Common.XmlText(ReturnMsg);
    }



    [WebMethod(Description = "Service Task: Delete Payment Entry with a specified Payment ID"
    + "<br>" + "Returns:"
    + "<br>" + "-2: " + "Invalid KeyCode"
    + "<br>" + "Response Code=1000: " + "Success"

    )]
    public string DeletePaymentEntry(
    string RefID,
    string ID,
    string CancelReason,
    string RoutingCode,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string InvoiceUrl = "/bank/api/v1/payments/" + ID;

        string http_response = "";
        string ReturnMsg = "";

        //    string token_ = "";
        string json = "";
        DateTime callDateTime = DateTime.Now;
        // TfComplaints comObj = new TfComplaints();
        try
        {

            string json_httpStatus = DeleteServiceJsonData(RoutingCode, InvoiceUrl, "DeletePaymentEntry");
            string[] jsonRtn = new string[2];
            jsonRtn = json_httpStatus.Split('|');
            json = jsonRtn[1];
            http_response = jsonRtn[0];
            if (jsonRtn[0] == "OK")
            {

                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

                if (paymentEntry.status.ToUpper() == "SUCCESS")
                {
                    string Msg = CancelBillPayment(RefID, paymentEntry.data.id, paymentEntry.data.amount, paymentEntry.data.surcharge, paymentEntry.data.batchNo, paymentEntry.data.particulars, "success", CancelReason, EmpID);
                    ReturnMsg = "1|" + Msg;
                }
                else
                {
                    CancelBillPayment(RefID, paymentEntry.data.id, paymentEntry.data.amount, paymentEntry.data.surcharge, paymentEntry.data.batchNo, paymentEntry.data.particulars, "fail", CancelReason, EmpID);
                    ReturnMsg = "0|" + paymentEntry.status;
                }


            }
            else
            {
                ReturnMsg = "0|" + jsonRtn[0];
            }

        }
        catch (Exception ex)
        {

            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("DeletePaymentEntry", ex.Message, "TITAS");
        }
        finally
        {
            Common.SaveReqResponseData(RefID, "DeletePaymentEntry", callDateTime, ID.ToString(), json, http_response, ReturnMsg, "TITAS", EmpID);
        }
        return ReturnMsg;
    }


    [WebMethod(Description = "Service Task: Get  Demand Note Info with a specified Invoice No"
     + "<br>" + "Returns:"
     + "<br>" + "Response Code=1: " + "Success"

    )]
    public string GetDemandNoteInformation(
    string InvoiceNo,
    string RoutingCode,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string InvoiceUrl = "/bank/api/v1/demand-note/invoice/" + InvoiceNo;
        string json = "";
        //  string CallRefID = Guid.NewGuid().ToString();
        DateTime callDateTime = DateTime.Now;
        string Http_Status = "";
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        string RefID = "";
        string RtnMsg = "";
        try
        {

            string json_httpStatus = GetServiceJsonData(RoutingCode, InvoiceUrl, "GetDemandNoteInformation");
            string[] jsonRtn = new string[2];
            jsonRtn = json_httpStatus.Split('|');
            json = jsonRtn[1];
            Http_Status = jsonRtn[0];
            if (jsonRtn[0].ToUpper() == "OK")
            {
                TtDemandNote dNote = jsonSerializer.Deserialize<TtDemandNote>(json);
                DateTime? dueDate = null;
                if (dNote.data.dueDate != "")
                    dueDate = DateTime.ParseExact(dNote.data.dueDate, "dd-MM-yyyy", CultureInfo.InvariantCulture);
                RefID = SaveCustomerInformation(RoutingCode, dNote.data.customerId, dNote.data.customerCode, dNote.data.customerName, null, dNote.data.connectionAddress, dNote.data.mobile, dNote.data.paymentAmount, 0, null, dueDate, EmpID, "7", InvoiceNo);

            }
            RtnMsg = RefID + "|" + json;

        }

        catch (Exception ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            Common.WriteLog("GetDemandNoteInformation", ex.Message, "TITAS");

        }
        finally
        {

            Common.SaveReqResponseData(RefID, "GetDemandNoteInformation", callDateTime, InvoiceNo, json, Http_Status, Http_Status, "TITAS", EmpID);

        }
        return RtnMsg;



    }

        

    [WebMethod(Description = "Service Task: Create new Payment with a specified Invoice No"
           + "<br>" + "Returns:"
           + "<br>" + "Response Code=1|refid: " + "Success"

         )]
    public string PostDemandNotePayment(
       string RefID,
       string InvoiceNo,
       string CustomerId,
       string RoutingNo,
       string MobileNo,
       string EmpID,
       string KeyCode
       )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string InvoiceUrl = "/bank/api/v1/demand-note/payments/";

        string http_response = "";
        string ReturnMsg = "";
        string Http_Status="";
        string json = "";
        string Msg = "";
        string bankTransactionId = RoutingNo + RefID;
        DateTime callDateTime = DateTime.Now;
        try
        {

            if (RefID != "")
            {

                var postData = "invoiceNo=" + InvoiceNo;
                postData += "&customerId=" + CustomerId;
                postData += "&bankTransactionId=" + bankTransactionId;
                //postData += "&bankTransactionId=" + RoutingNo + RefID;


                string json_httpStatus = PostServiceJsonData(RoutingNo, InvoiceUrl, "PostDemandNotePayment", postData);
                string[] jsonRtn = new string[2];
                jsonRtn = json_httpStatus.Split('|');
                json = jsonRtn[1];
                http_response = jsonRtn[0];
                if (jsonRtn[0] == "OK")
                {

                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                    TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

                    if (paymentEntry.status.ToUpper() == "SUCCESS")
                    {
                        Msg = SaveCustomerPayment(paymentEntry, RefID, MobileNo, null, RoutingNo);
                        ReturnMsg = "1|" + Msg;
                    }
                    else

                        ReturnMsg = "0|" + paymentEntry.message;


                }
                else
                {
                    ReturnMsg = "0|" + jsonRtn[0];
                }
            }



        }
        catch (WebException ex)
        {
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusDescription.ToString();


            }

            ReturnMsg = "0|" + Http_Status;
            Common.WriteLog("PostPaymentEntry", ex.Message, "TITAS");

        }
        catch (Exception ex)
        {

            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("PostPaymentEntry", ex.Message, "TITAS");

        }

        finally
        {
            Common.SaveReqResponseData(RefID, "PostPaymentEntry", callDateTime, InvoiceNo+",bankTransactionId"+bankTransactionId, json, http_response, ReturnMsg, "TITAS", EmpID);
        }

        return Common.XmlText(ReturnMsg);

    }

    [WebMethod(Description = "Service Task: Delete Demand Note Payment  with a specified Payment ID"
    + "<br>" + "Returns:"
    + "<br>" + "Response Code=1000: " + "Success"

    )]
    public string DeleteDemandNotePayment(
    string RefID,
    string PaymentID,
    string CancelReason,
    string RoutingCode,
    string EmpID,
    string KeyCode
    )
    {

        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string InvoiceUrl = "/bank/api/v1/demand-note/payments/" + PaymentID;

        string http_response = "";
        string ReturnMsg = "";

        //    string token_ = "";
        string json = "";
        DateTime callDateTime = DateTime.Now;
        // TfComplaints comObj = new TfComplaints();
        try
        {

            string json_httpStatus = DeleteServiceJsonData(RoutingCode, InvoiceUrl, "DeleteDemandNotePayment");
            string[] jsonRtn = new string[2];
            jsonRtn = json_httpStatus.Split('|');
            json = jsonRtn[1];
            http_response = jsonRtn[0];
            if (jsonRtn[0] == "OK")
            {

                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

                if (paymentEntry.status.ToUpper() == "SUCCESS")
                {
                    string Msg = CancelBillPayment(RefID, paymentEntry.data.id, paymentEntry.data.amount, paymentEntry.data.surcharge, paymentEntry.data.batchNo, paymentEntry.data.particulars, "success", CancelReason, EmpID);
                    ReturnMsg = "1|" + Msg;
                }
                else
                {
                    CancelBillPayment(RefID, paymentEntry.data.id, paymentEntry.data.amount, paymentEntry.data.surcharge, paymentEntry.data.batchNo, paymentEntry.data.particulars, "fail", CancelReason, EmpID);
                    ReturnMsg = "0|" + paymentEntry.status;
                }


            }
            else
            {
                ReturnMsg = "0|" + jsonRtn[0];
            }

        }
        catch (Exception ex)
        {

            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("DeleteDemandNotePayment", ex.Message, "TITAS");
        }
        finally
        {
            Common.SaveReqResponseData(RefID, "DeleteDemandNotePayment", callDateTime, PaymentID, json, http_response, ReturnMsg, "TITAS", EmpID);
        }
        return ReturnMsg;
    }




    [WebMethod(Description = "Service Task: Get Daily Payment and Demand Note History"
    + "<br>" + "HistoryType:DailyPaymentHistory(1),DailyDemandNotePayHistory(2)"
    + "<br>" + "Returns:"
    + "<br>" + "-2: " + "Invalid KeyCode"
    + "<br>" + "Response Code=1: " + "json"

    )]
    public string GetDailyPaymentHistory(
    string PayDate,
    string HistoryType,
    string RoutingCode,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string SessionId = Guid.NewGuid().ToString();
        string InvoiceUrl = "";
        string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
        if (HistoryType == "1")
            InvoiceUrl = TitasBaseUrl + "/bank/api/v1/payments/" + PayDate;
        else InvoiceUrl = TitasBaseUrl + "/bank/api/v1/demand-note/payments/" + PayDate;


        string json = "";

        DateTime callDateTime = DateTime.Now;

        string Http_Status = "";

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

        string RtnMsg = "";

        try
        {

            //json = @"{" +
            //         "\"status\": \"success\"," +
            //         "\"message\": \"Success\"," +
            //         "\"data\":" +
            //        @"[{" +
            //      "\"id\":24,\"bank\":\"TRUST BANK LTD.\",\"amount\":10300,\"surcharge\":10,\"total\":10310,\"particulars\":\"2016\",\"voucherDate\":\"20/07/2017\",\"bankTransactionId\":\"123456000\",\"batchNo\":\"11201707201459\"}," +
            //        "{\"id\":20,\"bank\":\"TRUST BANK LTD.\",\"amount\":10300,\"surcharge\":10,\"total\":10310,\"particulars\":\"2016\",\"voucherDate\":\"20/07/2017\",\"bankTransactionId\":\"123456000\",\"batchNo\":\"11201707201459\"}," +
            //         "{\"id\":22,\"bank\":\"TRUST BANK LTD.\",\"amount\":10300,\"surcharge\":10,\"total\":10310,\"particulars\":\"2016\",\"voucherDate\":\"20/07/2017\",\"bankTransactionId\":\"123456000\",\"batchNo\":\"11201707201459\"}" +
            //     "]}";

            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            //  var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            HttpWebRequest myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            //   myHttpWebRequest.Headers.Add("Authorization", token_);
            myHttpWebRequest.Accept = "application/json";

            myHttpWebRequest.Headers.Add("X-API-KEY", getValueOfKey("Titas_Api_key"));
            myHttpWebRequest.Headers.Add("X-AUTH-SECRET", getValueOfKey("Titas_Auth_Secret"));
            myHttpWebRequest.Headers.Add("X-ROUTE", RoutingCode);

            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
            Http_Status = myWebResponse.StatusCode.ToString();

            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {

                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();

                responseStream.Close();
                myWebResponse.Close();

            }

            TtDemandNoteHistory dNote = jsonSerializer.Deserialize<TtDemandNoteHistory>(json);
            if (dNote.message.ToLower() == "success")
            {
                SaveBulkDailyPaymentHistory(SessionId, dNote.data, EmpID);
                RtnMsg = 1 + "|" + SessionId;
            }
            else
                RtnMsg = 0 + "|" + dNote.message.ToLower();


        }
        catch (WebException ex)
        {
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();


            }

            RtnMsg = 0 + "|" + Http_Status;
            Common.WriteLog(HistoryType, ex.Message, "TITAS");

        }
        catch (Exception ex)
        {
            RtnMsg = 0 + "|" + ex.Message;
            Common.WriteLog(HistoryType, ex.Message, "TITAS");

        }
        finally
        {

            Common.SaveReqResponseData(SessionId, HistoryType, callDateTime, PayDate, "", Http_Status, Http_Status, "TITAS", EmpID);

        }
        return RtnMsg;
    }

    private int SaveBulkDailyPaymentHistory(string SessionId, TtPaymentData[] dataList, string EmpID)
    {
        int IsSave = 0;
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("SessionID", typeof(string));
        dt_mtr.Columns.Add("PaymentId", typeof(string));
        dt_mtr.Columns.Add("BankName", typeof(string));
        dt_mtr.Columns.Add("BatchNo", typeof(string));
        dt_mtr.Columns.Add("Amount", typeof(double));

        dt_mtr.Columns.Add("Surcharge", typeof(double));
        dt_mtr.Columns.Add("TotalAmount", typeof(double));
        dt_mtr.Columns.Add("VoucherDate", typeof(DateTime));
        dt_mtr.Columns.Add("Particulars", typeof(string));
        dt_mtr.Columns.Add("BankTransactionID", typeof(string));

        dt_mtr.Columns.Add("InsertBy", typeof(string));
        dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
        DateTime? voucherDT = null;
        try
        {

            foreach (TtPaymentData row in dataList)
            {
                if (row.voucherDate.Contains("-"))
                    voucherDT = DateTime.ParseExact(row.voucherDate, "dd-MM-yyyy", CultureInfo.InvariantCulture);
                if (row.voucherDate.Contains("/"))
                    voucherDT = DateTime.ParseExact(row.voucherDate, "dd/MM/yyyy", CultureInfo.InvariantCulture);

                dt_mtr.Rows.Add(SessionId, row.id, row.bank, row.batchNo, row.amount, row.surcharge, row.total, voucherDT, row.particulars, row.bankTransactionId, EmpID, DateTime.Now);

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
                        bulkCopy.DestinationTableName = "TitasPaymentReconcilation";
                        bulkCopy.WriteToServer(dt_mtr);
                    }

                }
                IsSave = 1;
            }

        }
        catch (Exception ex)
        {
            IsSave = 2;
            Common.WriteLog("PaymentReconcilation", ex.Message, "TITAS");
        }
        return IsSave;
    }

    //[WebMethod(Description = "Service Task: Get installment Info with a specified Invoice No"
    // + "<br>" + "Returns:"
    // + "<br>" + "Response Code=1: " + "Success"

    //)]
    //public string GetInstallmentInformation(
    //string InvoiceNo,
    //string RoutingCode,
    //string EmpID,
    //string KeyCode
    //)
    //{
    //    string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
    //    string InvoiceUrl = TitasBaseUrl + "/bank/api/v1/invoice/" + InvoiceNo;

    //    string json = "";
    //    string CallRefID = Guid.NewGuid().ToString();
    //    DateTime callDateTime = DateTime.Now;
    //    string token_ = "";
    //    string Http_Status = "";

    //    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

    //    string RefID = "";

    //    string RtnMsg = "";

    //    try
    //    {

    //        if (KeyCode != "")
    //        //   token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName3P"), getValueOfKey("TransfastPassword3P"), getValueOfKey("TransfastBranchId3P"));
    //        {
    //            var myUri = new Uri(InvoiceUrl);
    //            var myWebRequest = WebRequest.Create(myUri);
    //            //  var myHttpWebRequest = (HttpWebRequest)myWebRequest;
    //            HttpWebRequest myHttpWebRequest = (HttpWebRequest)myWebRequest;
    //            myHttpWebRequest.PreAuthenticate = true;
    //            myHttpWebRequest.Headers.Add("Authorization", token_);
    //            myHttpWebRequest.Accept = "application/json";
    //            // myWebRequest.Method = "PUT"; //for download invoice
    //            var myWebResponse = (HttpWebResponse)myHttpWebRequest.GetResponse();
    //            Http_Status = myWebResponse.StatusCode.ToString();

    //            var responseStream = myWebResponse.GetResponseStream();
    //            if (responseStream != null)
    //            {

    //                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
    //                json = myStreamReader.ReadToEnd();

    //                responseStream.Close();
    //                myWebResponse.Close();

    //            }
    //        }

    //        //        string json_ = @"{" +
    //        //"\"status\":\"success\"," +
    //        //"\"message\":\"Success\"," +
    //        //"\"IdType\":14," +
    //        //"\"IdTypeStringReplacement\":\"14\"," +
    //        //"\"IdExpirationDate\":\"2019-03-29T00:00:00+03:00\"," +
    //        //"\"IdDateOfIssue\":\"1980-03-29T00:00:00+03:00\"," +
    //        //"\"IdIssuedBy\":\"Romania\"," +
    //        //"\"IdPlaceofIssue\":\"Romania\"," +
    //        //"\"ReceiverAddress\":\"address\"," +
    //        //"\"ReceiverOccupationId\":3," +

    //        //"\"FormOfPaymentId\":\"CA\"," +
    //        //"\"ProofOfAddressCollected\":true," +
    //        //"\"KYCVerified\":false}";

    //        json = @"{" +
    //                 "\"status\": \"success\"," +
    //                 "\"message\": \"Success\"," +
    //                 "\"data\":" +
    //                 @"{" +
    //                 "\"invoiceNo\":\"111010000004038\",\"paymentAmount\":111010000004038,\"surchargeAmount\":0,\"dueDate\":\"24-08-2019\",\"customerCode\":\"0110102579717\",\"customerName\":\"MOST. FATEMA BEGUM\",\"applianceSummary\":\"D1\",\"connectionAddress\":\"DAG # 29, DOGAIR (NATUN PARA)\",\"mobile\":\"8801000000000\"} }";
    //        TtInstallmentInfo installment = jsonSerializer.Deserialize<TtInstallmentInfo>(json);
    //        DateTime? dueDate = null;
    //        if (installment.data.dueDate != "")
    //            dueDate = DateTime.ParseExact(installment.data.dueDate, "dd-MM-yyyy", CultureInfo.InvariantCulture);
    //        RefID = SaveCustomerInformation(RoutingCode, null, installment.data.customerCode, installment.data.customerName, installment.data.applianceSummery, installment.data.connectionAddress, installment.data.mobile, installment.data.paymentAmount, installment.data.surchargeAmount, null, dueDate, EmpID, "4");
    //        RtnMsg = RefID + "|" + json;

    //    }
    //    catch (WebException ex)
    //    {
    //        RtnMsg = RefID + "|" + ex.Message;
    //        Common.WriteLog("GetInstallmentInformation", ex.Message, "TITAS");

    //    }
    //    catch (Exception ex)
    //    {
    //        RtnMsg = RefID + "|" + ex.Message;
    //        Common.WriteLog("GetInstallmentInformation", ex.Message, "TITAS");

    //    }
    //    finally
    //    {

    //        Common.SaveReqResponseData(RefID, "GetInstallmentInformation", callDateTime, InvoiceNo, json, Http_Status, Http_Status, "TITAS", EmpID);

    //    }
    //    return RtnMsg;
    //}


    //[WebMethod(Description = "Service Task: Create new Payment with a specified Invoice No"
    // + "<br>" + "Returns:"
    // + "<br>" + "Response Code=1|refid: " + "Success"

    //)]
    //public string PostInstallmentPayment(
    //string RefID,
    //string InvoiceNo,
    //string RoutingNo,
    //string MobileNo,
    //string EmpID,
    //string KeyCode
    //)
    //{
    //    string TitasBaseUrl = getValueOfKey("TitasBaseUrl");
    //    string InvoiceUrl = TitasBaseUrl + "/bank/api/v1/installment/payments/";

    //    string http_response = "";
    //    string ReturnMsg = "";
    //    string token_ = "";
    //    string json = "";
    //    string Msg = "";

    //    DateTime callDateTime = DateTime.Now;
    //    try
    //    {

    //        if (RefID != "")
    //        {
    //            json = @"{" +
    //             "\"status\":\"success\"," +
    //             "\"message\":\"Success\"," +
    //             "\"data\":" +
    //             @"{" +
    //              "\"id\":24,\"bank\":\"AB BANK LTD.\",\"amount\":10300,\"surcharge\":10,\"total\":10310,\"voucherDate\":\"20/07/2017\",\"bankTransactionId\":\"123456000\",\"particulars\":\" \",\"batchNo\":\"11201707201459\"" +
    //             "}}";
    //            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

    //            TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

    //            if (paymentEntry.status.ToUpper() == "SUCCESS")
    //            {
    //                Msg = SaveCustomerPayment(paymentEntry, RefID, MobileNo, null, RoutingNo);
    //                ReturnMsg = "1|" + Msg;
    //            }

    //            //  token_ = CredEncrypt(getValueOfKey("TransfastSystemId"), getValueOfKey("TransfastUserName"), getValueOfKey("TransfastPassword"), getValueOfKey("TransfastBranchId"));
    //            //  comObj = GetComplainInvoiceToTransfast(RID, ErrorCode, Description);

    //            var bytes = Encoding.ASCII.GetBytes("");
    //            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
    //            request.PreAuthenticate = true;
    //            request.Headers.Add("Authorization", token_);
    //            request.Method = "POST";
    //            request.ContentType = "application/json";
    //            using (var requestStream = request.GetRequestStream())
    //            {
    //                requestStream.Write(bytes, 0, bytes.Length);
    //            }
    //            try
    //            {
    //                var response = (HttpWebResponse)request.GetResponse();
    //                http_response = response.StatusCode.ToString();

    //                var responseStream = response.GetResponseStream();
    //                if (responseStream != null)
    //                {
    //                    var myStreamReader = new StreamReader(responseStream, Encoding.Default);
    //                    json = myStreamReader.ReadToEnd();

    //                    responseStream.Close();
    //                    response.Close();

    //                    //JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

    //                    //TtPaymentEntry paymentEntry = jsonSerializer.Deserialize<TtPaymentEntry>(json);

    //                    if (paymentEntry.status.ToUpper() == "SUCCESS")
    //                    {
    //                        Msg = SaveCustomerPayment(paymentEntry, RefID, MobileNo, null, RoutingNo);
    //                        ReturnMsg = "1|" + Msg;
    //                    }
    //                    else
    //                        ReturnMsg = "0|" + paymentEntry.status;


    //                }

    //            }
    //            catch (WebException ex)
    //            {
    //                ReturnMsg = "0|" + ex.Message;
    //                Common.WriteLog("PostDemandNotePayment", ex.Message, "TITAS");

    //            }


    //            catch (Exception ex)
    //            {
    //                ReturnMsg = "0|" + ex.Message;
    //                Common.WriteLog("PostDemandNotePayment", ex.Message, "TITAS");

    //            }

    //        } // end if
    //        else
    //        {
    //            ReturnMsg = "0|Insert Fail to Payment Checkout";
    //        }



    //    }
    //    catch (Exception ex)
    //    {
    //        ReturnMsg = "0|" + ex.Message;
    //        Common.WriteLog("PostDemandNotePayment", ex.Message, "TITAS");

    //    }

    //    finally
    //    {
    //        Common.SaveReqResponseData(RefID, "PostDemandNotePayment", callDateTime, "", json, http_response, ReturnMsg, "TITAS", EmpID);
    //    }

    //    return Common.XmlText(ReturnMsg);
    //}


    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }




}

public struct TtCustomerInfo
{

    public string status { get; set; }
    public string message { get; set; }
    public TtData data { get; set; }
}

public struct TtData
{

    public string id { get; set; }
    public string customerCode { get; set; }
    public string customerName { get; set; }
    public string applianceSummary { get; set; }
    public string connectionAddress { get; set; }
    public string mobile { get; set; }

}

public struct TtPaymentEntry
{

    public string status { get; set; }
    public string message { get; set; }
    public TtPaymentData data { get; set; }
}

public struct TtPaymentData
{

    public string id { get; set; }
    public string bank { get; set; }
    public string batchNo { get; set; }
    public double amount { get; set; }
    public double surcharge { get; set; }
    public double total { get; set; }
    public string voucherDate { get; set; }
    public string particulars { get; set; }
    public string bankTransactionId { get; set; }

}

public struct TtDemandNote
{

    public string status { get; set; }
    public string message { get; set; }
    public TtDemandNoteData data { get; set; }
}

public struct TtDemandNoteData
{

    public string invoiceNo { get; set; }
    public string dueDate { get; set; }
    public double paymentAmount { get; set; }
    public string customerCode { get; set; }
    public string customerId { get; set; }

    public string customerName { get; set; }
    public string connectionAddress { get; set; }
    public string mobile { get; set; }

}

public struct TtDemandNoteHistory
{

    public string status { get; set; }
    public string message { get; set; }
    public TtPaymentData[] data { get; set; }
}

public struct TtInstallmentData
{
    public double paymentAmount { get; set; }
    public double surchargeAmount { get; set; }
    public string dueDate { get; set; }
    public string invoiceNo { get; set; }
    public string customerCode { get; set; }
    public string customerName { get; set; }
    public string applianceSummery { get; set; }
    public string connectionAddress { get; set; }
    public string mobile { get; set; }

}

public struct TtInstallmentInfo
{

    public string status { get; set; }
    public string message { get; set; }
    public TtInstallmentData data { get; set; }
}




