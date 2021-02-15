using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.Script.Serialization;

public partial class MerchantDataPush : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        this.Title = "Merchant Data Push #" + Request.QueryString["refid"];
        if(!IsPostBack)
        {
            AllowMerchantPush(Request.QueryString["refid"]);
        }
    }

    private void AllowMerchantPush(string RefID)
    {
        string Done = "";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_MerchantPushAllow";  
            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
              
                SqlParameter sqlDone = new SqlParameter("@AllowMerchantPush", SqlDbType.VarChar, 18);
                sqlDone.Direction = ParameterDirection.InputOutput;
                sqlDone.Value = "";
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();
                Done = string.Format("{0}", sqlDone.Value);
               
            }
        }

        if (Done == "1")
            btnPushData.Visible = true;
        else
            btnPushData.Visible = false;
    }

    protected void btnPushData_Click(object sender, EventArgs e)
    {
             

        try
        {
            DataTable CheckoutPaymentDT = new DataTable();
            using (SqlDataAdapter da = new SqlDataAdapter())
            {
                using (SqlConnection conn = new SqlConnection())
                {
                    string Query = "s_Checkout_Ref_Details";
                    conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = Query;
                        cmd.CommandType = System.Data.CommandType.StoredProcedure;
                        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = Request.QueryString["refid"];

                        cmd.Connection = conn;
                        if (conn.State == ConnectionState.Closed)
                            conn.Open();

                        da.SelectCommand = cmd;
                        da.Fill(CheckoutPaymentDT);
                    }
                }
            }

                    
            string TransactionID = "";
            string SenderMobile = "";
            string service_result = "";
            string MerchantID = "";
            string MerchantBrCode = "";
            string RefID = "";

            if (CheckoutPaymentDT.Rows.Count > 0)
            {
                TransactionID = CheckoutPaymentDT.Rows[0]["TransactionID"].ToString();
                SenderMobile = CheckoutPaymentDT.Rows[0]["SenderMobile"].ToString();
                MerchantID = CheckoutPaymentDT.Rows[0]["CheckoutMerchantID"].ToString();
                MerchantBrCode = CheckoutPaymentDT.Rows[0]["BranchCode"].ToString();
                RefID = CheckoutPaymentDT.Rows[0]["RefID"].ToString();
            }

            if (MerchantID == "BTCL")
            {
                service_result = UpdateDataToBtclServer(RefID, TransactionID, SenderMobile, MerchantBrCode);
                JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
                ResponseStatus[] paymentEntry = jsonSerializer.Deserialize<ResponseStatus[]>(service_result);
                service_result = paymentEntry[0].Responsecode;

            }
            else
            {
                TrustControl1.ClientMsg("Merchant " + MerchantID + " is not allowed to Push data.");
            }

            if (service_result == "1")
            {
                TrustControl1.ClientMsg("Payment has been updated to " + MerchantID + " Server Successfully.");
            }
            else
                TrustControl1.ClientMsg("Payment paid but has not been updated to " + MerchantID + " Server end.");
        }
        catch (Exception ex)
        {
            TrustControl1.ClientMsg("Payment paid but has not been updated to Server end. " + ex.Message);
        }
    }

    private string UpdateDataToBtclServer(string RefID, string TransactioID, string Mobile, string MerchantBrCode)
    {
        string retStatus = "";
        string SLMS_KeyCode = getValueOfKey("SLMS_KeyCode");

        try
        {
            WebReference_BTCL.BTCL_Payment btclPay = new WebReference_BTCL.BTCL_Payment();
            retStatus = btclPay.ConfirmBtclPayment_MB_OFF(RefID, SLMS_KeyCode, TransactioID, Mobile, MerchantBrCode);
        }
        catch (Exception ex)
        {
            Label1.Text = ex.Message;
            TrustControl1.ClientMsg(ex.Message);
        }
        return retStatus;
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception ex) { return string.Empty; }
    }

}

public struct ResponseStatus
{

    public string RefID { get; set; }
    public string Responsecode { get; set; }
    public string Message { get; set; }


}
