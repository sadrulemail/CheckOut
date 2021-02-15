using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ITCL_Response : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        litTitle.Text = this.Title = "ITCL Response #" + Request.QueryString["orderid"].ToString();
        
    }
}