using System;

public partial class Checkout_Edit_History : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        Title = string.Format("#{0} History", Request.QueryString["refid"]);
        lblTitle.Text = string.Format("History of Checkout Receipt # {0}", Request.QueryString["refid"]);
    }
}