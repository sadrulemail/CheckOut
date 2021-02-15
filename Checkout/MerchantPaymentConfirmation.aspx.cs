using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Configuration;
using System.Xml;

public partial class MerchantPaymentConfirmation : System.Web.UI.Page
{
    string StatusID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Title = string.Format("{0}", "Merchant Payment Confirmation");

        //ClientMsgAndFocusControl("Test Message", "");
        //return;


        if (!IsPostBack)
        {
            //ClientMsg("Bill has been updated to BGDCL's Server Successfully.");
            //lblOrderID.Text = string.Format("{0}", Request.QueryString["orderid"]);
            //lblRefID.Text = string.Format("{0}", Request.QueryString["refid"]);
            //lblAmount.Text = string.Format("{0}", Request.QueryString["amount"]);
            //lblPayStatus.Text = string.Format("{0}", Request.QueryString["status"]);
            //lblBank.Text = string.Format("{0}", Request.QueryString["bank"]);
            string xml_msg = DecodeFrom64(string.Format("{0}", Request.Form["CheckoutXmlMsg"]));
            if (xml_msg != "")
            {
                GetMerPayConfirmation_Xml(xml_msg);
                //Response.Redirect("MerchantPaymentConfirmation.aspx", true);
            }
            //else
            //{
            //    ClientMsg("Payment has not been completed.");
            //}
        }
    }

    static public string DecodeFrom64(string encodedData)
    {
        byte[] encodedDataAsBytes
            = System.Convert.FromBase64String(encodedData);
        string returnValue =
           System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes);
        return returnValue;
    }

    private void GetMerPayConfirmation_Xml(string xml_msg)
    {
        string ref_id = "";
        string order_id = "";
        decimal amount = 0;
        string pay_type = "";
        string merchant_id = "";
        XmlDocument x = new XmlDocument();
        if (xml_msg != "")
        {
          x.LoadXml(xml_msg);
        }

        ref_id = x.GetElementsByTagName("RefID")[0].InnerText;
        order_id = x.GetElementsByTagName("OrderID")[0].InnerText;
        pay_type = x.GetElementsByTagName("PaymentType")[0].InnerText;
        merchant_id = x.GetElementsByTagName("MarchentID")[0].InnerText;
        amount = decimal.Parse(x.GetElementsByTagName("TotalAmount")[0].InnerText == "" ? "0" : x.GetElementsByTagName("TotalAmount")[0].InnerText);

        String done = "0";
        done = VerifyMerchantPayment(ref_id, order_id, amount);

  
            hidMerchantID.Value = merchant_id;
            hidOrderID.Value = order_id;
            hidRefID.Value = ref_id;
      

        if (done == "1" && merchant_id == "BGSL")
        {
            BGSL.BGSL_Payment bgsl_service
              = new BGSL.BGSL_Payment();
            //string service_result = "1";
            string service_result = bgsl_service.OnlinePayment_Confirmation(ref_id, pay_type);
            if (service_result == "1")
            {
                //string script = string.Format("alert('{0}');", "Bill has been updated to BGDCL's Server Successfully.");

                ClientMsg("Bill has been updated to BGDCL's Server Successfully.");
                //if (Page != null && !Page.ClientScript.IsClientScriptBlockRegistered("alert"))
                {
                   // Page.ClientScript.RegisterClientScriptBlock(Page.GetType(), "alert", script, true /* addScriptTags */);
                }
                // ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Bill has been updated to BGDCL's Server Successfully.');", true);
            }
            else
                ClientMsg("Bill paid but has not been updated to BGDCL's Server end.");
            // ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('Bill paid but has not been updated to BGDCL's Server end.');", true);
        }
       else if (done == "1" && merchant_id == "WZPDCL")
       {
            mBillPlusService.MbillPlus_payment mBill_service
                = new mBillPlusService.MbillPlus_payment();

            string service_result = mBill_service.Confirm_Payment_Online(ref_id, getValueOfKey("mBill_KeyCode"));
            if (service_result == "400")
            {
                ClientMsg("Bill has been updated to WZPDCL Server Successfully.");
            }
            else
            {
                ClientMsg("Bill paid but has not been updated to WZPDCL Server end.");
            }
        }
        else if (done == "1" && merchant_id == "NID")
        {
            NidPayment.NID_Payment nid_service
                = new NidPayment.NID_Payment();

            //string service_result = nid_service.ConfirmPayment(ref_id, getValueOfKey("NID_KeyCode"),"",""); // ConfirmPaymentOnline
            string service_result = "1";
            if (service_result == "1")
            {
                ClientMsg("Bill has been updated to NID Server Successfully.");
            }
            else
            {
                ClientMsg("Bill paid but has not been updated to NID Server end.");
            }
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
    protected string VerifyMerchantPayment(string ref_id, string order_id, decimal amount)
    {
        string done = "0";
        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Payments_Checkout_Verify";
            conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand())
            {
                cmd.CommandText = Query;
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = ref_id;
                cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = order_id;
                cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = amount;
                cmd.Parameters.Add("@isWebserviceCalled", System.Data.SqlDbType.Bit).Value = false;

                SqlParameter sqlDone = new SqlParameter("@Done", System.Data.SqlDbType.TinyInt);
                sqlDone.Direction = System.Data.ParameterDirection.InputOutput;
                sqlDone.Value = 0;
                cmd.Parameters.Add(sqlDone);

                cmd.Connection = conn;
                conn.Open();

                cmd.ExecuteNonQuery();
                done = string.Format("{0}", sqlDone.Value);
            }
        }
        return done;
    }

    protected void DetailsViewPayStatus_DataBound(object sender, EventArgs e)
    {
        lblMarchentName1.Text = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "MarchentName"));
        StatusID = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "Status"));
      lblImage.Text = string.Format("<img src='Images/Marchent/{0}' style='max-width:125px' />", DataBinder.Eval(DetailsViewPayStatus.DataItem, "MarchentLogoURL"));
        lblImage.NavigateUrl = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "MarchentCompanyURL"));
        //  string cc = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "ShowPrintButton"));
        try
        {
            if ((Boolean)DataBinder.Eval(DetailsViewPayStatus.DataItem, "ShowPrintButton") == true)
                hypPrint.Visible = true;
            else
                hypPrint.Visible = false;
        }
        catch(Exception ex)
        {
            hypPrint.Visible = false;
        }

        string refID= string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "RefID"));
        string keyCode = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "KeyCode"));
        string merchantID = string.Format("{0}", DataBinder.Eval(DetailsViewPayStatus.DataItem, "MarchentID"));
        string PrintURL= "Checkout_Payment_Receipt.ashx";
        hypPrint.NavigateUrl = string.Format("{0}?refid={1}&key={2}&merid={3}", PrintURL, refID, keyCode, merchantID);
    }

    public string getTitleClass()
    {
        if (StatusID == "1") ;
        return "panel-success";

        return "panel-danger";
    }

    protected void ClientMsgAndFocusControl(string MsgTxt, string focusControl)
    {
        string script1 = "";
        if (focusControl != "")
            script1 = "$('#" + focusControl + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "bootbox.alert('" + MsgTxt + "', function(){setTimeout(function(){" + script1 + "},100)});", true);
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