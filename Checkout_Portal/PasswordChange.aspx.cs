using System;
using System.Data;
using System.Data.SqlClient;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        ErrorDiv.Visible = false;
        if (Session["EMPID"] == null)
            Response.Redirect("Login.aspx?Prev=PasswordChange.aspx", true);

        if (!IsPostBack)
        {
            txtPassword.Focus();
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
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand("ChangePassword", oConn);
            oCommand.CommandType = CommandType.StoredProcedure;

            if(oConn.State == ConnectionState.Closed)
                oConn.Open();
            oCommand.Parameters.Add("@param_OldPassword", SqlDbType.VarChar).Value = txtPassword.Text;
            oCommand.Parameters.Add("@param_NewPassword", SqlDbType.VarChar).Value = txtNewPassword.Text;
            oCommand.Parameters.Add("@param_EmpID", SqlDbType.VarChar).Value = Session["EMPID"].ToString();
            string Client_IP_Address = string.Empty;
            try
            {
                Client_IP_Address = Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
            }
            catch (Exception)
            {
                Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
            }
            oCommand.Parameters.Add("@param_IP", SqlDbType.Text).Value = Client_IP_Address;

            int ROW_AFFECTED = (int)oCommand.ExecuteScalar();
            oConn.Close();

            //Response.Write(ROW_AFFECTED.ToString());

            if (ROW_AFFECTED.ToString() == "0")
            {
                ErrorDiv.Visible = true;
                lblErrorMsg.Text = "Password Not Matched";
            }
            else
            {
                Panel2.Visible = false;
                Panel1.Visible = true;
                //Session.Abandon();
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
            Response.End();
        }
    }
    protected void cmdCancel_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["Prev"] == null)
            Response.Redirect("Default.aspx");
        else
            Response.Redirect(Request.QueryString["Prev"]);
    }
    protected void cmdLogingAgain_Click(object sender, EventArgs e)
    {
        if (Request.QueryString["Prev"] == null)
            Response.Redirect("Default.aspx");
        else
            Response.Redirect(Request.QueryString["Prev"]);
    }
}