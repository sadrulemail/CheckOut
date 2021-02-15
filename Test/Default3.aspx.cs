using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        
    }
    protected void cmdSubmit_Click(object sender, EventArgs e)
    {
        Passport_Payment.Passport_Payment_Service srv = new Passport_Payment.Passport_Payment_Service();
        lblLabel.Text = srv.getPassportRefID(
            int.Parse(txtAmount.Text),
            txtName.Text, 
            txtT.Text, 
            txtNotifyMobile.Text, 
            txtSenderMobile.Text, 
            txtType.Text,
            txtEmail.Text,
            txtKeyCode.Text);
    }
    protected void cmdSubmit2_Click(object sender, EventArgs e)
    {
        Passport_Verify.Passport_Verify srv = new Passport_Verify.Passport_Verify();
        lblLabel2.Text = srv.CheckPayment(
            txtRefID2.Text,
            //DateTime.Today,
            txtName2.Text,
            decimal.Parse(txtAmount2.Text),
            txtEID.Text,
            DateTime.Today,
            txtKeyCode2.Text);
    }
}