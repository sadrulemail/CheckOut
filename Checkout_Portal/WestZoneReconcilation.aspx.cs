using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using WebReference_mBillPlus;
using System.Web.Script.Serialization;

public partial class WestZoneReconcilation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

     

        TrustControl1.getUserRoles();


        if (!IsPostBack)
        {

           txtPayDate.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
          // txtPayDate.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Today.AddDays(-1));
            string pageId = string.Format("{0}", Request.QueryString["pageid"]);
            try
            {
                if(pageId!="")
                Guid.Parse(pageId);
            }
            catch(Exception ex)
            {
                Response.Clear();
                Response.Write("Wrong pageid.");
                Response.End();
            }
           

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
        try
        {
            MbillPlus_payment mBill = new MbillPlus_payment();
            string Page_ID = mBill.Reconcile_Summary(txtPayDate.Text, getValueOfKey("mBill_KeyCode"), int.Parse(ddlOtc.SelectedValue), Session["EMPID"].ToString());

            Response.Redirect("WestZoneReconcilation.aspx?pageid=" + Page_ID.Trim(), true);
            return;
        }
        catch(Exception ex)
        {
            TrustControl1.ClientMsg("Wrong Pageid");
        }
    }

    protected void btnDetails_Click(object sender, EventArgs e)
    {
        MbillPlus_payment mBill = new MbillPlus_payment();
        string Page_ID = mBill.Reconcile_Details(txtPayDate.Text, getValueOfKey("mBill_KeyCode"), ddlOtc.SelectedValue, Session["EMPID"].ToString());

        Response.Redirect("WestZoneReconDetail.aspx?pageid=" + Page_ID.Trim(), true);
        return;
    }

    // cmdExport.Visible = (GridView1.Rows.Count > 0);


    protected void GridViewReconcileSummary_DataBound(object sender, EventArgs e)
    {
        btnReconsConfirm.Visible = (GridViewReconcileSummary.Rows.Count > 0);
    }


    protected void btnReconsConfirm_Click(object sender, EventArgs e)
    {
        MbillPlus_payment mBill = new MbillPlus_payment();
      string status_code=  mBill.Reconcile_Confirmation(txtPayDate.Text, getValueOfKey("mBill_KeyCode"), ddlOtc.SelectedValue);
        SaveReconcileConfirmData(status_code);
        if(status_code=="400")
            TrustControl1.ClientMsg("Reconcilation has been confirmed Successfully.");
        else
            TrustControl1.ClientMsg("Reconcilation failed."+"</br>"+ GetReconcileStatusMsg(status_code));
    }

    private string GetReconcileStatusMsg(string status_code)
    {
        if (status_code == "470")
            return "Already Reconciled.";
        else if (status_code == "460")
            return "Data Mismatch.";
        else if (status_code == "449")
            return "Confirmation Failed.";
        else if (status_code == "409")
            return "Not Permitted for this action.";
        else if (status_code == "410")
            return "Mandatory Field NULL.";
        else
            return "";
    }

    private void SaveReconcileConfirmData(string reconcileStatus)
    {

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Reconcile_Confirmation_Insert";  //insert summary log
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Pay_Date", System.Data.SqlDbType.Date).Value = txtPayDate.Text; ;
                    cmd.Parameters.Add("@Otc", System.Data.SqlDbType.Int).Value =int.Parse(ddlOtc.SelectedValue);
                    cmd.Parameters.Add("@Reconcile_Status", System.Data.SqlDbType.VarChar).Value = reconcileStatus;
                    cmd.Parameters.Add("@Insert_By", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                }
            }
        }
        catch (Exception ex)
        {
            Common.WriteLog("West Zone s_Reconcile_Summary_Insert",
                           ex.Message);
        }
    }


}


struct ReconcileSummary
{
    public string Org_Code { get; set; }
    public DateTime Pay_Date { get; set; }
    public string Bank_Name { get; set; }
    public string Branch_Name { get; set; }
    public double Org_Principle_Amnt { get; set; }

    public double Vat_Amount { get; set; }
    public double Org_Total_Amnt { get; set; }
    public double Revenue_Stamp_Amnt { get; set; }
    public double Net_Org_Amnt { get; set; }
    public int Total_Trans { get; set; }
}