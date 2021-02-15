using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;

public partial class AK_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            this.Title = System.Configuration.ConfigurationSettings.AppSettings["AppTitle"].ToString() + " | Login";
        }
        catch (Exception) { }
        try
        {
            string CookieName = "Login_";
            if (Request.Cookies[CookieName] != null)
            {
                HttpCookie cookie = Request.Cookies.Get(CookieName);
                LoginTo(cookie.Values["Username"].ToString(), cookie.Values["Password"].ToString());
            }
        }
        catch (Exception) { }

        string focusScript = "document.getElementById('" + txtUserName.ClientID + "').focus();";
        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "clientScript", "setTimeout(\"" + focusScript + ";\",100);", true);

    }

    protected void cmdLogin_Click(object sender, EventArgs e)
    {
        Session["USERNAME"] = null;
        Session["APPID_ROLE"] = string.Empty;

        string UserName;
        try
        {
            UserName = txtUserName.Text.Trim();
        }
        catch (Exception)
        {
            ClientMsg("Please enter User Name and Password.");
            return;
        }

        if (chkRemember.Checked)
        {
            SetCookie();
        }

        LoginTo(UserName, txtPassword.Text);
    }

    private void SetCookie()
    {
        try
        {
            HttpCookie cookie = new HttpCookie("Login_");
            cookie.Values.Add("Username", txtUserName.Text);
            cookie.Values.Add("Password", EncodePassword(txtPassword.Text));
            cookie.Expires = DateTime.Now.AddMonths(1);
            Response.Cookies.Add(cookie);
        }
        catch (Exception) { }
    }
    private bool LoginTo(string UserName, string Password)
    {
        bool LoginSuccess = false;
        if (Password == string.Empty)
        {
            ClientMsg("Please enter Username and Password.");
            return false;
        }
        else
        {
            try
            {
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
                string Q = "execute s_getUser '" + UserName + "','" + Password + "'";
                SqlCommand oCommand = new SqlCommand(Q, oConn);

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();

                string Role = string.Empty;
                if (oReader.HasRows)
                {
                    while (oReader.Read())
                    {
                        //string PassHex = BitConverter.ToString(((byte[])(oReader["PassHex"])));
                        //if (PassHex == EncodePassword(Password) || PassHex == Password)
                        {
                            Session["USERNAME"] = oReader["UserName"].ToString();
                            Session["FULLNAME"] = oReader["FullName"].ToString();
                            Session["ROLES"] = oReader["UserRole"].ToString();
                            Session["EMAIL"] = oReader["Email"].ToString();
                            Session["ORGID"] = oReader["OrgID"].ToString();
                            Session["BID"] = oReader["BID"].ToString();
                            Session["OrganizationName"] = oReader["OrganizationName"].ToString();
                            Session["BranchID"] = oReader["BranchID"].ToString();
                            Session["BranchName"] = oReader["BranchName"].ToString();
                            LoginSuccess = true;
                        }
                    }
                }
                oConn.Close();

            }
            catch (Exception ex)
            {
                ClientMsg(ex.Message);
            }
            if (LoginSuccess)
            {
                try
                {
                    SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
                    SqlCommand oCommandLoginLog = new SqlCommand("s_LoginLog_Insert", oConn);
                    oCommandLoginLog.CommandType = CommandType.StoredProcedure;
                    oCommandLoginLog.Parameters.Add("@UserName", SqlDbType.VarChar).Value = UserName;
                    oCommandLoginLog.Parameters.Add("@IP", SqlDbType.Text).Value = getIPAddress();
                    oCommandLoginLog.Parameters.Add("@Browser", SqlDbType.Text).Value = getBrowserInfo();

                    if (oConn.State == ConnectionState.Closed)
                        oConn.Open();
                    oCommandLoginLog.ExecuteNonQuery();

                }
                catch (Exception ex)
                {
                    ClientMsg("Error2: " + ex.Message);
                }
                if (Request.QueryString["Prev"] != null)
                {
                    Response.Redirect(Request.QueryString["Prev"], true);
                }
                else
                {
                    Response.Redirect("Default.aspx", true);
                }
            }
        }
        ClientMsg("Please enter valid Username and Password.");
        return false;
    }
    public string EncodePassword(string OriginalPassword)
    {
        Byte[] originalBytes;
        Byte[] encodedBytes;
        MD5 md5;
        md5 = new MD5CryptoServiceProvider();
        originalBytes = ASCIIEncoding.Default.GetBytes(OriginalPassword);
        encodedBytes = md5.ComputeHash(originalBytes);
        return BitConverter.ToString(encodedBytes);
    }
    private void ClientMsg(string MsgTxt)
    {
        Panel1.Visible = true;
        Label1.Text = MsgTxt;
        //ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "alert('" + MsgTxt + "')", true);
    }

    protected string getIPAddress()
    {
        string Client_IP_Address = string.Empty;
        try
        {
            Client_IP_Address = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        }
        catch (Exception)
        {
            try
            {
                Client_IP_Address = HttpContext.Current.Request.UserHostAddress;
            }
            catch (Exception)
            {
                Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
            }
        }
        return Client_IP_Address;
    }

    protected string getBrowserInfo()
    {
        string Client_BrowserInfo = string.Empty;
        try
        {
            Client_BrowserInfo = HttpContext.Current.Request.Browser.Browser;
        }
        catch (Exception) { }
        try
        {
            Client_BrowserInfo += ", " + HttpContext.Current.Request.Browser.Version;
        }
        catch (Exception) { }
        //try
        //{
        //    Client_BrowserInfo += ", JavaScript:" + HttpContext.Current.Request.Browser["JavaScriptVersion"];
        //}
        //catch (Exception) { }
        try
        {
            Client_BrowserInfo += ", " + HttpContext.Current.Request.Browser.Platform;
        }
        catch (Exception) { }
        return Client_BrowserInfo;
    }
}
