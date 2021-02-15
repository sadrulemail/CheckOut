<%@ WebHandler Language="C#" Class="Passport_Payment_Receipt" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public class Passport_Payment_Receipt : IHttpHandler 
{    
    public void ProcessRequest (HttpContext context) 
    {
        string RefRefID = "";
        string KeyCode = "";
        bool hasFile = false;
        
        try
        {
            RefRefID = string.Format("{0}", context.Request.QueryString["refid"]);
            KeyCode = string.Format("{0}", context.Request.QueryString["key"]);        
        }
        catch (Exception)
        {
            //context.Response.StatusCode = 404;
            throw new HttpException(404, "Not Found");
        }
        try
        {
            if (context.Request.UrlReferrer.Host != context.Request.Url.Host)
            {
                EndWithResponse(context, "Receipt Print", "Unauthorized Acccess");
                return;
            }
            
        }
        catch (Exception) 
        { 
            EndWithResponse(context, "Receipt Print", "Unauthorized Acccess");
            return;
        }
        
        SqlConnection.ClearAllPools();
        //string FileName = "";
        byte []  output = null;
        string Msg = "";
        
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Passport_Payment_Print";

            conn.ConnectionString = System.Configuration.ConfigurationManager
                            .ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
            
            //if (conn.State == ConnectionState.Closed) conn.Open();

            using (SqlCommand cmd = new SqlCommand(Query, conn))
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefRefID;
                cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar).Value = KeyCode;

                SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                SQL_Msg.Direction = ParameterDirection.InputOutput;
                SQL_Msg.Value = Msg;

                cmd.Parameters.Add(SQL_Msg);
                
                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {                    
                    if (sdr.HasRows)
                    {
                        hasFile = true;
                        while (sdr.Read())
                        {                            
                            Passport_Receipt.Receipt r = new Passport_Receipt.Receipt();
                            output = r.getReceiptBytesFromCrystalReport(
                                  sdr["RefID"].ToString(),
                                  double.Parse(sdr["TotalAmount"].ToString()),
                                  sdr["FullName"].ToString(),
                                  sdr["PdfFileKeycodes"].ToString()
                                  );
                        }
                    }                    
                }
                Msg = string.Format("{0}", SQL_Msg.Value);
            }
        }

        if (hasFile)
        {
            context.Response.Clear();
            context.Response.AddHeader("content-disposition", "inline; filename=\"" + RefRefID + ".pdf\"");
            context.Response.AddHeader("content-length", output.Length.ToString());
            context.Response.ContentType = "application/pdf";
            context.Response.AddHeader("Pragma", "public");
            context.Response.AddHeader("X-Content-Type-Options", "nosniff");
            context.Response.AddHeader("X-Download-Options", "noopen");
            context.Response.BinaryWrite(output);
            context.Response.Flush();
            context.Response.Close();
        }
        else
        {
            string ErrorMsg = Msg;
            EndWithResponse(context, "Receipt Print", Msg + "<br><br><br><a class='Button' href='Passport_Payment_Receipt.aspx'>Try Another</a>");
        }
    }

    private static void EndWithResponse(HttpContext context, string _Title, string _Msg)
    {
        context.Response.ContentType = "text/html";
        context.Response.Write(Common.getHTML(_Title, _Msg, "Receipt.png", "450px"));
    }
 
    public bool IsReusable 
    {
        get {
            return false;
        }
    }
}