using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Passport_Receipt_Print : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) txtReceiptNo.Focus();
    }
    protected void TextBox_OnTextChanged(object sender, EventArgs e)
    {

    }
}