using System;

public partial class EmailCheck : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void cmdCheck_Click(object sender, EventArgs e)
    {
        string EmailAddress = Common.purifyEmailAddress(txtEmail.Text);
        //string EmailAddress = (txtEmail.Text);

        //try
        //{            
        //    var mail = new System.Net.Mail.MailAddress(EmailAddress);
        //    lblStatus.Text = "true";            
        //}
        
        //catch
        //{
        //    lblStatus.Text = "false";            
        //}
        //return;

        lblStatus.Text = "<br><b>" +EmailAddress + "</b><br><br>" + Common.isEmailAddress(EmailAddress).ToString();
    }
}