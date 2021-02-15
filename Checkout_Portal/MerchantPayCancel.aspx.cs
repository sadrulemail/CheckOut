using System;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

public partial class MerchantPayCancel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {    

        TrustControl1.getUserRoles();
        //if(!TrustControl1.isRole("ADMIN"))
        //{
        //    Response.End();
        //}


        if (!IsPostBack)
        {

            labelTransId.Text = string.Format("{0}", Request.QueryString["transid"]);
            lblRefId.Text= string.Format("{0}", Request.QueryString["refid"]);
        }

        this.Title = "Merchant Payment Cancel";
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
        bool db_used = false;
        string otc = "";
        string CustomerPayID = "";
        string MerchantID = "";
        DateTime UsedDT=DateTime.Parse("1990-01-01");
        Payment_Verify pay_verify = new Payment_Verify();
        DataTable dt_verify = pay_verify.GetCheckout_Ref_Details(lblRefId.Text);


        if (dt_verify.Rows.Count > 0)
        {
            db_status = dt_verify.Rows[0]["Status"].ToString();
            db_used = (bool)dt_verify.Rows[0]["Used"];
            otc = dt_verify.Rows[0]["Meta5"].ToString();
            MerchantID = dt_verify.Rows[0]["CheckoutMerchantID"].ToString();
            //
            try
            {
                if(dt_verify.Rows[0]["UsedDT"].ToString()!="")
                UsedDT = (DateTime)dt_verify.Rows[0]["UsedDT"];
            }
            catch(Exception ex)
            { }
            CustomerPayID = dt_verify.Rows[0]["OrderID"].ToString();
        }
        else
        {
            TrustControl1.ClientMsg("Data Not Found");
            return;
        }
        if (MerchantID == "BTCL" && db_used && UsedDT.Date == DateTime.Now.Date)
        {
            string service_result = "";
            service_result = CancelToBtclServer(lblRefId.Text);
            if (service_result == "1")
            {
                TrustControl1.ClientMsg("Payment has been Canceled to " + MerchantID + " Server Successfully.");
                GridView1.DataBind();
            }
            else
                TrustControl1.ClientMsg("Payment Cancel Failed to " + MerchantID + " Server end.");
        }
        if (MerchantID == "TITAS" && db_status=="1")
        {
            string BillType = "";
            bool IsMeter = false;

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "SELECT top (1) BillType, IsMeter FROM [dbo].[TitasBillPayment] WITH (NOLOCK) WHERE RefID = '" + lblRefId.Text + "'";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.Connection = conn;
                    conn.Open();

                    SqlDataReader r = cmd.ExecuteReader();

                    while (r.Read())
                    {
                        BillType = string.Format("{0}", r["BillType"]);
                        IsMeter = (bool)r["IsMeter"];
                    }

                    r.Close();
                }
            }

            // call method for getting meter and payment id
            string ServiceResponse = "";
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();

            if (IsMeter)
            {
                WebReference_TitasMeter.TitasMBillPayment objTitasMeter = new WebReference_TitasMeter.TitasMBillPayment();
                ServiceResponse = objTitasMeter.DeleteMeterPayment(lblRefId.Text, CustomerPayID, txtReason.Text, Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));
            }
            else if (BillType == "1")
            {
                //Non-Metered Payment
                ServiceResponse = objTitasPay.DeletePaymentEntry(lblRefId.Text, CustomerPayID, txtReason.Text, Session["ROUTING"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode")); //"1337B4100011E2|Successfully Paid.";
            }
            if (BillType == "7")
            {
                //Demand
                ServiceResponse = objTitasPay.DeleteDemandNotePayment(lblRefId.Text, CustomerPayID, txtReason.Text, Session["ROUTING"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));
            }

            string StatusId = ServiceResponse.Split('|')[0];
            string Msg = ServiceResponse.Split('|')[1];

            if (StatusId == "1")
            {
                TrustControl1.ClientMsg("Payment has been Canceled to " + MerchantID + " Server Successfully.");
                GridView1.DataBind();              
            }
            else
            {
                TrustControl1.ClientMsg("Payment Cancel Failed to " + MerchantID + " Server. " + Msg);
            }
            //if (db_status == "1" && db_used == "1" && otc == "1")
            //{

            //    MbillPlus_payment mBill = new MbillPlus_payment();
            //    string status = mBill.Payment_Cancelled(lblRefId.Text, getValueOfKey("mBill_KeyCode"));
            //    PaymentCancelLog(status);
            //    if (status == "400")
            //    {
            //        PaymentCancel();
            //    }

            //    else
            //    {
            //        TrustControl1.ClientMsg(GetReconcileStatusMsg(status));
            //    }
            //}
            //else
            //{
            //    PaymentCancel();
            //}
        }
        else
            TrustControl1.ClientMsg("Payment Cancel Failed, Please try again.");

    }
    private string CancelToBtclServer(string RefID)
    {
        string retStatus = "";

        WebReference_BTCL.BTCL_Payment btclPay = new WebReference_BTCL.BTCL_Payment();
        retStatus = btclPay.BtclPaymentCancel(RefID, getValueOfKey("SLMS_KeyCode_Cancel"), Session["EMPID"].ToString(), txtReason.Text);
        return retStatus;
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


            TrustControl1.ClientMsg(Msg);
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone s_mBill_Payment_Cancel_Log",
                           ex.Message);
        }
    }
}


