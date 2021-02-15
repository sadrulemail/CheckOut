using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

public partial class Passport_Payment_Receipt_Status : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Title = "Passport Payment Receipt Status";
        if (!IsPostBack)
        {
            //WriteError(string.Empty);
            //ImgChallenge.Src = "captcha.ashx?rand=" + RandomNumer() + RandomNumer(); 
        }
    }
    protected void cmdCaptchReload_Click(object sender, EventArgs e)
    {
        txtCaptcha.Text = "";
    }
    protected void cmd_Click(object sender, EventArgs e)
    {
        long Mobile = 0;
        string CardNumber = "";

        if (!txtRefID.Text.StartsWith("3") || txtRefID.Text.Length != 14)
        {
            txtCaptcha.Text = ""; 
            ClientMsg("Enter a valid Reference Number", txtRefID);            
            return;
        }

       

        TrustCaptcha captcha = new TrustCaptcha();
        if (txtCaptcha.Text != string.Format("{0}", Session[TrustCaptcha.SESSION_CAPTCHA]))
        {
            txtCaptcha.Text = ""; 
            ClientMsg("Enter valid Challenge Key", txtCaptcha);            
            return;
        }

        PaymentReceiptStatus.Visible = false;
        PanelResult.Visible = true;

        

        //string Msg = "";
        //string KeyCode = "";

        //using (SqlConnection conn = new SqlConnection())
        //{
        //    string Query = "s_Passport_Payment_Print_Search";

        //    conn.ConnectionString = System.Configuration.ConfigurationManager
        //                    .ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

        //    using (SqlCommand cmd = new SqlCommand(Query, conn))
        //    {
        //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = txtRefID.Text;
        //        cmd.Parameters.Add("@Mobile", System.Data.SqlDbType.BigInt).Value = Mobile;
        //        cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = CardNumber;
        //     //   cmd.Parameters.Add("@PaidThrough", System.Data.SqlDbType.VarChar).Value = dboPaidThrough.SelectedItem.Value;

        //        SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
        //        SQL_Msg.Direction = ParameterDirection.InputOutput;
        //        SQL_Msg.Value = Msg;

        //        cmd.Parameters.Add(SQL_Msg);

        //        cmd.Connection = conn;
        //        conn.Open();

        //        using (SqlDataReader sdr = cmd.ExecuteReader())
        //        {
        //            if (sdr.HasRows)
        //            {
        //                while (sdr.Read())
        //                {
        //                    KeyCode = string.Format("{0}", sdr["KeyCode"]);
        //                }
        //            }
        //        }
        //        Msg = string.Format("{0}", SQL_Msg.Value);
        //    }
        //}

        //ClientMsg(Msg);

        //if (KeyCode.Length > 0)
        //{
        //    Response.Redirect(string.Format("Passport_Payment_Receipt.ashx?refid={0}&key={1}", txtRefID.Text, KeyCode), true);
        //}
    }

    public void ClientMsg(string MsgTxt, Control focusControl)
    {
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank', function(r){" + script1 + "});", true);
    }

    public void ClientMsg(string MsgTxt)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank')", true);
    }

    //protected void WriteError(string ErrorText)
    //{
    //    lblStatus.Text = ErrorText;
    //    PanelStatus.Visible = ErrorText.Trim() != string.Empty;
    //}

    protected string RandomNumer()
    {
        return (new Random().Next()).ToString();
    }
    protected void btnCheckAgain_Click(object sender, EventArgs e)
    {
        Response.Redirect("Passport_Payment_Receipt_Status.aspx");
    }
}