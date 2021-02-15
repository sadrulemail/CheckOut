using System;
using System.Text;
//using System.Linq;
using System.Web.UI.WebControls;

public partial class WestZone : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = "West Zone Power Distribution Company Limited (WZPDCL) Payment - Trust Bank Checkout";

        if (!IsPostBack)
        {
            for (int i = DateTime.Now.Year; i > DateTime.Now.Date.AddYears(-10).Year; i--)
            {
                ddlFromYear.Items.Add(i.ToString());
            }            
        }

        try
        {
            string AccountNo = string.Format("{0}", Request.Form["acc_num"]);
            string billcycle = string.Format("{0}", Request.Form["billcycle"]);
            string Year = "";
            string Month = "";
            if (billcycle != "")
            {
                 Year = billcycle.Substring(0, 4);
                 Month = billcycle.Substring(4, 2);
            }
            hidPaymentSuccessUrl.Value = string.Format("{0}", Request.Form["paymentsuccessurl"]);
            hidOrderID.Value = string.Format("{0}", Request.Form["orderid"]);
            string email = string.Format("{0}", Request.Form["email"]);
            string _otc = string.Format("{0}", Request.Form["otc"]);
            hidOtc.Value = "0";
            if (_otc.Trim() !="")
                hidOtc.Value= _otc;
            if (email.Length > 0)
            {
                txtEmail.Text = email;
                txtEmail.Enabled = false;
            }
            if (AccountNo.Length > 0)
            {
                txtAccount.Text = AccountNo;
                txtAccount.Enabled = false;
            }

            if (Year.Length > 0)
            {
                foreach (ListItem LI in ddlFromYear.Items)
                    LI.Selected = false;
                foreach (ListItem LI in ddlFromYear.Items)
                    if (LI.Value == Year)
                        LI.Selected = true;
                ddlFromYear.Enabled  = false;
            }

            if (Month.Length > 0)
            {
                foreach (ListItem LI in ddlFromMonth.Items)
                    LI.Selected = false;
                foreach (ListItem LI in ddlFromMonth.Items)
                    if (LI.Value == Month)
                        LI.Selected = true;
                ddlFromMonth.Enabled = false;
            }
            txtCaptcha.Focus();

        }
        catch(Exception ex)
        {

        }
        
    }

    protected void btnDuesAmount_Click(object sender, EventArgs e)
    {
        if (txtCaptcha.Text != Session[TrustCaptcha.SESSION_CAPTCHA].ToString())
        {
            //  lblDueAmount.Text = "Please enter correct challenge key.";
            txtCaptcha.Text = "";
            CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
          
          //  txtCaptcha.Focus();
            return; 
        }


        //System.Threading.Thread.Sleep(1000);

        string due_amount = "";
        string RefID = "";
        string amount = "";
        string billCycle = ddlFromYear.SelectedValue.ToString().Trim() + ddlFromMonth.SelectedValue.ToString().Trim();

            try
        {
            mBillPlusService.MbillPlus_payment mBill_service
                = new mBillPlusService.MbillPlus_payment();

           due_amount = mBill_service.Get_Bill_Due_Info(txtAccount.Text.Trim(), billCycle, hidOtc.Value.Trim(), getValueOfKey("mBill_KeyCode"));
            string[] Ref_Amnt = due_amount.Split('|');


            RefID = Ref_Amnt[0];
            amount = Ref_Amnt[1];
            hidRefID.Value = RefID;
            lblDueAmount.Text = amount;

            if (double.Parse(amount == "" ? "0" : amount) > 0)
            {
                btnPayment.Visible = true;
                btnDuesAmount.Visible = false;
                PanelChalKey.Visible = false;
            }
            else
            {
                btnPayment.Visible = false;
                btnDuesAmount.Visible = true;
                PanelChalKey.Visible = true;
            }
        }
        catch(Exception ex)
        {
            CommonControl1.ClientMsg("Information not found.", txtAccount);
           // lblDueAmount.Text = "Information not found";
            hidRefID.Value = "";
            btnPayment.Enabled = false;
            PanelChalKey.Visible = true;
        }
    }
    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    protected void btnPayment_Click(object sender, EventArgs e)
    {
        if(hidOrderID.Value.Length == 0)
        {
            Guid g_id = Guid.NewGuid();
            hidOrderID.Value = "WZPDCL_" + g_id.ToString();
        }
        //Response.Redirect("../Checkout_Payment.aspx?refid=" + hidRefID.Value, true);
        try
        {
            
            // string postbackUrl = "../Checkout_Payment.aspx?refid=" + hidRefID.Value;
            string postbackUrl = "../Checkout_Payment.aspx";
            Response.Clear();
            StringBuilder sb = new StringBuilder();
            sb.Append("<html>");
            sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
            sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
            sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", hidOrderID.Value);
            sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", lblDueAmount.Text);
            sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", "WZPDCL");
            sb.AppendFormat("<input type='hidden' name='FullName' value='{0}'>", "");
            sb.AppendFormat("<input type='hidden' name='Email' value='{0}'>", txtEmail.Text.ToString().Trim());
            sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", hidPaymentSuccessUrl.Value);
            sb.AppendFormat("<input type='hidden' name='RefID' value='{0}'>", hidRefID.Value);
            // Other params go here
            sb.Append("</form>");
            sb.Append("</body>");
            sb.Append("</html>");
            Response.Write(sb.ToString());
            Response.End();

        }
        catch (Exception ex)
        {
        }
    }


}