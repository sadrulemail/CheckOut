using System;
using System.Text;

public partial class Pay_Passport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = "Passport Payment - Trust Bank Checkout";
    }
    protected void btnNext_Click(object sender, EventArgs e)
    {  
        string RefID = "";
        float Pass_amount = 0;
        if (txtCaptcha.Text != Session[TrustCaptcha.SESSION_CAPTCHA].ToString())
        {      
            txtCaptcha.Text = "";
            CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
      
            return;
        }
        try
        {

            float Vat_Passport = float.Parse(getValueOfKey("Vat_Passport"));
            float Pass_fee = 0;
     
            if (ddlServiceType.SelectedValue == "R")
                Pass_fee = 3000;
            else
                Pass_fee = 6000;

            Pass_amount = Pass_fee + Pass_fee * Vat_Passport / 100;            

            if (txtExpDate.Text != "")
            {
                DateTime date = DateTime.Parse(txtExpDate.Text);
                int Year = GetDifferenceInYears(date);
                Pass_amount = Pass_amount + (Year * 300);
            }

            //CommonControl1.ClientMsg(Pass_amount.ToString());
            //    DateDiff()

            //ServicePointManager.CertificatePolicy = new MyPolicy();
            //ServicePointManager.CheckCertificateRevocationList = false;
            //ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
            //     | SecurityProtocolType.Ssl3
            //      | SecurityProtocolType.Tls11
            //       | SecurityProtocolType.Tls12;
            //ServicePointManager.Expect100Continue = true;
            //ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            //NidPayment.NID_Payment nid_service
            //      = new NidPayment.NID_Payment();
            //string due_amount = nid_service.GetDueAmountWithRefID(txtNid.Text.Trim(), ddlCorrection.SelectedValue.ToString(), ddlServiceType.SelectedValue.ToString(), keycode_nid);
            //string[] Ref_Amnt = due_amount.Split('|');

            //RefID = Ref_Amnt[0];
            //amount = Ref_Amnt[1];
            //hidRefID.Value = RefID;

            if (Pass_amount > 0)
            {
                lblDueAmount.Text = "BDT " + Pass_amount.ToString();
                btnPayment.Visible = true;
                btnNext.Visible = false;
                txtName.ReadOnly = true;
                txtEmail.ReadOnly = true;
                txtExpDate.ReadOnly = true;
                ddlServiceType.Enabled = false;
                CaptchaDiv.Visible = false;
            }
            else
            {
               // CommonControl1.ClientMsg("No data found, Please enter correct information.", txtNid);
                btnPayment.Visible = false;
                btnNext.Visible = true;
            }

        }
        catch (Exception ex)
        {
            CommonControl1.ClientMsg(ex.Message);
            hidRefID.Value = "";
            lblDueAmount.Text = "";
        }
    }

    internal static int GetDifferenceInYears(DateTime startDate)
    {
        int finalResult = 0;

        const int DaysInYear = 365;

        DateTime endDate = DateTime.Now.Date;

        TimeSpan timeSpan = endDate - startDate;

        if (timeSpan.TotalDays > 365)
        {
            finalResult = (int)Math.Round((timeSpan.TotalDays / DaysInYear), MidpointRounding.ToEven) + 1;
        }

        return finalResult;
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
        try
        {
            Guid g_id = Guid.NewGuid();
            string orderid = g_id.ToString().Replace("-", "").ToUpper();

            Response.Redirect(string.Format("https://ibanking.tblbd.com/CheckoutPassport/Passport_Payment.aspx?keycode={0}&onlineid={1}&enrolmentdate={2}&amount={3}&fullname={4}&email={5}&SID={6}"
                , "19C9C9BF-7E40-40C6-8991-D87D814AA552"
                , "TBL_" + orderid
                , string.Format("{0:dd/MM/yyyy}", DateTime.Today)
                , lblDueAmount.Text.Replace("BDT","").Trim()
                , txtName.Text
                , txtEmail.Text
                , "TBL_" + orderid), true);

            //Guid g_id = Guid.NewGuid();
            //string orderid = g_id.ToString();
            ////  string postbackUrl = "../Checkout_Payment.aspx?refid=" + hidRefID;
            //string postbackUrl = "../Checkout_Payment.aspx";
            //Response.Clear();
            //StringBuilder sb = new StringBuilder();
            //sb.Append("<html>");
            //sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
            //sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
            //sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", "NID_" + orderid.ToUpper());
            //sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", lblDueAmount.Text);
            //sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", "NID");  
            //sb.AppendFormat("<input type='hidden' name='FullName' value='{0}'>", "");
            //sb.AppendFormat("<input type='hidden' name='Email' value='{0}'>", "");
            //sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", "");
            //sb.AppendFormat("<input type='hidden' name='RefID' value='{0}'>", hidRefID.Value);
            //// Other params go here
            //sb.Append("</form>");
            //sb.Append("</body>");
            //sb.Append("</html>");
            //Response.Write(sb.ToString());
            //Response.End();
        }
        catch (Exception ex)
        {
        }
    }

    protected void chkPrevPassport_CheckedChanged(object sender, EventArgs e)
    {
        //ExpiryDateDiv.Visible = chkPrevPassport.Checked;
    }
}