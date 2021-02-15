using System;

namespace ServiceCube
{
    public partial class LoginHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            this.Title = "Login History - " + UserControl1.getValueOfKey("AppName");

            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            }
        }
    }
}