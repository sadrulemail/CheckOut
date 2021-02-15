using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class TestPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session.Clear();
            Session.Abandon();
            Response.Cookies.Add(new HttpCookie("ASP.NET_SessionId", ""));
            
            //txtEnrolmentDate.Text = DateTime.Now.ToString("dd/MM/yyyy");

        }

    }
    protected void cmdSubmit2_Click(object sender, EventArgs e)
    {
        //if (ddlMarchentType.SelectedValue == "1")
        //{
            Response.Redirect(string.Format("Passport_Payment.aspx?keycode={0}&onlineid={1}&enrolmentdate={2}&amount={3}&fullname={4}&email={5}&SID={6}"
                , "19C9C9BF-7E40-40C6-8991-D87D814AA552"
                , "TEST_" + Session.SessionID.ToString().ToUpper()
                , string.Format("{0:dd/MM/yyyy}", DateTime.Today)
                , txtAmount.Text
                , txtName.Text
                , txtEmail.Text
                , Session.SessionID.ToString().ToUpper()), true);
        //}
        //else
        //{
        //    Response.Redirect(string.Format("Checkout_Payment.aspx?orderid={0}&amount={1}&fullname={2}&email={3}&marchentID={4}"
            
        //      , "TEST_" + Session.SessionID.ToString().ToUpper()
        //      , txtAmount.Text.Trim()
        //      , txtName.Text.Trim()
        //      , txtEmail.Text.Trim()
            
        //      ,ddlMarchentType.Text.ToString()),true);
        //}

    }
}