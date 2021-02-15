using System;
using System.Web.Script.Serialization;

public partial class Titas_Payment_Metered : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        if (!IsPostBack)
        {
            txtCustomerID.Focus();
        }

        //Test
        //PanelPaymentInfo.Visible = true;
        //txtInvoiceAmount.Text = "1200.00";
        //txtRevAmount.Text = "10.00";
        //txtSourceTax.Text = "0.00";
        //txtPaidAmount.Text = "1190.00";
        //txtCashReceived.Text = "1200.00";
        //txtSourceTax.Focus();

        //txtCustomerID.Text = "30600013100031";
        //txtInvoiceNo.Text = "902872558";
    }

    private void ClearForm()
    {
        lblCusName.Text = "";
        lblSettleDT.Text = "";
        lblZone.Text = "";
        lblIssueMonth.Text = "";
        txtSourceTax.Text = "";
        txtPaidAmount.Text = "";
        txtTotalBill.Text = "";
        txtCashReceived.Text = "";
        txtCustomerContactNo.Text = "";
        litStatus1.Text = "";
        txtInvoiceAmount.Text = "";
        txtChalanNo.Text = "";
        txtChalanDate.Text = "";
        txtRevAmount.Text = "0.00";
        hidRefID.Value = "";
        txtChalanBankBranch.Text = "";
        txtChalanBank.Text = "";

        cmdPay.Visible = true;
        txtSourceTax.Enabled = true;
        txtPaidAmount.Enabled = false;
        txtCashReceived.Enabled = false;
        txtCustomerContactNo.Enabled = true;

        
        hidRefID.Value = "";
        hidPayID.Value = "";

    }

    protected void dboPaymentType_SelectedIndexChanged(object sender, EventArgs e)
    {
        ClearForm();
        
        Panel1.Visible = true;
        txtCustomerID.Text = "";
        txtCustomerID.Focus();
        PanelCusInfo.Visible = false;
        PanelPaymentInfo.Visible = false;        
    }

    protected void cmdSearch_Click(object sender, EventArgs e)
    {
        ClearForm();

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        WebReference_TitasMeter.TitasMBillPayment objTitasPay = new WebReference_TitasMeter.TitasMBillPayment();
        string json_status = objTitasPay.GetMeterCustomer(txtCustomerID.Text.Trim(), txtInvoiceNo.Text.Trim(), Session["ROUTING"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));

        string[] jsonRtn = new string[2];
        jsonRtn = json_status.Split('|');
        hidRefID.Value = jsonRtn[0];

        double RevStamp = 0;
        double InvoiceAmount = 0;

        if (jsonRtn[0] != "")
        {
            TmCustomerSearch payment = jsonSerializer.Deserialize<TmCustomerSearch>(jsonRtn[1]);

            //Data Found
            PanelCusInfo.Visible = true;
            PanelPaymentInfo.Visible = true;
            litStatus1.Text = "";

            lblCusCode.Text = payment.data.customerCode;
            lblCusName.Text = payment.data.customerName;
            lblSettleDT.Text = payment.data.settleDate;
            lblZone.Text = payment.data.zone;
            lblinvoiceNo.Text = payment.data.invoiceNo;
            lblIssueMonth.Text = payment.data.issueMonth;
            hidRefID.Value = jsonRtn[0];
            InvoiceAmount = payment.data.invoiceAmount;
            txtInvoiceAmount.Text = (string.Format("{0:N2}", InvoiceAmount)).Replace(",", "");
            if (InvoiceAmount > 400) RevStamp = 10;
            txtRevAmount.Text = string.Format("{0:N2}", RevStamp);
            txtSourceTax.Text = "0.00";
            txtTotalBill.Text = (string.Format("{0:N2}", InvoiceAmount)).Replace(",", "");
            txtCashReceived.Text = (string.Format("{0:N2}", InvoiceAmount)).Replace(",", "");
            txtPaidAmount.Text = (string.Format("{0:N2}", InvoiceAmount - RevStamp)).Replace(",", "");
            //hidPayID.Value = payment.data.pay;
            txtSourceTax.Focus();
        }
        else
        {
            //Data Not Found
            PanelCusInfo.Visible = false;
            PanelPaymentInfo.Visible = false;
            litStatus1.Text = "Data Not Found. "+ jsonRtn[1];
            txtCustomerID.Focus();
            hidRefID.Value = "";
            hidPayID.Value = "";
        }
    }

    protected void cmdPay_Click(object sender, EventArgs e)
    {
        string trnDate = DateTime.Now.ToString("yyyMMdd");

        //bool isDuplicate = CheckDuplicatePayment(lblCusCode.Text, Session["BRANCHID"].ToString());
        //if (!isDuplicate)
        //{

        litStatus1.Text = "";

        double PaidAmount = 0;
        double Amount = 0;
        double Total = 0;
        double Received = 0;
        double InvoiceAmount = 0;
        double SourceTax = 0;
        long Mobile;
        double RevStamp = 0;
        DateTime ChalanDate;
        string chalanDT = "";
        try
        {
            PaidAmount = double.Parse(txtPaidAmount.Text == "" ? "0" : txtPaidAmount.Text);
            if (PaidAmount < 0)
            {
                TrustControl1.ClientMsg("Paid Amount can not be negative.");
                return;
            }
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Paid Amount.");
            return;
        }
        try
        {
            SourceTax = double.Parse(txtSourceTax.Text == "" ? "0" : txtSourceTax.Text);
            if (SourceTax < 0)
            {
                TrustControl1.ClientMsg("Source Tax Amount can not be negative.");
                return;
            }
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Source Tax Amount.");
            return;
        }

        try
        {
            RevStamp = double.Parse(txtRevAmount.Text == "" ? "0" : txtRevAmount.Text);
        }
        catch (Exception)
        {
            RevStamp = 0;
        }

        try
        {
            InvoiceAmount = double.Parse(txtInvoiceAmount.Text);
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Invoice Amount.");
            return;
        }

        try
        {
            Amount = double.Parse(txtPaidAmount.Text);
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Amount.");
            return;
        }

        if (SourceTax > 0)
        {
            if (txtChalanNo.Text.Length < 3)
            {
                TrustControl1.ClientMsg("Please enter Challan No.");
                txtChalanNo.Focus();
                return;
            }
            if (txtChalanDate.Text.Length < 10)
            {
                TrustControl1.ClientMsg("Please enter Challan Date.");
                txtChalanDate.Focus();
                return;
            }
            try
            {
                ChalanDate = DateTime.Parse(txtChalanDate.Text);
                if (ChalanDate.Year > DateTime.Now.Year || ChalanDate.Year + 3 < DateTime.Now.Year)
                {
                    TrustControl1.ClientMsg("Invalid Chalan Year.");
                    txtChalanDate.Focus();
                    return;
                }
                chalanDT = ChalanDate.ToString("yyyyMMdd");
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Chalan Date.");
                txtChalanDate.Focus();
                return;
            }
            if (txtChalanBank.Text.Length < 2)
            {
                TrustControl1.ClientMsg("Please enter Challan Bank Name.");
                txtChalanBank.Focus();
                return;
            }
            if (txtChalanBankBranch.Text.Length < 2)
            {
                TrustControl1.ClientMsg("Please enter Challan Bank Branch Name.");
                txtChalanBankBranch.Focus();
                return;
            }
        }

        try
        {
            Total = double.Parse(txtTotalBill.Text);
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Total.");
            return;
        }

        //try
        //{
        //    Received = double.Parse(txtCashReceived.Text);
        //}
        //catch (Exception)
        //{
        //    TrustControl1.ClientMsg("Invalid Received Amount.");
        //    return;
        //}

        string MobileStr = "";
        if (txtCustomerContactNo.Text.Trim().Length < 11)
        {
            try
            {
                Mobile = long.Parse("88" + txtCustomerContactNo.Text);
                MobileStr = Mobile.ToString();
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Mobile Number.<br>Format: 01xxxxxxxxx");
                return;
            }
        }

        if (Total != InvoiceAmount)
        {
            TrustControl1.ClientMsg("Total Amount not matched with Invoice Amount.");
            return;
        }

        //if (Amount != Received)
        //{
        //    TrustControl1.ClientMsg("Cash Received Not Mached with Paid Amount.");
        //    return;
        //}

        //Call Save
        string StatusId = "";
        string Msg = "";
        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        WebReference_TitasMeter.TitasMBillPayment objTitasPay = new WebReference_TitasMeter.TitasMBillPayment();
        try
        {
            string ServiceResponse = objTitasPay.PostMeterPayment(hidRefID.Value, lblCusCode.Text.Trim(), lblinvoiceNo.Text.Trim(), PaidAmount, SourceTax, RevStamp, trnDate, Session["ROUTING"].ToString(), txtChalanNo.Text, chalanDT, txtChalanBank.Text.Trim(), txtChalanBankBranch.Text.Trim(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));
            StatusId = ServiceResponse.Split('|')[0];
            Msg = ServiceResponse.Split('|')[1];

            if (StatusId == "1")
            {
                //Paid
                cmdPay.Visible = false;
                txtSourceTax.Enabled = false;
                txtPaidAmount.Enabled = false;
                txtCashReceived.Enabled = false;
                txtCustomerContactNo.Enabled = false;
                litStatus1.Text = string.Format("<span class='green'>{1}</span> <a title='Open' href='Checkout_Link.aspx?refid={0}'>{0}</a>", hidRefID.Value, Msg);
            }
            else
                litStatus1.Text = string.Format("<span class='red'>{0}</span>", "Payment failed, " + Msg);
            //TrustControl1.ClientMsg("Valid.");
        }
        catch (Exception ex)
        {
            litStatus1.Text = string.Format("<span class='red'>{0}</span>", ex.Message);
            Common.WriteLog("cmdPay_Click", ex.Message);
        }
        //}
        //else
        //    TrustControl1.ClientMsg("Same day same customers second time payments in a Branch not allowed.");

    }

    //private bool CheckDuplicatePayment(string CustomerCode, string BranchCode)
    //{
    //    bool Done = false;

    //    try
    //    {
    //        using (SqlConnection conn = new SqlConnection())
    //        {
    //            string Query = "s_TitasDuplicatePayment_Check";//***
    //            conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

    //            using (SqlCommand cmd = new SqlCommand())
    //            {
    //                cmd.CommandText = Query;
    //                cmd.CommandType = System.Data.CommandType.StoredProcedure;

    //                cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = CustomerCode;
    //                cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = BranchCode;


    //                SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
    //                sqlDone.Direction = ParameterDirection.InputOutput;
    //                sqlDone.Value = 0;
    //                cmd.Parameters.Add(sqlDone);

    //                cmd.Connection = conn;
    //                conn.Open();

    //                cmd.ExecuteNonQuery();


    //                Done = (bool)sqlDone.Value;

    //            }

    //        }
    //    }
    //    catch (Exception ex)
    //    {
    //        Common.WriteLog("s_TitasDuplicatePayment_Check", ex.Message);
    //    }
    //    return Done;


    //}

    
   

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

}

public struct TmCustomerSearch
{

    public string status { get; set; }
    public string message { get; set; }
    public TmCustomerData data { get; set; }
}

public struct TmCustomerData
{

    public string invoiceNo { get; set; }
    public string customerCode { get; set; }
    public string customerName { get; set; }
    public double invoiceAmount { get; set; }

    public string issueMonth { get; set; }
    public string issueDate { get; set; }
    public string settleDate { get; set; }
    public string zone { get; set; }

}