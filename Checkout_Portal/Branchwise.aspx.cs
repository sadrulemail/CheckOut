using System;
using System.Web.UI.WebControls;

public partial class Branchwise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        Title = "Branch wise Passport Payment Report";

        //if (!IsPostBack) txtFilter.Focus();

        if (!IsPostBack)
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
        }               

        //GridView1.Visible = IsPostBack;
        //cmdExport.Visible = IsPostBack;
    }

    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
        }
        catch (Exception) { }
    }

    protected void cmdNextDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
        }
        catch (Exception) { }
    }

    protected void cboBranch_DataBound(object sender, EventArgs e)
    {
        if (!TrustControl1.isRole("ADMIN"))
        {
            foreach (ListItem LI in cboBranch.Items)
                LI.Selected = false;

            foreach (ListItem LI in cboBranch.Items)
                if (LI.Value == Session["BRANCHID"].ToString())
                    LI.Selected = true;
                else                   
                    LI.Enabled = false;
        }
    }
    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        litTotalAmount.Text = string.Format(TrustControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        litTotalPaid.Text = string.Format(TrustControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);
    }
}