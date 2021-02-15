using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;

public partial class Titas_Reconciliation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (TrustControl1.getUserRoles() == "")
            Response.End();


        Page.Form.Attributes.Add("enctype", "multipart/form-data");
        if (!IsPostBack)
        {
            txtDateFrom.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
            txtDateFrom2.Text = DateTime.Now.Date.ToString("dd/MM/yyyy");
            //Random R = new Random(DateTime.Now.Millisecond +
            //                DateTime.Now.Second * 1000 +
            //                DateTime.Now.Minute * 60000 +
            //                DateTime.Now.Hour * 3600000);

            //hidPageID.Value = string.Format("{0}{1}", Session.SessionID, R.Next());
            //string focusScript = "document.getElementById('" + txtBillNo.ClientID + "').focus();";
            //TrustControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",100);");
        }
        this.Title = "Titas Reconciliation";
    }
    protected void cboBranch_DataBound(object sender, EventArgs e)
    {

        if (!TrustControl1.isRole("ADMIN"))
        {
            foreach (ListItem LI in cboBranch.Items)
                LI.Selected = false;
            if (Session["BRANCHID"].ToString() == "1")
            {
                foreach (ListItem LI in cboBranch.Items)
                    if (LI.Value == Session["Routing"].ToString())
                        LI.Selected = true;
            }
            else
            {
                foreach (ListItem LI in cboBranch.Items)
                    if (LI.Value == Session["Routing"].ToString())
                        LI.Selected = true;
                    else
                        LI.Enabled = false;
            }
        }
    }

    protected void cboBranch2_DataBound(object sender, EventArgs e)
    {
        if (!TrustControl1.isRole("ADMIN"))
        {
            foreach (ListItem LI in cboBranch2.Items)
                LI.Selected = false;
            if (Session["BRANCHID"].ToString() == "1")
            {
                foreach (ListItem LI in cboBranch2.Items)
                    if (LI.Value == Session["Routing"].ToString())
                        LI.Selected = true;
            }
            else
            {
                foreach (ListItem LI in cboBranch2.Items)
                    if (LI.Value == Session["Routing"].ToString())
                        LI.Selected = true;
                    else
                        LI.Enabled = false;
            }
        }
    }
    //private void RunNonQuery(string Query, string ConnectionStringsName, CommandType commandType)
    //{
    //    string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings[ConnectionStringsName].ConnectionString;
    //    SqlConnection oConn = new SqlConnection(oConnString);

    //    SqlCommand oCommand = new SqlCommand(Query, oConn);
    //    oCommand.CommandType = commandType;
    //    if (oConn.State == ConnectionState.Closed) oConn.Open();
    //    oCommand.ExecuteNonQuery();
    //}
    //protected void CleanDatabase()
    //{
    //    RunNonQuery("Delete Titas_Reconciliation WHERE EMPID ='" + Session["EMPID"].ToString() + "'", "PaymentsDBConnectionString", CommandType.Text);
    //}

    protected void cmdReconciliation_M_Click(object sender, EventArgs e)
    {
        string StatusId = "";
        string Msg = "";

        WebReference_TitasMeter.TitasMBillPayment objTitasPay = new WebReference_TitasMeter.TitasMBillPayment();
        string ServiceResponse = objTitasPay.GetMeterPaymentList(DateTime.Parse(txtDateFrom2.Text).ToString("yyyyMMdd"), "", "", "", "", cboBranch2.SelectedValue, Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));

        StatusId = ServiceResponse.Split('|')[0];
        Msg = ServiceResponse.Split('|')[1];
        lblMsg2.Text = txtDateFrom2.Text + "|" + cboBranch2.SelectedItem.Value + "|" + Msg;


        if (StatusId == "1")
        {
            hidPageID.Value = Msg;
            RefreshReconciliation_M();
        }
    }

    protected void cmdReconciliation_NM_Click(object sender, EventArgs e)
    {

        string StatusId = "";
        string Msg = "";
        //string Date = txtDateFrom.Text.Substring(3, 2) + "/" + txtDateFrom.Text.Substring(0, 2) + "/" + txtDateFrom.Text.Substring(6, 4);
        //JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        //lblMsg.Text = Date;
        WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
        try
        {
            string ServiceResponse = objTitasPay.GetDailyPaymentHistory(
                "", 
                cboType.SelectedItem.Value, 
                cboBranch.SelectedItem.Value,
                Session["EMPID"].ToString(), 
                getValueOfKey("Titas_KeyCode")); //"1337B4100011E2|Successfully Paid.";

            StatusId = ServiceResponse.Split('|')[0];
            Msg = ServiceResponse.Split('|')[1];
            lblMsg.Text = txtDateFrom.Text + "|" + cboBranch.SelectedItem.Value + "|" + Msg;       

            if (StatusId == "1")
            {
                hidPageID.Value = Msg;
                RefreshReconciliation();
            }
        }
        catch(Exception ex)
        {
            TrustControl1.ClientMsg(ex.Message);
        }            
    }

    private void RefreshReconciliation_M()
    {
        PanelReconciliationReport_M.Visible = true;
        GridView1.DataBind();
        GridView2.DataBind();
        //GridViewCompare.DataBind();
        //GridViewReconDetails.DataBind();
        //lblReconciliationDetails.Text = string.Format("<a href='Wasa_Reconciliation_Details.aspx?branch={0}&from={1}&to={2}' target='_blank' class='Link'><b>Show Details</b></a>",
        //    cboBranch.SelectedItem.Value,
        //    txtDateFrom.Text,
        //    txtDateTo.Text);
    }

    private void RefreshReconciliation()
    {
        PanelReconciliationReport.Visible = true;
        GridView1.DataBind();
        GridView2.DataBind();
        //GridViewCompare.DataBind();
        //GridViewReconDetails.DataBind();
        //lblReconciliationDetails.Text = string.Format("<a href='Wasa_Reconciliation_Details.aspx?branch={0}&from={1}&to={2}' target='_blank' class='Link'><b>Show Details</b></a>",
        //    cboBranch.SelectedItem.Value,
        //    txtDateFrom.Text,
        //    txtDateTo.Text);
    }
    protected void SqlDataSource1_Reconciliation_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatusTBL.Text = string.Format("Total Rows: <b>{0:N0}</b>", e.AffectedRows);
        lblStatusTBL.Visible = e.AffectedRows > 0;
    }
    protected void SqlDataSource2_Reconciliation_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatusTitas.Text = string.Format("Total Rows: <b>{0:N0}</b>", e.AffectedRows);
        lblStatusTitas.Visible = e.AffectedRows > 0;
    }

    protected void SqlDataSource1_M_Reconciliation_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatusTBL_M.Text = string.Format("Total Rows: <b>{0:N0}</b>", e.AffectedRows);
        lblStatusTBL_M.Visible = e.AffectedRows > 0;
    }
    protected void SqlDataSource2_M_Reconciliation_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatusTitas_M.Text = string.Format("Total Rows: <b>{0:N0}</b>", e.AffectedRows);
        lblStatusTitas_M.Visible = e.AffectedRows > 0;
    }

    protected void GridView1_DataBound(object sender, EventArgs e)
    {

    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        //lblStatus.Text = string.Format("Total Branch: <b>{0:N0}</b>", e.AffectedRows);
    }
    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }
}
