using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

public partial class TestPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));
            
            //txtEnrolmentDate.Text = DateTime.Now.ToString("dd/MM/yyyy");

        }

    }
    protected void cmdSubmit2_Click(object sender, EventArgs e)
    {
        

        string Msg = "";
        string Amount = "0";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_REB_Get_Bill_Amount";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@BillNumber", System.Data.SqlDbType.VarChar, 50).Value = txtName.Text.Trim();

                SqlParameter sqlAmount = new SqlParameter("@Amount", SqlDbType.Money);
                sqlAmount.Direction = ParameterDirection.InputOutput;
                sqlAmount.Value = 0;
                cmd.Parameters.Add(sqlAmount);


                SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                sqlMsg.Direction = ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                Amount = string.Format("{0:N2}", sqlAmount.Value);
                Msg = sqlMsg.Value.ToString();
            }
        }

        if (Msg != "1")
            lblLabel.Text = Msg;
        else
        {
            lblLabel.Text = Amount;
            txtName.Enabled = false;
            cmdSubmit2.Visible = false;
            cmdPay.Visible = true;
        }        
    }

    protected void cmdPay_Click(object sender, EventArgs e)
    {
        string Msg = "";
        string Amount = "0";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_REB_Mark_As_Paid";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@BillNumber", System.Data.SqlDbType.VarChar, 50).Value = txtName.Text;
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Money).Value = lblLabel.Text;
                cmd.Parameters.Add("@AccountNo", System.Data.SqlDbType.VarChar).Value = Common.getRandomNumber(10);
                cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = Common.getRandomNumber(15);
                cmd.Parameters.Add("@PaymentType", System.Data.SqlDbType.VarChar).Value = "MB_OFF";


                SqlParameter sqlMsg = new SqlParameter("@Msg", SqlDbType.VarChar, 10);
                sqlMsg.Direction = ParameterDirection.InputOutput;
                sqlMsg.Value = "";
                cmd.Parameters.Add(sqlMsg);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();

                Msg = sqlMsg.Value.ToString();
            }
        }

        lblLabel2.Text = Msg;

        if (Msg == "1")
            cmdPay.Visible = false;
    }
}