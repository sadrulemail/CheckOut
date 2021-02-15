using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Script.Serialization;

public partial class Titas_Payment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        if (!IsPostBack)
        {
            txtCustomerID.Focus();
        }
    }

    private void ClearForm()
    {        
        lblCusName.Text = "";
        lblCusAddress.Text = "";
        lblApplicance.Text = "";
        txtParticulars.Text = "";
        txtSurcharge.Text = "";
        txtBillAmount.Text = "";
        txtTotalBill.Text = "";
        txtCashReceived.Text = "";
        txtCustomerContactNo.Text = "";
        litStatus1.Text = "";

        cmdPay.Visible = true;
        txtParticulars.Enabled = true;
        txtSurcharge.Enabled = true;
        txtBillAmount.Enabled = true;
        txtCashReceived.Enabled = true;
        txtCustomerContactNo.Enabled = true;

        litStatus2.Text = "";
        txtCashReceived2.Text = "";
        txtCustomerContactNo2.Text = "";

        cmdPay2.Visible = true;
        txtCashReceived2.Enabled = true;
        txtCustomerContactNo2.Enabled = true;

        litStatus3.Text = "";
        txtCashReceived3.Text = "";
        txtCustomerContactNo3.Text = "";

        cmdPay3.Visible = true;
        txtCashReceived3.Enabled = true;
        txtCustomerContactNo3.Enabled = true;
        hidRefID.Value = "";
        hidPayID.Value = "";
        lblCustomerID3.Text = "";

    }

    protected void dboPaymentType_SelectedIndexChanged(object sender, EventArgs e)
    {
        ClearForm();
        if (dboPaymentType.SelectedItem.Value == "1")
        {
            Panel1.Visible = true;
            Panel2.Visible = false;
            Panel3.Visible = false;
            txtCustomerID.Text = "";            
            txtCustomerID.Focus();
            PanelCusInfo.Visible = false;
            PanelPaymentInfo.Visible = false;
        }
        else if (dboPaymentType.SelectedItem.Value == "2")
        {
            Panel1.Visible = false;
            Panel2.Visible = true;
            Panel3.Visible = false;
            txtInvoiceNumber2.Text = "";
            txtInvoiceNumber2.Focus();
            PanelCusInfo2.Visible = false;
            PanelPaymentInfo2.Visible = false;
        }
        else if(dboPaymentType.SelectedItem.Value == "3")
        {
            Panel1.Visible = false;
            Panel2.Visible = false;
            Panel3.Visible = true;
            txtInvoiceNumber3.Text = "";
            txtInvoiceNumber3.Focus();
            PanelCusInfo3.Visible = false;
            PanelPaymentInfo3.Visible = false;
        }
    }

    protected void cmdSearch_Click(object sender, EventArgs e)
    {
       // string rout = Session["Routing"].ToString();
        ClearForm();
        try
        {
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
            string json_status = objTitasPay.GetCustomerInformation(txtCustomerID.Text.Trim(), Session["Routing"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));

            string[] jsonRtn = new string[2];
            jsonRtn = json_status.Split('|');
            hidRefID.Value = jsonRtn[0];
            if (jsonRtn[0] != "")
            {
                TtCustomerInfo payment = jsonSerializer.Deserialize<TtCustomerInfo>(jsonRtn[1]);


                //Data Found
                PanelCusInfo.Visible = true;
                PanelPaymentInfo.Visible = true;
                litStatus1.Text = "";

                lblCusCode.Text = payment.data.customerCode;
                lblCusName.Text = payment.data.customerName;
                lblCusAddress.Text = payment.data.connectionAddress;
                lblApplicance.Text = payment.data.applianceSummary;
                txtParticulars.Focus();

                hidRefID.Value = jsonRtn[0];
                hidPayID.Value = payment.data.id;

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
        catch (Exception ex)
        {
           
            Common.WriteLog("cmdSearch_Click Payment Entry", ex.Message, "TITAS");
        }
    }

    protected void cmdPay_Click(object sender, EventArgs e)
    {

        bool isDuplicate = CheckDuplicatePayment(lblCusCode.Text, Session["BRANCHID"].ToString(), "");
        if (!isDuplicate)
        {

            litStatus1.Text = "";
            string Particulars = txtParticulars.Text;
            string[] Ps = Particulars.Split(new Char[] { ',' });
            bool isParticulatsOK = true;

            foreach (string P in Ps)
            {
                //litStatus1.Text += "."+ P.Substring(2, 2);
                try
                {
                    if (P.Length == 4)
                    {
                        int MM = int.Parse(P.Substring(0, 2));
                        int YY = int.Parse(P.Substring(2, 2));
                        int CurrentY = DateTime.Now.Year - 2000;
                        //litStatus1.Text += "." + CurrentY;

                        if (MM < 0) isParticulatsOK = false;
                        if (MM > 12) isParticulatsOK = false;

                        if (YY < CurrentY - 10) isParticulatsOK = false;
                        if (YY > CurrentY + 5) isParticulatsOK = false;
                    }
                    else
                        isParticulatsOK = false;
                }
                catch (Exception)
                {
                    isParticulatsOK = false;
                }
            }
            if (!isParticulatsOK)
            {
                TrustControl1.ClientMsg("Invalid Particulars.<br>Use format: MMYY,MMYY,MMYY");
                return;
            }

            double Surcharge = 0;
            double Amount = 0;
            double Total = 0;
            double Received = 0;
            long Mobile;
            

            try
            {
                Surcharge = double.Parse(txtSurcharge.Text == "" ? "0" : txtSurcharge.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Surcharge.");
                return;
            }

            try
            {
                Amount = double.Parse(txtBillAmount.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Amount.");
                return;
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

            try
            {
                Received = double.Parse(txtCashReceived.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Received Amount.");
                return;
            }

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

            if (Total != Received)
            {
                TrustControl1.ClientMsg("Cash Received Not Mached with Total Amount.");
                return;
            }
            //litStatus1.Text = Mobile.ToString();
            //return;

            //Call Save
            string StatusId = "";
            string Msg = "";
            

            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
            try
            {
                string ServiceResponse = objTitasPay.PostPaymentEntry(hidRefID.Value, hidPayID.Value, Particulars, MobileStr.ToString(), Amount, Surcharge, Session["ROUTING"].ToString(), lblCusCode.Text, Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode")); //"1337B4100011E2|Successfully Paid.";
                StatusId = ServiceResponse.Split('|')[0];
                Msg = ServiceResponse.Split('|')[1];

                if (StatusId == "1")
                {
                    //Paid
                    cmdPay.Visible = false;
                    txtParticulars.Enabled = false;
                    txtSurcharge.Enabled = false;
                    txtBillAmount.Enabled = false;
                    txtCashReceived.Enabled = false;
                    txtCustomerContactNo.Enabled = false;
                    litStatus1.Text = string.Format("<span class='green'>{1}</span> <a title='Open' href='Checkout_Link.aspx?refid={0}'>{0}</a>", hidRefID.Value, Msg);
                }
                else
                    litStatus1.Text = string.Format("<span class='red'>{0}</span>", Msg);
                //TrustControl1.ClientMsg("Valid.");
            }
            catch (Exception ex)
            {
                litStatus1.Text = string.Format("<span class='red'>{0}</span>", ex.Message);
                Common.WriteLog("cmdPay_Click Payment Entry", ex.Message,"TITAS");
            }
        }
        else
            TrustControl1.ClientMsg("Same day same customers second time payments in a Branch not allowed.");
      
}

    private bool CheckDuplicatePayment(string CustomerCode,string BranchCode, string InvoiceNo)
    {
        bool Done = false;
   
        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TitasDuplicatePayment_Check";//***
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@CustomerCode", System.Data.SqlDbType.VarChar).Value = CustomerCode;
                    cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = BranchCode;
                    cmd.Parameters.Add("@InvoiceNo", System.Data.SqlDbType.VarChar).Value = InvoiceNo;


                    SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.Bit);
                    sqlDone.Direction = ParameterDirection.InputOutput;
                    sqlDone.Value = 0;
                    cmd.Parameters.Add(sqlDone);

                    cmd.Connection = conn;
                    conn.Open();

                    cmd.ExecuteNonQuery();


                    Done = (bool)sqlDone.Value;

                }

            }
        }
        catch (Exception ex)
        {
            Common.WriteLog("s_TitasDuplicatePayment_Check", ex.Message,"TITAS");
        }
        return Done;


    }

    protected void cmdSearch2_Click(object sender, EventArgs e)
    {
        ClearForm();

        JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
        WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
        string json_status = objTitasPay.GetDemandNoteInformation(txtCustomerID.Text.Trim(), Session["Routing"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));

        string[] jsonRtn = new string[2];
        jsonRtn = json_status.Split('|');
        hidRefID.Value = jsonRtn[0];
        if (jsonRtn[0] != "")
        {
            TtDemandNote payment = jsonSerializer.Deserialize<TtDemandNote>(jsonRtn[1]);


            //Data Found
            PanelCusInfo2.Visible = true;
            PanelPaymentInfo2.Visible = true;
            litStatus2.Text = "";

            lblInvoice3.Text = payment.data.invoiceNo;
            lblCustomerName2.Text = payment.data.customerName;
            lblCusAddress2.Text = payment.data.connectionAddress;
            lblDueDate3.Text = payment.data.dueDate;
            txtTotalBill2.Text = string.Format("{0:N2}", payment.data.paymentAmount);
          //  lblCustomerID2.Text = string.Format("{0:N2}", payment.data.customerId);
            txtCashReceived2.Focus();

            hidRefID.Value = jsonRtn[0];
          

        }
        else
        {
            //Data Not Found
            PanelCusInfo2.Visible = false;
            PanelPaymentInfo2.Visible = false;
            litStatus1.Text = "Data Not Found.";
            txtInvoiceNumber2.Focus();

            hidRefID.Value = "";
            hidPayID.Value = "";
        }
      
    }

    protected void cmdPay2_Click(object sender, EventArgs e)
    {
        bool isDuplicate = CheckDuplicatePayment(lblCusCode.Text, Session["BRANCHID"].ToString(),"");
        if (!isDuplicate)
        {
            double Received = 0;
            double Total = 0;
            long Mobile = 0;

            try
            {
                Total = double.Parse(txtTotalBill2.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Total.");
                return;
            }

            try
            {
                Received = double.Parse(txtCashReceived2.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Received Amount.");
                return;
            }

            if (Total != Received)
            {
                TrustControl1.ClientMsg("Cash Received Not Mached with Total Amount.");
                return;
            }

            try
            {
                Mobile = long.Parse(txtCustomerContactNo2.Text);
            }
            catch (Exception)
            {
                TrustControl1.ClientMsg("Invalid Mobile Number.<br>Format: +8801xxxxxxxxx");
                return;
            }

            //Call Save
            string StatusId = "";
            string Msg = "";
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
            try
            {
                string ServiceResponse = objTitasPay.PostDemandNotePayment(hidRefID.Value, txtInvoiceNumber3.Text
                    ,lblCustomerID3.Text, Session["ROUTING"].ToString(), txtCustomerContactNo3.Text, Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode")); //"1337B4100011E2|Successfully Paid.";
                StatusId = ServiceResponse.Split('|')[0];
                Msg = ServiceResponse.Split('|')[1];

                if (StatusId == "1")
                {
                    //Paid
                    cmdPay.Visible = false;
                    txtParticulars.Enabled = false;
                    txtSurcharge.Enabled = false;
                    txtBillAmount.Enabled = false;
                    txtCashReceived.Enabled = false;
                    txtCustomerContactNo.Enabled = false;
                    litStatus1.Text = string.Format("<span class='green'>{1}</span> <a title='Open' href='Checkout_Link.aspx?refid={0}'>{0}</a>", hidRefID.Value, Msg);
                }
                else
                    litStatus1.Text = string.Format("<span class='red'>{0}</span>", Msg);
                //TrustControl1.ClientMsg("Valid.");
            }
            catch (Exception ex)
            {
                litStatus1.Text = string.Format("<span class='red'>{0}</span>", ex.Message);
                Common.WriteLog("cmdPay_Click", ex.Message,"TITAS");
            }
        }
        else
            TrustControl1.ClientMsg("Same day same customers second time payments in a Branch not allowed.");


    }




    protected void cmdSearch3_Click(object sender, EventArgs e)
    {
        ClearForm();
        try
        {
            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
            string json_status = objTitasPay.GetDemandNoteInformation(txtInvoiceNumber3.Text.Trim(), Session["Routing"].ToString(), Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));

            string[] jsonRtn = new string[2];
            jsonRtn = json_status.Split('|');
            hidRefID.Value = jsonRtn[0];
            if (jsonRtn[0] != "")
            {
                TtDemandNote payment = jsonSerializer.Deserialize<TtDemandNote>(jsonRtn[1]);

                //Data Found
                PanelCusInfo3.Visible = true;
                PanelPaymentInfo3.Visible = true;
                litStatus3.Text = "";

                lblInvoice3.Text = payment.data.invoiceNo;
                lblCustomerName3.Text = payment.data.customerName;
                lblCusAddress3.Text = payment.data.connectionAddress;
                lblDueDate3.Text = payment.data.dueDate;
                txtTotalBill3.Text = string.Format("{0:N2}", payment.data.paymentAmount);
                lblCustomerID3.Text = payment.data.customerId;
                txtCashReceived3.Focus();
                hidRefID.Value = jsonRtn[0];

            }
            else
            {
                //Data Not Found
                PanelCusInfo3.Visible = false;
                PanelPaymentInfo3.Visible = false;
                litStatus3.Text = "Data Not Found. "+ jsonRtn[1];
                txtInvoiceNumber3.Focus();

                hidRefID.Value = "";

            }
        }
        catch (Exception ex)
        {
            
            Common.WriteLog("cmdPay_Click Demand Note", ex.Message, "TITAS");
        }

    }

    protected void cmdPay3_Click(object sender, EventArgs e)
    {
        bool isDuplicate = CheckDuplicatePayment("", Session["BRANCHID"].ToString(), lblInvoice3.Text.Trim());
        if (!isDuplicate)
        {
            double Received = 0;
            double Total = 0;
            long Mobile;
      //  long Mobile = 0;

        try
        {
            Total = double.Parse(txtTotalBill3.Text);
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Total.");
            return;
        }

        try
        {
            Received = double.Parse(txtCashReceived3.Text);
        }
        catch (Exception)
        {
            TrustControl1.ClientMsg("Invalid Received Amount.");
            return;
        }

        if (Total != Received)
        {
            TrustControl1.ClientMsg("Cash Received Not Mached with Total Amount.");
            return;
        }

            string MobileStr = "";
            if (txtCustomerContactNo3.Text.Trim().Length < 11)
            {
                try
                {
                    Mobile = long.Parse("88" + txtCustomerContactNo3.Text);
                    MobileStr = Mobile.ToString();
                }
                catch (Exception)
                {
                    TrustControl1.ClientMsg("Invalid Mobile Number.<br>Format: 01xxxxxxxxx");
                    return;
                }
            }

            //Call Save
            string StatusId = "";
            string Msg = "";

            //litStatus3.Text = hidRefID.Value;
            //return;

            JavaScriptSerializer jsonSerializer = new JavaScriptSerializer();
            WebReference_Titas.TitasBillPayment objTitasPay = new WebReference_Titas.TitasBillPayment();
            try
            {
                string ServiceResponse = objTitasPay.PostDemandNotePayment(hidRefID.Value, txtInvoiceNumber3.Text.Trim(), lblCustomerID3.Text, Session["ROUTING"].ToString(), MobileStr, Session["EMPID"].ToString(), getValueOfKey("Titas_KeyCode"));
                StatusId = ServiceResponse.Split('|')[0];
                Msg = ServiceResponse.Split('|')[1];

                if (StatusId == "1")
                {
                    //Paid
                    cmdPay3.Visible = false;
                    txtCashReceived3.Enabled = false;
                    txtCustomerContactNo3.Enabled = false;
                    litStatus3.Text = string.Format("<span class='green'>{1}</span> <a title='Open' href='Checkout_Link.aspx?refid={0}'>{0}</a>", hidRefID.Value, Msg);
                }
                else
                    litStatus3.Text = string.Format("<span class='red'>{0}</span>", Msg);
                //TrustControl1.ClientMsg("Valid.");
            }
            catch (Exception ex)
            {
                litStatus3.Text = string.Format("<span class='red'>{0}</span>", ex.Message);
                Common.WriteLog("cmdPay_Click Demand Note", ex.Message,"TITAS");
            }
         
        }
        else
            TrustControl1.ClientMsg("Same day same  Branch duplicate payment not allowed.");
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

}

public struct TtCustomerInfo
{

    public string status { get; set; }
    public string message { get; set; }
    public TtData data { get; set; }
}

public struct TtData
{

    public string id { get; set; }
    public string customerCode { get; set; }
    public string customerName { get; set; }
    public string applianceSummary { get; set; }
    public string connectionAddress { get; set; }
    public string mobile { get; set; }

}
public struct TtDemandNote
{

    public string status { get; set; }
    public string message { get; set; }
    public TtDemandNoteData data { get; set; }
}

public struct TtDemandNoteData
{

    public string invoiceNo { get; set; }
    public string dueDate { get; set; }
    public double paymentAmount { get; set; }
    public string customerCode { get; set; }
    public string customerId { get; set; }

    public string customerName { get; set; }
    public string connectionAddress { get; set; }
    public string mobile { get; set; }

}