<%@ WebService Language="C#" Class="TitasMBillPayment" %>

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
public class TitasMBillPayment : System.Web.Services.WebService
{

    [WebMethod(Description = "Service Task: Get Access Token (Bearer)"
  + "<br>" + "Returns:"
  + "<br>" + "Response Code=token"

)]
    public string GetAccessToken(
      string EmpID,
     string KeyCode
)
    {

        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";

        string json = "";
        DateTime callDateTime = DateTime.Now;
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        string token_ = "";
        //  string RtnMsg = "";

        try
        {
            token_ = GetAccessToken();

        }

        catch (Exception ex)
        {
            Common.WriteLog("GetAccessToken", ex.Message, "TITAS");
            token_ = "";
        }
        finally
        {
            Common.SaveReqResponseData("", "GetAccessToken", callDateTime, EmpID, json, null, null, "TITAS", EmpID);
        }
        return token_;
    }




    [WebMethod(Description = "Service Task: Get RefID with a specified Customer Code and Invoice"
     + "<br>" + "Returns:"
     + "<br>" + "-2: " + "Invalid KeyCode"
     + "<br>" + "Response Code=RefID|" + "json"

   )]
    public string GetMeterCustomer(
    string CustomerCode,
    string InvoiceNo,
    string RoutingNo,
    string EmpID,
    string KeyCode
    )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";

        string TitasBaseUrl = getValueOfKey("TitasMeterBaseUrl");
        string InvoiceUrl = TitasBaseUrl + "/metered/invoice/search?customerCode=" + CustomerCode + "&" + "invoiceNo=" + InvoiceNo;
        string Token = GetTokenFromDB("TITAS");
        string json = "";
        //  string CallRefID = Guid.NewGuid().ToString();
        DateTime callDateTime = DateTime.Now;

        string Http_Status = "";

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

        string RefID = "";

        string RtnMsg = "";

        try
        {
            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;

            myHttpWebRequest.Headers.Add("Authorization", "Bearer " + Token);
            // myHttpWebRequest.Headers.Add("Authorization", token);
            myHttpWebRequest.Accept = "application/json";
            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = myWebRequest.GetResponse();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();
                //  jsonText = string.Format("{0}", json);
                responseStream.Close();
                myWebResponse.Close();
                // JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TmCustomerSearch objCustomer = jsonSerializer.Deserialize<TmCustomerSearch>(json);
                if (objCustomer.status == "200")
                {
                    RefID = SaveCustomerInformation(objCustomer, RoutingNo, EmpID);

                }
                if (objCustomer.status == "403")
                {
                    GetAccessToken();

                }

            }

            RtnMsg = RefID + "|" + json;



        }
        catch (WebException ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();

            }
            json = Http_Status;
            Common.WriteLog("GetMeterCustomer", ex.Message, "TITAS");

        }

        catch (Exception ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            Common.WriteLog("GetMeterCustomer", ex.Message, "TITAS");

        }
        finally
        {

            Common.SaveReqResponseData(RefID, "GetMeterCustomer", callDateTime,"CustomerCode:"+ CustomerCode+",Url:"+InvoiceUrl+"Token:"+Token, json, Http_Status, Http_Status, "TITAS", EmpID);

        }
        return RtnMsg;
    }

    private string SaveCustomerInformation(TmCustomerSearch objCustomer, string RoutingNo, string EmpID)
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

                    cmd.Parameters.Add("@RoutingNo", System.Data.SqlDbType.VarChar).Value = RoutingNo;

                    cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = objCustomer.data.customerCode;
                    cmd.Parameters.Add("@CustomerName", System.Data.SqlDbType.VarChar).Value = objCustomer.data.customerName;

                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = objCustomer.data.invoiceAmount;


                    try
                    {
                        if (objCustomer.data.issueDate != "")
                            cmd.Parameters.Add("@IssueDate", System.Data.SqlDbType.Date).Value = DateTime.ParseExact(objCustomer.data.issueDate, "yyyyMMdd", CultureInfo.InvariantCulture);
                    }
                    catch (Exception ex)
                    { }
                    try
                    {
                        if (objCustomer.data.settleDate != "")
                            cmd.Parameters.Add("@SettleDate", System.Data.SqlDbType.Date).Value = DateTime.ParseExact(objCustomer.data.settleDate, "yyyyMMdd", CultureInfo.InvariantCulture);
                    }
                    catch (Exception ex)
                    { }
                    cmd.Parameters.Add("@InvoiceNo", System.Data.SqlDbType.VarChar).Value = objCustomer.data.invoiceNo;
                    cmd.Parameters.Add("@Zone", System.Data.SqlDbType.VarChar).Value = objCustomer.data.zone;
                    cmd.Parameters.Add("@BillType", System.Data.SqlDbType.VarChar).Value = "MeterBill";
                    cmd.Parameters.Add("@IsMeter", System.Data.SqlDbType.Bit).Value = 1;
                    cmd.Parameters.Add("@InsertBy", System.Data.SqlDbType.VarChar).Value = EmpID;

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

    [WebMethod(Description = "Service Task: Create new Payment with a specified Customer ID,invoice no etc"
     + "<br>" + "Returns:"
     + "<br>" + "-2: " + "Invalid KeyCode"
     + "<br>" + "Response Code=1|msg: " + "Success"

   )]
    public string PostMeterPayment(
 string RefID,
 string CustomerCode,
 string InvoiceNo,
 double PaidAmount,
 double SourceTaxAmount,
 double ReveStampAmount,
 string TransactionDate,
 string RoutingNo,
 string ChalanNo,
 string ChalanDate,
 string chalanBank,
 string chalanBranch,
 string EmpID,
 string KeyCode
 )
    {
        //if (KeyCode != getValueOfKey("Titas_KeyCode"))
        //    return "-2";
        string TitasBaseUrl = getValueOfKey("TitasMeterBaseUrl");
        string InvoiceUrl = TitasBaseUrl + "/metered/payment/add";
        string Token = GetTokenFromDB("TITAS");
        string http_response = "";
        string ReturnMsg = "";

        string json = "";
        string Msg = "";
        string Http_Status = "";
        string postData = "";
        DateTime callDateTime = DateTime.Now;
        try
        {

            if (RefID != "")
            {

                postData = "customerCode=" + CustomerCode;
                postData += "&invoiceNo=" + InvoiceNo;
                postData += "&paidAmount=" + PaidAmount;
                postData += "&sourceTaxAmount=" + SourceTaxAmount;
                postData += "&revenueStamp=" + ReveStampAmount;
                postData += "&transactionDate=" + TransactionDate;
                postData += "&branchRoutingNo=" + RoutingNo;
                postData += "&operator=" + EmpID;
                postData += "&refNo=" + RefID;
                if (SourceTaxAmount > 0)
                {
                    postData += "&chalanNo=" + ChalanNo;
                    postData += "&chalanDate=" + ChalanDate;
                    postData += "&chalanBank=" + chalanBank;
                    postData += "&chalanBranch=" + chalanBranch;
                }

                var request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
                var data = Encoding.ASCII.GetBytes(postData);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;
                request.Headers.Add("Authorization", "Bearer " + Token);

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

                if (Http_Status == "OK")
                {

                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                    TmCustomerPayment payment = jsonSerializer.Deserialize<TmCustomerPayment>(json);

                    if (payment.status.ToUpper() == "200")
                    {
                        Msg = SaveCustomerPayment(payment, RefID, RoutingNo);
                        ReturnMsg = "1|" + Msg;
                    }
                    else

                        ReturnMsg = "0|" + payment.message;


                }
                else
                {
                    ReturnMsg = "0|" + json;
                }
            }



        }
        catch (Exception ex)
        {
            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("PostMeterPayment", ex.Message, "TITAS");

        }

        finally
        {
            Common.SaveReqResponseData(RefID, "PostMeterPayment", callDateTime, postData, json, http_response, ReturnMsg, "TITAS", EmpID);
        }

        return Common.XmlText(ReturnMsg);
    }

    [WebMethod(Description = "Service Task: Delete Payment  with a specified Payment ID"
 + "<br>" + "Returns:"
 + "<br>" + "-2: " + "Invalid KeyCode"
 + "<br>" + "Response Code=1|msg" + "Success"

 )]
    public string DeleteMeterPayment(
 string RefID,
 string PaymentId,
 string CancelReason,
 string EmpID,
 string KeyCode
 )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";
        string TitasBaseUrl = getValueOfKey("TitasMeterBaseUrl");
        string InvoiceUrl = TitasBaseUrl + "/metered/payment/cancel";
        string Token = GetTokenFromDB("TITAS");
        string http_response = "";
        string ReturnMsg = "";

        string json = "";
        string Msg = "";
        string Http_Status = "";
        string postData = "";
        DateTime callDateTime = DateTime.Now;
        try
        {

            if (RefID != "")
            {

                postData = "paymentId=" + PaymentId;
                postData += "&operator=" + EmpID;
                postData += "&reason=" + CancelReason;

                var request = (HttpWebRequest)WebRequest.Create(InvoiceUrl);
                var data = Encoding.ASCII.GetBytes(postData);
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";
                request.ContentLength = data.Length;
                request.Headers.Add("Authorization", "Bearer " + Token);

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

                if (Http_Status == "OK")
                {

                    JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                    TmPaymentDelete payment = jsonSerializer.Deserialize<TmPaymentDelete>(json);

                    if (payment.status == "200")
                    {
                        Msg = CancelBillPayment(RefID, PaymentId, "success", CancelReason, EmpID);
                        ReturnMsg = "1|" + Msg;
                    }
                    else
                    {
                        CancelBillPayment(RefID, PaymentId, payment.status, CancelReason, EmpID);
                        ReturnMsg = "0|" + payment.message;
                    }


                }
                else
                {
                    ReturnMsg = "0|" + json;
                }
            }



        }
        catch (Exception ex)
        {
            ReturnMsg = "0|" + ex.Message;
            Common.WriteLog("DeleteMeterPayment", ex.Message, "TITAS");

        }

        finally
        {
            Common.SaveReqResponseData(RefID, "DeleteMeterPayment", callDateTime, postData, json, http_response, ReturnMsg, "TITAS", EmpID);
        }

        return Common.XmlText(ReturnMsg);
    }

    private string CancelBillPayment(string RefID, string PaymentID, string ResponseStatus, string Reason, string EmpID)
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
                    //  cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    //cmd.Parameters.Add("@SurCharge", System.Data.SqlDbType.Decimal).Value = Surcharge;

                    //cmd.Parameters.Add("@Particulars", System.Data.SqlDbType.VarChar).Value = Particulars;
                    //cmd.Parameters.Add("@BatchNo", System.Data.SqlDbType.VarChar).Value = BatchNo;
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

    private string SaveCustomerPayment(TmCustomerPayment ttPyment, string RefID, string RoutingCode)
    {
        string Msg = "";
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TitasMeterBillPayment_Paid";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = ttPyment.data.customerCode;
                    cmd.Parameters.Add("@InvoiceAmount", System.Data.SqlDbType.Decimal).Value = ttPyment.data.invoiceAmount;
                    cmd.Parameters.Add("@PaidAmount", System.Data.SqlDbType.Decimal).Value = ttPyment.data.paidAmount;
                    cmd.Parameters.Add("@SourceTaxAmount", System.Data.SqlDbType.Decimal).Value = ttPyment.data.sourceTaxAmount;
                    cmd.Parameters.Add("@ReveStamp", System.Data.SqlDbType.Decimal).Value = ttPyment.data.revenueStamp;

                    cmd.Parameters.Add("@PaymentId", System.Data.SqlDbType.VarChar).Value = ttPyment.data.paymentId;
                    cmd.Parameters.Add("@InvoiceNo", System.Data.SqlDbType.VarChar).Value = ttPyment.data.invoiceNo;

                    cmd.Parameters.Add("@TransactionStatus", System.Data.SqlDbType.Int).Value = ttPyment.data.transactionStatus;
                    cmd.Parameters.Add("@ChalanNo", System.Data.SqlDbType.VarChar).Value = ttPyment.data.chalanNo;
                    try
                    {
                        cmd.Parameters.Add("@ChalanDate", System.Data.SqlDbType.Date).Value = DateTime.ParseExact(ttPyment.data.chalanDate, "yyyyMMdd", CultureInfo.InvariantCulture);
                    }
                    catch (Exception)
                    { }
                    cmd.Parameters.Add("@ChalanBank", System.Data.SqlDbType.VarChar).Value = ttPyment.data.chalanBank;
                    cmd.Parameters.Add("@ChalanBranch", System.Data.SqlDbType.VarChar).Value = ttPyment.data.chalanBranch;
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
            Common.WriteLog("s_TitasMeterBillPayment_Paid", ex.Message, "TITAS");
        }
        return Common.XmlText(Msg);
    }

    [WebMethod(Description = "Service Task: Get Meter Payment List with a specified Transaction Date(mandatory), Customer Code and Invoice"
        + "<br>" + "Returns:"
        + "<br>" + "-2: " + "Invalid KeyCode"
        + "<br>" + "Response Code=RefID|" + "json"

      )]
    public string GetMeterPaymentList(
       string TransactionDate,
       string CustomerCode,
       string InvoiceNo,
       string TransactionStatus,
       string Zone,
       string RoutingNo,
       string EmpID,
       string KeyCode
       )
    {
        if (KeyCode != getValueOfKey("Titas_KeyCode"))
            return "-2";

        string TitasBaseUrl = getValueOfKey("TitasMeterBaseUrl");
        string InvoiceUrl = TitasBaseUrl + "/metered/payment/list?transactionDate=" + TransactionDate + "&" + "customerCode=" + CustomerCode + "&" + "invoiceNo=" + InvoiceNo + "&" + "transactionStatus=" + TransactionStatus + "&" + "zone=" + Zone + "&" + "branchRoutingNo=" + RoutingNo;
        string Token = GetTokenFromDB("TITAS");
        string json = "";
        string SessionId = Guid.NewGuid().ToString();
        DateTime callDateTime = DateTime.Now;
        string Http_Status = "";
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        string RefID = "";
        string RtnMsg = "";

        try
        {
            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;

            myHttpWebRequest.Headers.Add("Authorization", "Bearer " + Token);
            // myHttpWebRequest.Headers.Add("Authorization", token);
            myHttpWebRequest.Accept = "application/json";
            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = (HttpWebResponse)myWebRequest.GetResponse();
            // var response = (HttpWebResponse)request.GetResponse();
            Http_Status = myWebResponse.StatusCode.ToString();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();
                //  jsonText = string.Format("{0}", json);
                responseStream.Close();
                myWebResponse.Close();
                // JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TmCustomerPaymentList objPayList = jsonSerializer.Deserialize<TmCustomerPaymentList>(json);

                if (objPayList.status == "200")
                {
                    int isSave = SaveBulkPaymentList(SessionId, objPayList.data.transactions, EmpID);
                    if (isSave == 1)
                        RtnMsg = 1 + "|" + SessionId;
                    else
                        RtnMsg = 0 + "|" + "No data found.";
                }
                else
                    RtnMsg = 0 + "|" + objPayList.message;

            }

            // RtnMsg = RefID + "|" + json;



        }
        catch (WebException ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            if (ex.Status == WebExceptionStatus.ProtocolError)
            {
                Http_Status = ((HttpWebResponse)ex.Response).StatusCode.ToString();

            }
            json = Http_Status;
            Common.WriteLog("GetMeterCustomer", ex.Message, "TITAS");

        }

        catch (Exception ex)
        {
            RtnMsg = RefID + "|" + ex.Message;
            Common.WriteLog("GetMeterCustomer", ex.Message, "TITAS");

        }
        finally
        {

            Common.SaveReqResponseData(RefID, "GetMeterCustomer", callDateTime, TransactionDate, Http_Status, Http_Status, Http_Status, "TITAS", EmpID);

        }
        return RtnMsg;
    }

    private int SaveBulkPaymentList(string SessionId, TmPaymentData[] dataList, string EmpID)
    {
        int IsSave = 0;
        DataTable dt_mtr = new DataTable();
        dt_mtr.Columns.Add("SessionID", typeof(string));
        dt_mtr.Columns.Add("PaymentID", typeof(string));
        dt_mtr.Columns.Add("TransactionDate", typeof(DateTime));
        dt_mtr.Columns.Add("CustomerCode", typeof(string));
        dt_mtr.Columns.Add("InvoiceNo", typeof(string));
        dt_mtr.Columns.Add("InvoiceAmount", typeof(double));
        dt_mtr.Columns.Add("PaidAmount", typeof(double));

        dt_mtr.Columns.Add("SourceTaxAmount", typeof(double));
        dt_mtr.Columns.Add("RevenueStamp", typeof(double));
        dt_mtr.Columns.Add("RoutingNo", typeof(string));
        dt_mtr.Columns.Add("Zone", typeof(string));
        dt_mtr.Columns.Add("TransactionStatus", typeof(int));

        dt_mtr.Columns.Add("InsertBy", typeof(string));
        dt_mtr.Columns.Add("InsertDT", typeof(DateTime));
        DateTime? voucherDT = null;
        try
        {

            foreach (TmPaymentData row in dataList)
            {

                dt_mtr.Rows.Add(SessionId,row.paymentId,DateTime.ParseExact( row.transactionDate,"yyyyMMdd",CultureInfo.InvariantCulture), row.customerCode, row.invoiceNo, row.invoiceAmount, row.paidAmount, row.sourceTaxAmount, row.revenueStamp, row.branchRoutingNo, row.zone, row.transactionStatus,EmpID, DateTime.Now);

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
                        bulkCopy.DestinationTableName = "TitasMeterPayReconsilation";
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

    private string GetAccessToken()
    {
        string token = "";
        string TitasBaseUrl = getValueOfKey("TitasMeterBaseUrl");
        string InvoiceUrl = TitasBaseUrl + "/access_token";
        string username = getValueOfKey("Titas_Meter_User");
        string password = getValueOfKey("Titas_Meter_Secret");

        string json = "";
        bool done = false;
        try
        {

            var myUri = new Uri(InvoiceUrl);
            var myWebRequest = WebRequest.Create(myUri);
            var myHttpWebRequest = (HttpWebRequest)myWebRequest;
            myHttpWebRequest.PreAuthenticate = true;
            string encoded = Convert.ToBase64String(ASCIIEncoding.ASCII.GetBytes(username + ":" + password));
            myHttpWebRequest.Headers.Add("Authorization", "Basic " + encoded);
            // myHttpWebRequest.Headers.Add("Authorization", token);
            myHttpWebRequest.Accept = "application/json";
            // myWebRequest.Method = "PUT"; //for download invoice
            var myWebResponse = myWebRequest.GetResponse();
            var responseStream = myWebResponse.GetResponseStream();
            if (responseStream != null)
            {
                var myStreamReader = new StreamReader(responseStream, Encoding.Default);
                json = myStreamReader.ReadToEnd();
                //  jsonText = string.Format("{0}", json);
                responseStream.Close();
                myWebResponse.Close();
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();

                TmAccessToken objToken = jsonSerializer.Deserialize<TmAccessToken>(json);
                if (objToken.status == "200")
                {
                    done = SaveAccessToken("TITAS", objToken.data.access_token);

                    if (done)
                        token = objToken.data.access_token;
                    else
                        token = "";
                }


            }

        }
        catch (WebException ex)
        {

            //TfBusinessErrors errorObj = GetTfBussinessError(e);
            //RemilistStatus = errorObj.Message + "-" + errorObj.ErrorCode;
            Common.WriteLog("GetAccessToken", ex.Message, "TITAS");
        }

        catch (Exception ex)
        {
            Common.WriteLog("GetAccessToken", ex.Message, "TITAS");
            token = "";
        }
        return token;
    }


    private string GetTokenFromDB(string MerchantID)
    {
        string Token = "";

        try
        {

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_GetAccessToken";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;

                    SqlParameter sqlToken = new SqlParameter("@Token", SqlDbType.VarChar, -1);
                    sqlToken.Direction = ParameterDirection.InputOutput;
                    sqlToken.Value = " ";
                    cmd.Parameters.Add(sqlToken);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Token = string.Format("{0}", sqlToken.Value);
                }
            }


        }
        catch (Exception ex)
        {
            Common.WriteLog("GetTokenFromDB", ex.Message, "TITAS");
        }

        return Token;
    }

    private bool SaveAccessToken(string MerchantID, string Token)
    {
        bool Done = false;

        try
        {

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_AccessToken_InsertUpdate";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = MerchantID;
                    cmd.Parameters.Add("@Token", System.Data.SqlDbType.VarChar).Value = Token;

                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Done = (bool)sqlDone.Value;
                }
            }


        }
        catch (Exception ex)
        {
            Common.WriteLog("SaveAccessToken", ex.Message, "TITAS");
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

public struct TmAccessToken
{

    public string status { get; set; }
    public string message { get; set; }
    public TmTokenData data { get; set; }
}

public struct TmTokenData
{
    public string creator { get; set; }
    public string creationTime { get; set; }
    public string access_token { get; set; }
    public long expires_in { get; set; }
    public string token_type { get; set; }
    public string[] scope { get; set; }


}

public struct TmCustomerSearch
{

    public string status { get; set; }
    public string message { get; set; }
    public TmCustomerData data { get; set; }
}

public struct TmCustomerData
{

    public string invoiceNo { get; set; }
    public string customerCode { get; set; }
    public string customerName { get; set; }
    public double invoiceAmount { get; set; }

    public string issueMonth { get; set; }
    public string issueDate { get; set; }
    public string settleDate { get; set; }
    public string zone { get; set; }

}
public struct TmCustomerPaymentList
{
    public string status { get; set; }
    public string message { get; set; }
    public TmData data { get; set; }


}

public struct TmData
{
    public TmPaymentData[] transactions { get; set; }

}


public struct TmCustomerPayment
{
    public string status { get; set; }
    public string message { get; set; }
    public TmPaymentData data { get; set; }

}

public struct TmPaymentData
{
    public string paymentId { get; set; }
    public string customerCode { get; set; }
    public string transactionDate { get; set; }
    public int transactionStatus { get; set; }
    public string invoiceNo { get; set; }

    public double invoiceAmount { get; set; }
    public double paidAmount { get; set; }
    public double sourceTaxAmount { get; set; }
    public double revenueStamp { get; set; }

    public string bankCode { get; set; }
    public string branchCode { get; set; }
    public string branchRoutingNo { get; set; }
    public string zone { get; set; }
    public string chalanNo { get; set; }
    public string chalanDate { get; set; }
    public string chalanBank { get; set; }
    public string chalanBranch { get; set; }

}

public struct TmPaymentDelete
{

    public string status { get; set; }
    public string message { get; set; }
    public string data { get; set; }
}

//public struct TtInstallmentData
//{
//    public double paymentAmount { get; set; }
//    public double surchargeAmount { get; set; }
//    public string dueDate { get; set; }
//    public string invoiceNo { get; set; }
//    public string customerCode { get; set; }
//    public string customerName { get; set; }
//    public string applianceSummery { get; set; }
//    public string connectionAddress { get; set; }
//    public string mobile { get; set; }

//}

//public struct TtInstallmentInfo
//{

//    public string status { get; set; }
//    public string message { get; set; }
//    public TtInstallmentData data { get; set; }
//}




