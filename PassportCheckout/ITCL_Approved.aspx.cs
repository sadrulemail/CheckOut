using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

public partial class ITCL_Approved : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    //    //if (string.Format("{0}", Request.QueryString["ORDERID"]) != "")
    //    //{
    //    //    Label1.Text = string.Format("OrderID: {0}<br>SessionID: {1}", Request.QueryString["ORDERID"], Request.QueryString["SESSIONID"]);
    //    //    Label1.Text += string.Format("<br><br>ResponseCode:{0}<br>OrderStatus:{1}", Request.Form["ResponseCode"], Request.Form["OrderStatus"]);
    //    //    this.Form.Action = string.Format("https://testmpi.itcbd.com:2222/index.jsp?ORDERID={0}&SESSIONID={1}"
    //    //        , Request.QueryString["ORDERID"], Request.QueryString["SESSIONID"]);
    //    //}

    //    string PageUrl = "";
    //    string Keycode = "";
    //    string Referrer = "";
    //    bool visible = false;
        
        
    //    try
    //    {
    //        Referrer = string.Format("{0}", Request.ServerVariables["HTTP_ORIGIN"]);
    //        //Response.Write(Referrer);
    //        Label1.Text = Referrer;
    //        Common.WriteLog(Request.Url.OriginalString, "Referrer:" + Referrer);
    //    }
    //    catch (Exception ex) { Label1.Text = ex.Message; }

    //    PageUrl = Request.Url.OriginalString.Split('?')[0];
        
    //    SqlConnection.ClearAllPools();

    //    using (SqlConnection conn = new SqlConnection())
    //    {
    //        string Query = "s_Checkout_Path_Check";
    //        conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

    //        using (SqlCommand cmd = new SqlCommand())
    //        {
    //            cmd.CommandText = Query;
    //            cmd.CommandType = System.Data.CommandType.StoredProcedure;
    //            cmd.Parameters.Add("@PageUrl", System.Data.SqlDbType.VarChar).Value = PageUrl;
    //            cmd.Parameters.Add("@Keycode", System.Data.SqlDbType.VarChar).Value = Keycode;

    //            cmd.Connection = conn;
    //            conn.Open();

    //            using (SqlDataReader sdr = cmd.ExecuteReader())
    //            {
    //                while (sdr.Read())
    //                {
    //                    string sql_Referrer = sdr["Referrer"].ToString();
    //                    if (Referrer.ToLower().StartsWith(sql_Referrer.ToLower()) || sql_Referrer == "")
    //                    {
    //                        visible = true;
    //                    }
    //                }
    //            }
    //        }
    //    }

    //    if (!visible)
    //    {
    //        Response.Clear();
    //        Response.Write("Invalid Request<br>Referer: " + Referrer);
    //        Common.WriteLog(PageUrl, PageUrl);
    //        Response.End();
    //    }

    //    try
    //    {
    //        using (SqlConnection conn = new SqlConnection())
    //        {
    //            string Query = "s_ITCL_Response_Insert";
    //            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

    //            using (SqlCommand cmd = new SqlCommand())
    //            {
    //                cmd.CommandText = Query;
    //                cmd.CommandType = System.Data.CommandType.StoredProcedure;

    //                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = Request.Form["OrderID"];
    //                cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = Request.Form["TransactionType"];
    //                cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = Request.Form["Currency"];
    //                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = decimal.Parse(Request.Form["Amount"].ToString()) / 100;
    //                cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = Request.Form["ResponseCode"];
    //                cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value = Request.Form["ResponseDescription"];
    //                cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = Request.Form["OrderStatus"];
    //                cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = Request.Form["ApprovalCode"];
    //                cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = Request.Form["PAN"];

    //                cmd.Connection = conn;
    //                conn.Open();

    //                if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

    //                cmd.ExecuteNonQuery();
    //            }
    //        }
    //    }
    //    catch (Exception ex) { Label1.Text += "<br>" + ex.Message; }

    //    Label1.Text += "<br>" + string.Format("{0}", Request.Form["xmlmsg"]);
    }
}