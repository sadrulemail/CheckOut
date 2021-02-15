using System;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class PasswordChange : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ErrorDiv.Visible = false;
        if (!IsPostBack)
        {
            string focusScript = "document.getElementById('" + txtPassword.ClientID + "').focus();";
            AKControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",100);");
        }
    }

    protected void cmdChangePassword_Click(object sender, EventArgs e)
    {
        if (txtNewPassword.Text.Length < 5)
        {
            ErrorDiv.Visible = true;
            lblErrorMsg.Text = "Password is too small";
            return;
        }
        if (txtNewPassword.Text != txtRePassword.Text)
        {
            ErrorDiv.Visible = true;
            lblErrorMsg.Text = "Re-type Password Not Matched";
            return;
        }

        try
        {
            SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            //AKControl1.ClientMsg(HiddenField1.Value);
            //SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
            //SqlCommand oCommand = new SqlCommand("sp_password_change", oConn);
            //oCommand.CommandType = CommandType.StoredProcedure;

            //if (oConn.State == ConnectionState.Closed)
            //    oConn.Open();
            //oCommand.Parameters.Add("@PasswordOld", SqlDbType.VarChar).Value = txtPassword.Text;
            //oCommand.Parameters.Add("@PasswordNew", SqlDbType.VarChar).Value = txtNewPassword.Text;
            //oCommand.Parameters.Add("@Username", SqlDbType.VarChar).Value = Session["USERNAME"].ToString();
            //oCommand.Parameters.Add("@Msg", SqlDbType.VarChar).Direction = ParameterDirection.Output;
            //string Client_IP_Address = string.Empty;
            //try
            //{
            //    Client_IP_Address = Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            //}
            //catch (Exception)
            //{
            //    Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
            //}
            //oCommand.Parameters.Add("@IP", SqlDbType.Text).Value = Client_IP_Address;

            //oCommand.ExecuteNonQuery();
            //oConn.Close();

            //Response.Write(ROW_AFFECTED.ToString());

            //if (ROW_AFFECTED.ToString() == "0")
            //{
            //    ErrorDiv.Visible = true;
            //    lblErrorMsg.Text = "Password Not Matched";
            //}
            //else
            //{
            //    Panel2.Visible = false;
            //    Panel1.Visible = true;
            //    Session.Abandon();
            //}
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
            Response.End();
        }
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        ErrorDiv.Visible = true;
        lblErrorMsg.Text = e.Command.Parameters["@Msg"].Value.ToString();
        if (lblErrorMsg.Text == "Password Changed.")
        {
            Panel2.Visible = false;
            Panel1.Visible = true;
            Session.Abandon();
        }
        return;
    }
}
