using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;

public partial class Bhbfc : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = "BHBFC Payment - Trust Bank Checkout";
    }
    protected void btnNext_Click(object sender, EventArgs e)
    {
       
        // return;
        //string RefID = "";
        //float Pass_amount = 0;
        //if (txtCaptcha.Text != Session[TrustCaptcha.SESSION_CAPTCHA].ToString())
        //{      
        //    txtCaptcha.Text = "";
        //    CommonControl1.ClientMsg("Please enter correct Challenge Key.", txtCaptcha);

        //    return;
        //}
        String loanType = "";
        String loanCat = "";
        String loanProduct = "";
        try
        {
      
      
            using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Bhbfc_CustLoan_Info";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@LoanAccountNo", System.Data.SqlDbType.VarChar).Value = txtAccNo.Text.Trim();

                SqlParameter sqlloanType = new SqlParameter("@loanType", System.Data.SqlDbType.VarChar, 50);
                    sqlloanType.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanType.Value = "";
                    cmd.Parameters.Add(sqlloanType);

                    SqlParameter sqlloanCat = new SqlParameter("@loanCat", System.Data.SqlDbType.VarChar, 50);
                    sqlloanCat.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanCat.Value = "";
                    cmd.Parameters.Add(sqlloanCat);

                    SqlParameter sqlloanProduct = new SqlParameter("@loanProduct", System.Data.SqlDbType.VarChar, 50);
                    sqlloanProduct.Direction = System.Data.ParameterDirection.InputOutput;
                    sqlloanProduct.Value = "";
                    cmd.Parameters.Add(sqlloanProduct);

                    cmd.Connection = conn;
                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();
                    cmd.ExecuteNonQuery();
                 
                    loanType = string.Format("{0}", sqlloanType.Value);
                    loanCat = string.Format("{0}", sqlloanCat.Value);
                    loanProduct = string.Format("{0}", sqlloanProduct.Value);

                }
        }
     


}
        catch (Exception ex)
        {
            Common.WriteLog("s_Bhbfc_CustLoan_Info", string.Format("{0}", ex.Message));
            // CommonControl1.ClientMsg(ex.Message);
            //hidRefID.Value = "";
            //lblDueAmount.Text = "";
        }

        if(loanType !="" && loanCat !="" && loanProduct !="")
        {
           
            labelName.Text = txtAccname.Text.Trim();
            labelAccNo.Text = txtAccNo.Text.Trim().Substring(1, 8);
            labelFullAccNo.Text = " (" + txtAccNo.Text + ")";
            labelBranch.Text = ddlBranch.SelectedItem.ToString();
            labelloantype.Text = loanType;
            labelCategory.Text = loanCat;
            labelProduct.Text = loanProduct;
            labelMobile.Text = txtMobile.Text.Trim();
            labelEmail.Text = txtEmail.Text.Trim();
            lblAmount.Text = txtPaymentAmount.Text.Trim();

            panelLoanpayment.Visible = false;
            panelLoanInfo.Visible = true;
            litCSS.Text = "<style>.control-label{padding-top:0px !important;}.row{padding-top:7px;}</style>";
            btnNext.Visible = false;
            panelWarning.Visible = false;
            hidBranchCode.Value = ddlBranch.SelectedValue.ToString();
            hidLoanAcc.Value = txtAccNo.Text;
            labelPayPurpose.Text = ddlPaymentPurpose.SelectedItem.ToString();
            labelAccType.Text =txtAccNo.Text.Substring(txtAccNo.Text.Length - 1, 1)=="0"?"Deffered (Old Account)":"EMI (New Account)";
            hidPayPurpose.Value = ddlPaymentPurpose.SelectedValue;
            //if (txtAccNo.Text.Substring(txtAccNo.Text.Length - 1, 1) == "1")
            //{

            //}
        }
        else
        {
            panelWarning.Visible = true;
            panelLoanpayment.Visible = false;
            panelLoanInfo.Visible = false;
            btnNext.Visible = false;

        }


    }

    protected void btnPrevious_Click(object sender, EventArgs e)
    {
        Response.Redirect("~/Pay/Bhbfc.aspx");
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
        bool SaveDone = false;
        try
        {

            Guid g_id = Guid.NewGuid();
            string orderid = g_id.ToString();
            SaveDone= SaveLoanInfo(orderid);
            if (SaveDone)
            {
                string postbackUrl = "https://ibanking.tblbd.com/testCheckout/Checkout_Payment.aspx";
                // "../Checkout_Payment.aspx";
                Response.Clear();
                StringBuilder sb = new StringBuilder();
                sb.Append("<html>");
                sb.AppendFormat(@"<body onload='document.forms[""form""].submit()'>");
                sb.AppendFormat("<form name='form' action='{0}' method='POST'>", postbackUrl);
                sb.AppendFormat("<input type='hidden' name='OrderID' value='{0}'>", orderid);
                sb.AppendFormat("<input type='hidden' name='Amount' value='{0}'>", lblAmount.Text);
                sb.AppendFormat("<input type='hidden' name='MerchantID' value='{0}'>", "BHBFC");
                sb.AppendFormat("<input type='hidden' name='FullName' value='{0}'>", labelName.Text.Trim());
                sb.AppendFormat("<input type='hidden' name='Email' value='{0}'>", labelEmail.Text.Trim());
                //  sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", "https://ibanking.tblbd.com/TestCheckout/MerchantPaymentConfirmation.aspx");
                sb.AppendFormat("<input type='hidden' name='PaymentSuccessUrl' value='{0}'>", "http://localhost:51907/MerchantPaymentConfirmation.aspx");
                // Other params go here
                sb.Append("</form>");
                sb.Append("</body>");
                sb.Append("</html>");
                Response.Write(sb.ToString());
                Response.End();
            }
            else
            {

            }
        }
        catch (Exception ex)
        {
           
        }
    }

    private bool SaveLoanInfo(string OrderID)
    {
        bool Done = false;
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Bhbfc_LoanInfoSave";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@MerchantID", System.Data.SqlDbType.VarChar).Value = "BHBFC";
                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = hidBranchCode.Value;
                    cmd.Parameters.Add("@MobileNo", System.Data.SqlDbType.VarChar).Value = labelMobile.Text;
                    cmd.Parameters.Add("@AccountNo", System.Data.SqlDbType.VarChar).Value = hidLoanAcc.Value;
                    cmd.Parameters.Add("@PaymentPurpose", System.Data.SqlDbType.VarChar).Value = hidPayPurpose.Value;


                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);



                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();

                       Done =(bool) sqlDone.Value;

                }
            }
        }
        catch(Exception ex)
        {
            Done = false;
            Common.WriteLog("s_Bhbfc_LoanInfoSave", string.Format("{0}", ex.Message));
        }
      return  Done;
    }

    protected void chkPrevPassport_CheckedChanged(object sender, EventArgs e)
    {
        //ExpiryDateDiv.Visible = chkPrevPassport.Checked;
    }
}