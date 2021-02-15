using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using WebReference_mBillPlus;
using System.Web.Script.Serialization;

public partial class WestZoneReconDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }


    //protected void cmdOK_Click(object sender, EventArgs e)
    //{
    //    MbillPlus_payment mBill = new MbillPlus_payment();
    //  string Page_ID=  mBill.Reconcile_Summary(txtPayDate.Text, getValueOfKey("mBill_KeyCode"),int.Parse(ddlOtc.SelectedValue),Session["EMPID"].ToString());

    //    Response.Redirect("WestZoneReconcilation.aspx?pageid=" + Page_ID.Trim(), true);
    //    return;
    //}

    //protected void btnDetails_Click(object sender, EventArgs e)
    //{
    //    MbillPlus_payment mBill = new MbillPlus_payment();
    //    string Page_ID = mBill.Reconcile_Summary(txtPayDate.Text, getValueOfKey("mBill_KeyCode"), int.Parse(ddlOtc.SelectedValue), Session["EMPID"].ToString());

    //    Response.Redirect("WestZoneReconcilation.aspx?pageid=" + Page_ID.Trim(), true);
    //    return;
    //}

 

}

