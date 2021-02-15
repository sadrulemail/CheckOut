using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceAPI
{
    public partial class Declined : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string responseValue = Request.Form["xmlmsg"];
            TextBox1.Text = responseValue;
        }
    }
}