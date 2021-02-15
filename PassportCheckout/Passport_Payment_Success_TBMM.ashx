<%@ WebHandler Language="C#" Class="Passport_Payment_Success_TBMM" %>

using System;
using System.Web;
using System.Data.SqlClient;

public class Passport_Payment_Success_TBMM : IHttpHandler
{
    //string RefID = "";
    //string TransactionID = "";
    //string Status = "";
    //string Referrer = "";
    //string PageUrl = "";
    //string Keycode = "";
    //string PaymentType = "";
    //string PAN = "";
    //string OrderID = "";
    
    public void ProcessRequest (HttpContext context) {

        //RefID = string.Format("{0}", context.Request.Form["application_id"]);
        //if (RefID == "") RefID = string.Format("{0}", context.Request.QueryString["application_id"]);

        //TransactionID = string.Format("{0}", context.Request.Form["transaction_id"]);
        //if (TransactionID == "") TransactionID = string.Format("{0}", context.Request.QueryString["transaction_id"]);

        //Status = string.Format("{0}", context.Request.Form["status"]);
        //if (Status == "") Status = string.Format("{0}", context.Request.QueryString["status"]);

        //Keycode = string.Format("{0}", context.Request.Form["keycode"]);
        //if (Keycode == "") Keycode = string.Format("{0}", context.Request.QueryString["keycode"]);

        //string PageUrl = context.Request.Url.OriginalString.Split('?')[0];
        //string Referrer = "";
        ////string Referrer = HttpContext.Current.Request.ServerVariables["HTTP_HOST"].ToString();
        //try
        //{
        //    Referrer = string.Format("{0}", context.Request.UrlReferrer.AbsoluteUri);
        //    Common.WriteLog(context.Request.Url.OriginalString, "Referrer:" + Referrer);
        //}
        //catch (Exception) { }

        //Common.WriteLog(context.Request.Url.OriginalString, "PageUrl:" + PageUrl);
        //Common.WriteLog(context.Request.Url.OriginalString, "Referrer:" + Referrer);
        
        //System.Data.SqlClient.SqlConnection.ClearAllPools();
        //bool isSaved = false;
        //bool visible = false;

        //using (SqlConnection conn = new SqlConnection())
        //{
        //    string Query = "s_Checkout_Path_Check";
        //    conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

        //    using (SqlCommand cmd = new SqlCommand())
        //    {
        //        cmd.CommandText = Query;
        //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
        //        cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;
        //        cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = "MB";

        //        cmd.Connection = conn;
        //        conn.Open();

        //        using (SqlDataReader sdr = cmd.ExecuteReader())
        //        {
        //            while (sdr.Read())
        //            {
        //                if (!sdr.HasRows)
        //                {
        //                    Common.WriteLog(context.Request.Url.OriginalString, "-2_PageURL=" + PageUrl);
        //                    Common.WriteLog(context.Request.Url.OriginalString, "-2_Keycode=" + Keycode);
        //                    Common.WriteLog(context.Request.Url.OriginalString, "-2_PaymentType=" + PaymentType);
        //                    Common.WriteLog(context.Request.Url.OriginalString, "-2_Referrer=" + Referrer);

        //                    visible = false;
        //                }
        //                else
        //                {
        //                    visible = true;
        //                }
        //            }
        //        }
        //    }
        //}


        //if (visible)
        //{
        //    try
        //    {
        //        using (System.Data.SqlClient.SqlConnection conn = new SqlConnection())
        //        {
        //            string Query = "s_TBMM_Response_Insert";
        //            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

        //            using (System.Data.SqlClient.SqlCommand cmd = new SqlCommand())
        //            {
        //                cmd.CommandText = Query;
        //                cmd.CommandType = System.Data.CommandType.StoredProcedure;

        //                cmd.Parameters.Add("@transaction_id", System.Data.SqlDbType.VarChar).Value = TransactionID;
        //                cmd.Parameters.Add("@application_id", System.Data.SqlDbType.VarChar).Value = RefID;
        //                cmd.Parameters.Add("@BillingCode", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", context.Request.Form["BillingCode"]);
        //                cmd.Parameters.Add("@success", System.Data.SqlDbType.VarChar).Value = string.Format("{0}", context.Request.Form["success"]);
        //                cmd.Parameters.Add("@status", System.Data.SqlDbType.VarChar).Value = Status;
                        
        //                cmd.Connection = conn;
                        
        //                if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

        //                cmd.ExecuteNonQuery();
        //                isSaved = true;

        //            }
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        Common.WriteLog(context.Request.Url.OriginalString, "Error:" + ex.Message);
        //        isSaved = false;
        //    }
        //}
        


        context.Response.ContentType = "text/plain";
        //if (isSaved && visible)
            context.Response.Write("1");        
        //else        
        //    context.Response.Write("0");        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }
}