using System;
using System.Web;


public partial class Logout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            Session["USERNAME"] = null;
            Session.Abandon();
            string CookieName = "Login_";
            try
            {
                HttpCookie cookie = new HttpCookie(CookieName);
                cookie.Values.Add("Username", "");
                cookie.Values.Add("Password", "");
                cookie.Expires = DateTime.Now.AddYears(-20);
                Response.Cookies.Add(cookie);
            }
            catch (Exception) { }
        }
        catch (Exception) { }
        Response.Redirect("~/Default.aspx", true);
    }
}
