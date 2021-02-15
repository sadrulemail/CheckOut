using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceAPI
{
    public partial class Approved : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["ORDERID"] != null && Request.QueryString["SESSIONID"] != null)
            {
                string orderId = Request.QueryString["ORDERID"];
                string sessionId = Request.QueryString["SESSIONID"];
                Label1.Text = orderId;
                Label2.Text = sessionId;
                Response.Redirect("https://tpmpi.itcbd.com:18288/index.jsp?ORDERID=" + orderId + "&SESSIONID=" + sessionId);
            }
            else
            {
                string responseValue=Request.Form["xmlmsg"];
                TextBox1.Text = responseValue;
            }
            
            
        }
    }
}