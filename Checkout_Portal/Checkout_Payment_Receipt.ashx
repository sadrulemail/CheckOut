<%@ WebHandler Language="C#" Class="Checkout_Payment_Receipt" %>

using System;
using System.Web;
using System.IO;
using System.Data.SqlClient;
using System.Data;

public class Checkout_Payment_Receipt : IHttpHandler
{
    public void ProcessRequest (HttpContext context)
    {
        string RefRefID = "";
        string MerchantID = "";
        string KeyCode = "";
        bool hasFile = false;

        try
        {
            RefRefID = string.Format("{0}", context.Request.QueryString["refid"]);
            KeyCode = string.Format("{0}", context.Request.QueryString["key"]);
            MerchantID = string.Format("{0}", context.Request.QueryString["merid"]);
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

        //if (MerchantID == "NID")
        //{

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Checkout_Payment_Receipt_Print";

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
                        Checkout_Receipt.CheckoutReceipt r = new Checkout_Receipt.CheckoutReceipt();
                        Checkout_Receipt.CheckoutParams cpram = new Checkout_Receipt.CheckoutParams();
                        hasFile = true;
                        while (sdr.Read())
                        {


                            if (sdr["MarchentID"].ToString() == "NID")
                            {


                                output = r.getNIDReceiptBytesFromCrystalReport(
                                      sdr["RefID"].ToString(),
                                      double.Parse(sdr["TotalAmount"].ToString()),
                                         double.Parse(sdr["Amount"].ToString()),
                                          double.Parse(sdr["TotalVatAmount"].ToString()),
                                      sdr["FullName"].ToString(),
                                      sdr["Meta1"].ToString(),
                                      sdr["M2_Description_Ban"].ToString(),
                                      sdr["M3_Description_Ban"].ToString(),
                                      sdr["TakaInWord_Eng"].ToString(),
                                      sdr["KeyCode"].ToString()
                                      );
                            }
                            else
                            {
                                cpram.Meta1_Printable = Boolean.Parse(sdr["Meta1_Printable"].ToString());
                                cpram.Meta2_Printable = Boolean.Parse(sdr["Meta2_Printable"].ToString());
                                cpram.Meta3_Printable = Boolean.Parse(sdr["Meta3_Printable"].ToString());
                                cpram.Meta4_Printable = Boolean.Parse(sdr["Meta4_Printable"].ToString());
                                cpram.Meta5_Printable = Boolean.Parse(sdr["Meta5_Printable"].ToString());

                                cpram.RefID = sdr["RefID"].ToString();
                                cpram.Amount = double.Parse(sdr["ReturnAmount"].ToString());
                                cpram.Fees = double.Parse(sdr["Amount"].ToString());
                                cpram.Vat = double.Parse(sdr["TotalVatAmount"].ToString());
                                cpram.ServiceCharge = double.Parse(sdr["TotalServiceCharge"].ToString());
                                cpram.InterestAmount = double.Parse(sdr["TotalInterestAmount"].ToString());
                                cpram.FullName = sdr["FullName"].ToString();
                                cpram.Email = sdr["Email"].ToString();
                                cpram.MerchantName = sdr["MarchentName"].ToString();
                                cpram.MerchantCompanyURL = sdr["MarchentCompanyURL"].ToString();
                                cpram.OrderNo = sdr["OrderID"].ToString();
                                cpram.TakaInWord_Eng = sdr["TakaInWord_Eng"].ToString();
                                cpram._Keywords = sdr["KeyCode"].ToString();
                                cpram.PaymentDT = DateTime.Parse(sdr["InsertDT"].ToString());

                                cpram.Meta1_label = sdr["Meta1_Label"].ToString();
                                cpram.Meta1 = sdr["Meta1"].ToString();
                                if (!cpram.Meta1_Printable)
                                {
                                    cpram.Meta1_label = "";
                                    cpram.Meta1 = "";

                                }
                                cpram.Meta2_label = sdr["Meta2_Label"].ToString();
                                cpram.Meta2 = sdr["Meta2"].ToString();
                                if (!cpram.Meta2_Printable)
                                {
                                    cpram.Meta2_label = "";
                                    cpram.Meta2 = "";
                                }

                                cpram.Meta3_label = sdr["Meta3_Label"].ToString();
                                cpram.Meta3 = sdr["Meta3"].ToString();
                                if (!cpram.Meta3_Printable)
                                {
                                    cpram.Meta3_label = "";
                                    cpram.Meta3 = "";
                                }
                                cpram.Meta4_label = sdr["Meta4_Label"].ToString();
                                cpram.Meta4 = sdr["Meta4"].ToString();
                                if (!cpram.Meta4_Printable)
                                {
                                    cpram.Meta4_label = "";
                                    cpram.Meta4 = "";

                                }
                                cpram.Meta5_label = sdr["Meta5_Label"].ToString();
                                cpram.Meta5 = sdr["Meta5"].ToString();
                                if (!cpram.Meta5_Printable)
                                {
                                        cpram.Meta5_label = "";
                                        cpram.Meta5 = "";
                                }
                                output = r.getCheckoutReceiptBytesFromCrystalReport(cpram);
                              
                                //output = r.getCheckoutReceiptBytesFromCrystalReport(
                                //    sdr["RefID"].ToString(),
                                //    double.Parse(sdr["TotalAmount"].ToString()),
                                //       double.Parse(sdr["Amount"].ToString()),
                                //        double.Parse(sdr["TotalVatAmount"].ToString()),
                                //    sdr["FullName"].ToString(),
                                //    sdr["MarchentName"].ToString(),
                                //    sdr["MarchentCompanyURL"].ToString(),
                                //    sdr["OrderID"].ToString(),
                                //    sdr["TakaInWord_Eng"].ToString(),
                                //    sdr["KeyCode"].ToString()
                                //    );

                            }
                        }
                    }
                }
                Msg = string.Format("{0}", SQL_Msg.Value);
            }
        }
        //}
        //else
        //{
        //    EndWithResponse(context, "Receipt Print", "Receipt printing of this merchant is under construction.");
        //    return;

        //}

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
            EndWithResponse(context, "Receipt Print", Msg);
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