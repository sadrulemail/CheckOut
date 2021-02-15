using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using WebReference_mBillPlus;
using System.Web.Script.Serialization;

public partial class WestZonePayCancel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

     

        TrustControl1.getUserRoles();
        if(!TrustControl1.isRole("ADMIN"))
        {
            Response.End();
        }


        if (!IsPostBack)
        {

            labelTransId.Text = string.Format("{0}", Request.QueryString["transid"]);
            lblRefId.Text= string.Format("{0}", Request.QueryString["refid"]);
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


    protected void cmdOK_Click(object sender, EventArgs e)
    {
        string db_status = "";
        string db_used = "";
        string otc = "";
        Payment_Verify pay_verify = new Payment_Verify();
        DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(lblRefId.Text);
        if (dt_verify.Rows.Count > 0)
        {
            db_status = dt_verify.Rows[0]["Status"].ToString();
            db_used = dt_verify.Rows[0]["Used"].ToString();
            otc = dt_verify.Rows[0]["Meta5"].ToString();

        }
        else
        {
            TrustControl1.ClientMsg("Data Not Found");
            return;
        }
        if (db_status == "1" && db_used == "1" && otc == "1")
        {

            MbillPlus_payment mBill = new MbillPlus_payment();
            string status = mBill.Payment_Cancelled(lblRefId.Text, getValueOfKey("mBill_KeyCode"));
            PaymentCancelLog(status);
            if (status == "400")
            {
                PaymentCancel();
            }

            else
            {
                TrustControl1.ClientMsg(GetReconcileStatusMsg(status));
            }
        }
        else
        {
            PaymentCancel();
        }
    }


   

    private string GetReconcileStatusMsg(string status_code)
    {
        if (status_code == "420")
            return "Insert failed.";
        else if (status_code == "460")
            return "Data Mismatch.";
        else if (status_code == "409")
            return "Not Permitted for this action.";
        else if (status_code == "410")
            return "Mandatory Field NULL.";
        else
            return "";
    }

    private void PaymentCancel()
    {

        try
        {
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Checkout_Payment_Cancel_WZPDCL";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = lblRefId.Text;
                    cmd.Parameters.Add("@CancelBy", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                    cmd.Parameters.Add("@CancelReason", System.Data.SqlDbType.VarChar).Value = txtReason.Text;

                    SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    SQL_Msg.Direction = ParameterDirection.InputOutput;
                    SQL_Msg.Value = Msg;
                    cmd.Parameters.Add(SQL_Msg);

                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();

                    Msg = string.Format("{0}", SQL_Msg.Value);
                }
            }

          
            TrustControl1.ClientMsg(Msg);
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone s_Checkout_Payment_Cancel",
                           ex.Message);
        }
    }

    private void PaymentCancelLog(string status)
    {

        try
        {
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_mBill_Payment_Cancel_Log";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = lblRefId.Text;
                    cmd.Parameters.Add("@TransactionID", System.Data.SqlDbType.VarChar).Value = labelTransId.Text;
                    cmd.Parameters.Add("@CancelStatus", System.Data.SqlDbType.VarChar).Value = status;
                    cmd.Parameters.Add("@CancelBy", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                 
                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();

                                  }
            }


          //  TrustControl1.ClientMsg(Msg);
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone s_mBill_Payment_Cancel_Log",
                           ex.Message);
        }
    }
}


