using System;
using System.Collections.Generic;
using System.Text;
//using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Pay_Bgsl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
      
        if (!IsPostBack)
        {
            for (int i = DateTime.Now.Year; i > DateTime.Now.Date.AddYears(-10).Year; i--)
            {
                ddlFromYear.Items.Add(i.ToString());
                ddlEndYear.Items.Add(i.ToString());
            }

            this.Title = "Bakhrabad Gas Distribution Company Limited (BGDCL) Payment - Trust Bank Checkout";
        }
        else
        {
            
        }
    }

    protected void btnDuesAmount_Click(object sender, EventArgs e)
    {
        if (txtCaptcha.Text != Session[TrustCaptcha.SESSION_CAPTCHA].ToString())
        {
           // lblDueAmount.Text = "Please enter correct challenge key.";
            txtCaptcha.Text = "";
            CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);
            // txtCaptcha.Focus();
            return; 
        }


        //System.Threading.Thread.Sleep(1000);

        string due_amount = "";
        string RefID = "";
        string amount = "";

        try
        {
            BGSL.BGSL_Payment bgsl_service
                = new BGSL.BGSL_Payment();

            due_amount = bgsl_service.GetDueAmountWithRefID(txtCustomer.Text.Trim(), ddlFromYear.SelectedValue.ToString().Trim(),ddlFromMonth.SelectedValue.ToString().Trim(),ddlEndYear.SelectedValue.ToString().Trim(), ddlEndMonth.SelectedValue.ToString().Trim(), getValueOfKey("Bgsl_KeyCode"));
            string[] Ref_Amnt = due_amount.Split('|');


            RefID = Ref_Amnt[0];
            amount = Ref_Amnt[1];
            hidRefID.Value = RefID;
         
            if (double.Parse(amount == "" ? "0" : amount) > 0)
            {
                lblDueAmount.Text = amount;
                btnPayment.Visible = true;
                btnDuesAmount.Visible = false;
                PanelChalKey.Visible = false;
            }
            else
            {
                CommonControl1.ClientMsg("Data not found, Please enter correct information.", txtCustomer);
                btnPayment.Visible = false;
                btnDuesAmount.Visible = true;
                PanelChalKey.Visible = true;
            }
        }
        catch(Exception ex)
        {
            CommonControl1.ClientMsg("Data not found, Please enter correct information.", txtCustomer);
            lblDueAmount.Text = "";
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
        try
        {
            Guid g_id = Guid.NewGuid();
            //string orderid = "BGSL_" + g_id.ToString();
            ////string postbackUrl = "../Checkout_Payment.aspx?refid=" + hidRefID.Value;
            //string postbackUrl = "../Checkout_Payment.aspx";
            //Response.Clear();
            //StringBuilder sb = new StringBuilder();
            //sb.Append("<html>");
            //sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
            //sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
            //sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>",  orderid.ToUpper());
            //sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", lblDueAmount.Text);
            //sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", "BGSL");
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


            BGSL.BGSL_Payment bgsl_service
            = new BGSL.BGSL_Payment();
            //string service_result = "1";
            string service_result = bgsl_service.ConfirmPayment_MM(hidRefID.Value, getValueOfKey("Bgsl_KeyCode"), g_id.ToString(),"8801747903788");
            if (service_result == "1")
            {
                //string script = string.Format("alert('{0}');", "Bill has been updated to BGDCL's Server Successfully.");

                ClientMsg("Bill has been updated to BGDCL's Server Successfully.</br> RefID: "+ hidRefID.Value);
              
            }
            else
                ClientMsg("Bill paid but has not been updated to BGDCL's Server end.</br> RefID: " + hidRefID.Value);
        }
        catch(Exception ex)
        {
        }
    }


    public void ClientMsg(string MsgTxt)
    {
        ClientMsg(MsgTxt, null);
    }
    public void ClientMsg(string MsgTxt, Control focusControl)
    {
        MsgTxt = MsgTxt.Replace("'", "\\'");
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "$('.modal-backdrop').each(function(){$(this).remove()});bootbox.alert('" + MsgTxt + "', function(){setTimeout(function(){" + script1 + "},100)});", true);
    }


}