using System;
using System.Data.SqlClient;
using System.Configuration;

public partial class Checkout_Payment_Verify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        string RefID = "";
        string OrderID = "";
        string Amount = "";


        RefID = string.Format("{0}", Request.Form["RefID"]);
        OrderID = string.Format("{0}", Request.Form["OrderID"]);
        Amount = string.Format("{0}", Request.Form["Amount"]);

        if (RefID.Length > 10
            && OrderID.Length > 0
            )
        {
            String done = "0";
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Payments_Checkout_Verify";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.VarChar).Value = Amount;
                    cmd.Parameters.Add("@isWebserviceCalled", System.Data.SqlDbType.Bit).Value = false;

                    SqlParameter sqlDone = new SqlParameter("@Done", System.Data.SqlDbType.TinyInt);
                    sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();
                    done = string.Format("{0}", sqlDone.Value);
                }
            }

            if (done == "1")
            {
                Response.Clear();
                Response.Write("1");
                Response.End();
                return;
            }
            Response.Clear();
            Response.Write("0");
            Response.End();
            return;
        }
        Response.Clear();
        Response.Write("Invalid Request");
        Response.End();
        return;
    }
}