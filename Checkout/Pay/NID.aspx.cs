using System;
using System.Collections;
using System.Collections.Generic;
using System.Net;
using System.Text;
//using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class NID : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = "NID Payment - Trust Bank Checkout";
    }

    protected void btnDuesAmount_Click(object sender, EventArgs e)
    {
     
        string RefID = "";
        string amount = "";
        if (txtCaptcha.Text != Session[TrustCaptcha.SESSION_CAPTCHA].ToString())
        {
          //  lblDueAmount.Text = "Please enter correct challenge key.";
            txtCaptcha.Text = "";
            CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
          //  txtCaptcha.Focus();
            return;
        }
        try
        {

            string keycode_nid = getValueOfKey("NID_KeyCode");
            ServicePointManager.CertificatePolicy = new MyPolicy();
            ServicePointManager.CheckCertificateRevocationList = false;
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls
                 | SecurityProtocolType.Ssl3
                  | SecurityProtocolType.Tls11
                   | SecurityProtocolType.Tls12;
            ServicePointManager.Expect100Continue = true;
            ServicePointManager.ServerCertificateValidationCallback = delegate { return true; };
            NidPayment.NID_Payment nid_service
                  = new NidPayment.NID_Payment();
            string due_amount = nid_service.GetDueAmountWithRefID(txtNid.Text.Trim(), ddlCorrection.SelectedValue.ToString(), ddlServiceType.SelectedValue.ToString(), keycode_nid);
            string[] Ref_Amnt = due_amount.Split('|');


            RefID = Ref_Amnt[0];
            amount = Ref_Amnt[1];
            hidRefID.Value = RefID;
          

            if (double.Parse(amount == "" ? "0" : amount) > 0)
            {
                lblDueAmount.Text = "BDT " + amount;
                btnPayment.Visible = true;
                btnDuesAmount.Visible = false;

            }
            else
            {
                CommonControl1.ClientMsg("No data found, Please enter correct information.", txtNid);
                btnPayment.Visible = false;
                btnDuesAmount.Visible = true;

            }
         //   lblDueAmount.Text = amount;
        }
        catch(Exception ex)
        {
            hidRefID.Value = "";
            lblDueAmount.Text = "";
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
        try
        {
            Guid g_id = Guid.NewGuid();
            string orderid = g_id.ToString();
          //  string postbackUrl = "../Checkout_Payment.aspx?refid=" + hidRefID;
            string postbackUrl = "../Checkout_Payment.aspx";
            Response.Clear();
            StringBuilder sb = new StringBuilder();
            sb.Append("<html>");
            sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
            sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
            sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", "NID_" + orderid.ToUpper());
            sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", lblDueAmount.Text.Replace("BDT","").Trim());
            sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", "NID");
            sb.AppendFormat("<input type='hidden' name='FullName' value='{0}'>", "");
            sb.AppendFormat("<input type='hidden' name='Email' value='{0}'>", "");
            sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", "");
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

    protected void ddlCorrection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCorrection.SelectedValue.ToString() == "3")
        {
            ddlServiceType.Items.Clear();
            ListItem type = new ListItem("Regular", "R", true);
            //type.Selected = true;
            ddlServiceType.Items.Add(type);
        }
        else
        {
            ddlServiceType.Items.Clear();
            ListItem type_R = new ListItem("Regular", "R", true);
            ddlServiceType.Items.Add(type_R);
            ListItem type_E = new ListItem("Express", "E", true);
        
            ddlServiceType.Items.Add(type_E);
        }
    }
}