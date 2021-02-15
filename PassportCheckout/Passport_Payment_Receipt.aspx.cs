using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

public partial class Passport_Payment_Receipt_Aspx : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Page.Title = "Passport Payment Receipt";
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
            ClientMsg("Enter a valid Reference Number");
            txtRefID.Focus();
            txtCaptcha.Text = ""; 
            return;
        }

        if (dboPaidThrough.SelectedItem.Value == "MM")
            if (!txtMobile.Text.StartsWith("880"))
            {
                ClientMsg("Enter a valid Mobile Number");
                txtMobile.Focus();
                txtCaptcha.Text = ""; 
                return;
            }
        else if (dboPaidThrough.SelectedItem.Value == "ITCL")
            if (txtCardNumber.Text.Length < 10)
            {
                ClientMsg("Enter a valid Card Number");
                txtCardNumber.Focus();
                txtCaptcha.Text = "";
                return;
            }

        TrustCaptcha captcha = new TrustCaptcha();
        if (txtCaptcha.Text != string.Format("{0}", Session[TrustCaptcha.SESSION_CAPTCHA]))
        {
            ClientMsg("Enter valid Challenge Key");
            txtCaptcha.Focus();
            txtCaptcha.Text = ""; 
            return;
        }

        try
        {
            if (dboPaidThrough.SelectedItem.Value == "MM")
                Mobile = long.Parse(txtMobile.Text.Trim());
        }
        catch (Exception)
        {
            ClientMsg("Enter a valid Mobile Number");
            txtMobile.Focus();
            txtCaptcha.Text = "";
            return;
        }

        
        if (dboPaidThrough.SelectedItem.Value == "ITCL")
            CardNumber = txtCardNumber.Text.Trim();
        

        //ClientMsg(string.Empty);

        string Msg = "";
        string KeyCode = "";

        using (SqlConnection conn = new SqlConnection())
        {
            string Query = "s_Passport_Payment_Print_Search";

            conn.ConnectionString = System.Configuration.ConfigurationManager
                            .ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

            using (SqlCommand cmd = new SqlCommand(Query, conn))
            {
                cmd.CommandType = System.Data.CommandType.StoredProcedure;
                cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = txtRefID.Text;
                cmd.Parameters.Add("@Mobile", System.Data.SqlDbType.BigInt).Value = Mobile;
                cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = CardNumber;
                cmd.Parameters.Add("@PaidThrough", System.Data.SqlDbType.VarChar).Value = dboPaidThrough.SelectedItem.Value;

                SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                SQL_Msg.Direction = ParameterDirection.InputOutput;
                SQL_Msg.Value = Msg;

                cmd.Parameters.Add(SQL_Msg);

                cmd.Connection = conn;
                conn.Open();

                using (SqlDataReader sdr = cmd.ExecuteReader())
                {
                    if (sdr.HasRows)
                    {
                        while (sdr.Read())
                        {
                            KeyCode = string.Format("{0}", sdr["KeyCode"]);
                        }
                    }
                }
                Msg = string.Format("{0}", SQL_Msg.Value);
            }
        }

        ClientMsg(Msg);

        if (KeyCode.Length > 0)
        {
            Response.Redirect(string.Format("Passport_Payment_Receipt.ashx?refid={0}&key={1}", txtRefID.Text, KeyCode), true);
        }
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
}