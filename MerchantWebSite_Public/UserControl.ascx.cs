using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;

public partial class UserControl : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        this.Page.Culture = "en-NZ";
        LoadUserInfo();
        Session["SessionID"] = Session.SessionID;
    }

    private void LoadUserInfo()
    {
        string UrlPrefix = "";
        UrlPrefix = Request.Url.OriginalString.Replace(Request.Url.PathAndQuery, "");
        UrlPrefix += "/" + Request.Url.Segments[1];

        if (Session.IsNewSession || Session["USERNAME"] == null)
        {
            Response.Redirect("Default.aspx?prev=" + Request.Url.ToString().Replace("&", "%26"), true);
        }
        else
            try
            {
                //((Literal)(this.Page.Master.FindControl("LoginStatus"))).Text = string.Format("Hi, <b>{0}</b> ({1})<br /><br />Role: <b>{2}</b> <a href='Logout.aspx' class='ButtonSmall'>Logout</a>"
                //    , Session["FULLNAME"], Session["USERNAME"], Session["ROLES"].ToString().Replace(",", ", "));

                //Load Sessions
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);
                string Q = "execute sp_getUser '" + Session["USERNAME"].ToString() + "', NULL";
                SqlCommand oCommand = new SqlCommand(Q, oConn);

                if (oConn.State == ConnectionState.Closed)
                    oConn.Open();

                SqlDataReader oReader = oCommand.ExecuteReader();
                if (oReader.HasRows)
                {
                    while (oReader.Read())
                    {
                        {
                            Session["USERNAME"] = oReader["UserName"].ToString();
                            Session["FULLNAME"] = oReader["FullName"].ToString();
                            Session["ROLES"] = "USER";
                            Session["EMAIL"] = oReader["Email"].ToString();
                            Session["USERID"] = oReader["USERID"].ToString();
                        }
                    }
                }
                oConn.Close();


                //Check Roles
                bool isRoleAssigned = false;
                string[] Roles = Session["ROLES"].ToString().Split(',');

                for (int i = 0; i < SiteMap.CurrentNode.Roles.Count; i++)
                    foreach (string Role in Roles)
                        if (SiteMap.CurrentNode.Roles[i].ToString() == Role
                            || SiteMap.CurrentNode.Roles[i].ToString() == "*")
                        {
                            isRoleAssigned = true;
                            goto RoleAssigned;
                        }
            RoleAssigned:
                if (!isRoleAssigned)
                {
                    Response.Write("You have no permission to use this page.");
                    Response.End();
                }
            }
            catch (Exception) { }

        ((Literal)(this.Page.Master.FindControl("LoginStatus"))).Text = string.Format("<b>{0}</b><br>{1}"
            , Session["FULLNAME"], Session["USERNAME"], Session["ROLES"].ToString().Replace(",", ", "));
    }

    public string getUsername()
    {
        try
        {
            return Session["USERNAME"].ToString();
        }
        catch(Exception)
        {
            Response.End();
            return "";
        }
    }

    public bool isRole(string RoleName)
    {
        string[] Roles = Session["ROLES"].ToString().Split(',');
        foreach (string Role in Roles)
            if (Role.Trim().ToLower() == RoleName.Trim().ToLower())
                return true;
        return false;
    }
    public string ToRecentDateTime(object input)
    {
        try
        {
            return ToRecentDateTime((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRecentDateTime(DateTime input)
    {
        string RetVal = "";

        TimeSpan difference = (DateTime.Now.Date - input.Date);
        double millisecondsDifference = difference.TotalMilliseconds;
        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        if (input.Date == DateTime.Now.Date)
            RetVal = String.Format("{0:h:mm tt}", input);
        else if (days < 2)
            RetVal = "Yesterday, " + String.Format("{0:h:mm tt}", input);
        else if (days < 7)
            RetVal = String.Format("{0:dddd, h:mm tt}", input);
        else if (DateTime.Now.Year == input.Date.Year)
            RetVal = String.Format("{0:d MMM, h:mm tt}", input);
        else
            RetVal = String.Format("{0:d MMM yyyy, h:mm tt}", input);

        return RetVal.Replace(".", "");
    }

    public string ToRecentDate(object input)
    {
        try
        {
            return ToRecentDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRecentDate(DateTime input)
    {
        TimeSpan difference = (DateTime.Now.Date - input.Date);
        double millisecondsDifference = difference.TotalMilliseconds;
        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        string RetVal = "";
        if (input.Date == DateTime.Now.Date)
            RetVal = "Today";
        else if (days < 2)
            RetVal = "Yesterday";
        else if (days < 7)
            RetVal = String.Format("{0:dddd}", input);
        else if (DateTime.Now.Year == input.Date.Year)
            RetVal = String.Format("{0:d MMMM}", input);
        else
            RetVal = String.Format("{0:d MMMM yyyy}", input);

        return RetVal.Replace(".", "");
    }

    public string ToRelativeDate(object input)
    {
        try
        {
            return ToRelativeDate((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public string ToRelativeDate(DateTime input)
    {
        string suffix = "ago";
        TimeSpan difference = (DateTime.Now - input);
        double millisecondsDifference = difference.TotalMilliseconds;

        if ((millisecondsDifference < 0))
        {
            suffix = "from now";
            millisecondsDifference = Math.Abs(millisecondsDifference);
        }

        double seconds = millisecondsDifference / 1000;
        double minutes = seconds / 60;
        double hours = minutes / 60;
        double days = hours / 24;
        double years = days / 365;

        string relativeDate = string.Empty;

        if ((seconds < 45))
        {
            relativeDate = "less than a minute";
        }
        else if ((seconds < 90))
        {
            relativeDate = "about a minute";
        }
        else if ((minutes < 45))
        {
            relativeDate = string.Format("{0} minutes", Math.Round(minutes));
        }
        else if ((minutes < 90))
        {
            relativeDate = "about an hour";
        }
        else if ((hours < 24))
        {
            relativeDate = string.Format("about {0} hours", Math.Round(hours));
        }
        else if ((hours < 48))
        {
            relativeDate = "a day";
        }
        else if ((days < 30))
        {
            relativeDate = string.Format("{0} days", Math.Floor(days));
        }
        else if ((days < 60))
        {
            relativeDate = "about a month";
        }
        else if ((days < 365))
        {
            relativeDate = string.Format("{0} months", Math.Floor(days / 30));
        }
        else if ((years < 2))
        {
            relativeDate = "about a year";
        }
        else
        {
            relativeDate = string.Format("{0} years", Math.Floor(years));
        }
        return relativeDate + " " + suffix;
    }

    public string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    public void SendEmailDB(
            string sToEmails
            , string sCCEmails
            , string sBCCEmails
            , string sSubject
            , string sMessage
        )
    {
        string DBEmailProfile = getValueOfKey("DBEmailProfile");
        try
        {
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);
            string Q = "msdb.dbo.sp_send_dbmail";
            SqlCommand oCommand = new SqlCommand(Q, oConn);
            oCommand.CommandType = CommandType.StoredProcedure;
            oCommand.Parameters.Add("profile_name", SqlDbType.VarChar).Value = DBEmailProfile;
            oCommand.Parameters.Add("recipients", SqlDbType.VarChar).Value = sToEmails;
            oCommand.Parameters.Add("copy_recipients", SqlDbType.VarChar).Value = sCCEmails;
            oCommand.Parameters.Add("blind_copy_recipients", SqlDbType.VarChar).Value = sBCCEmails;
            oCommand.Parameters.Add("subject", SqlDbType.VarChar).Value = sSubject;
            oCommand.Parameters.Add("body", SqlDbType.VarChar).Value = sMessage;

            if (oConn.State == ConnectionState.Closed)
                oConn.Open();

            int i = oCommand.ExecuteNonQuery();
        }
        catch (Exception) { }
    }

    public void SendMail(
        string[] sToEmails,
        string sSubject,
        string sMessage
        )
    {
        SendMail(
        sToEmails,
        new string[] { },
        new string[] { },
        sSubject,
        sMessage,
        new string[] { }
        );

    }

    public void SendMail(
        string[] sToEmails,
        string[] CCs,
        string[] BCCs,
        string sSubject,
        string sMessage,
        string[] AttachmentsFiles
        )
    {
        try
        {
            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();

            foreach (string sToEmail in sToEmails)
                mail.To.Add(sToEmail);

            foreach (string CC in CCs)
                mail.CC.Add(CC);

            foreach (string BC in BCCs)
                mail.Bcc.Add(BC);

            mail.Subject = sSubject;
            mail.Body = sMessage;

            foreach (string AttachmentsFile in AttachmentsFiles)
                mail.Attachments.Add(new System.Net.Mail.Attachment(AttachmentsFile));

            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient();
            object userstate = mail;
            smtp.Send(mail);
        }
        catch (Exception ex) { throw ex; }
    }
    public void SendMail(string sHost,
                                int nPort,
                                string sUserName,
                                string sPassword,
                                string sFromName,
                                string sFromEmail,
                                string[] sToEmails,
                                string[] CCs,
                                string[] BCCs,
                                string sSubject,
                                string sMessage,
                                string[] AttachmentsFiles
                                )
    {
        try
        {
            System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();

            foreach (string sToEmail in sToEmails)
                mail.To.Add(sToEmail);

            foreach (string CC in CCs)
                mail.CC.Add(CC);

            foreach (string BC in BCCs)
                mail.Bcc.Add(BC);

            mail.Subject = sSubject;
            mail.From = new System.Net.Mail.MailAddress(sFromEmail);
            mail.Body = sMessage;

            foreach (string AttachmentsFile in AttachmentsFiles)
                mail.Attachments.Add(new System.Net.Mail.Attachment(AttachmentsFile));

            System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient(sHost);
            smtp.Credentials = new System.Net.NetworkCredential(sUserName, sPassword);
            smtp.Port = nPort;
            smtp.Send(mail);
        }
        catch (Exception ex) { throw ex; }
    }
    public string FileSize(object val)
    {
        float SizeVal = (float.Parse(val.ToString()));
        string size = "Unknown Size";
        if (SizeVal > 0)
        {
            if (SizeVal >= 1073741824)
                size = String.Format("{0:##.###}", (SizeVal / 1073741824)) + " GB";
            else if (SizeVal >= 1048576)
                size = String.Format("{0:##.##}", (SizeVal / 1048576)) + " MB";
            else if (SizeVal >= 1024)
                size = String.Format("{0:##}", (SizeVal / 1024)) + " KB";
            else
                size = String.Format("{0:##}", (SizeVal)) + " Bytes";
        }
        return size;
    }
    //public object GetQueryOut1(string Query)
    //{
    //    object Retval = null;

    //    SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["WebDBConnectionString"].ConnectionString);
    //    SqlCommand oCommand = new SqlCommand(Query, oConn);

    //    try
    //    {
    //        if (oConn.State == ConnectionState.Closed)
    //            oConn.Open();

    //        SqlDataReader oReader = oCommand.ExecuteReader();
    //        if (oReader.HasRows)
    //        {
    //            while (oReader.Read())
    //            {
    //                {
    //                    Retval = oReader[0];
    //                    return Retval;
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception) { }
    //    return Retval;
    //}
    public void ModalShow(string ClientID)
    {
        ScriptManager.RegisterClientScriptBlock(
            this.Page, this.Page.GetType(),
            "modal",
            "$('.modal-backdrop').each(function(){$(this).remove()});$('#" + ClientID + "').modal({ backdrop: 'static', keyboard: false, show: true });"
            , true);
    }
    public void ModalHide(string ClientID)
    {
        ScriptManager.RegisterClientScriptBlock(
            this.Page, this.Page.GetType(),
            "modal",
            "$('#" + ClientID + "').modal('hide');setTimeout(function(){$('.modal-backdrop').each(function(){$(this).remove()});$('body').removeClass('modal-open');},200);"
            , true);
    }

    public void ClientMsg(string MsgTxt, Control focusControl)
    {
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "$('.modal-backdrop').each(function(){$(this).remove()});bootbox.alert('" + MsgTxt + "', function(){setTimeout(function(){" + script1 + "},100)});", true);
    }

    public void ClientMsg(string MsgTxt)
    {
        ClientMsg(MsgTxt, null);
    }

    public void ClientAlert(string MsgTxt)
    {
        ClientAlert(MsgTxt, null);
    }

    public void ClientAlert(string MsgTxt, Control focusControl)
    {
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank', function(r){" + script1 + "});", true);
    }
    public void ClientScript(string ScriptTxt)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", ScriptTxt, true);
    }
    public void ClientScriptStartup(string ScriptTxt)
    {
        ScriptManager.RegisterStartupScript(this.Page, this.Page.GetType(), "clientScript", ScriptTxt, true);
    }
    public void ClientIDFocus(string ClientID)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "document.getElementById('" + ClientID + "').focus();", true);
    }
    private void CheckAndCreateUploadFolder()
    {
        string UploadPath = Server.MapPath("Upload");
        if (!Directory.Exists(UploadPath)) Directory.CreateDirectory(UploadPath);
    }

    public void SendMail(string sHost,
                                    int nPort,
                                    string sUserName,
                                    string sPassword,
                                    string sFromName,
                                    string sFromEmail,
                                    string[] sToEmails,
                                    string sSubject,
                                    string sMessage,
                                    string[] AttachmentsFiles
                                    )
    {

        System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();

        foreach (string sToEmail in sToEmails)
            mail.To.Add(sToEmail);

        mail.Subject = sSubject;
        mail.From = new System.Net.Mail.MailAddress(sFromEmail);
        mail.Body = sMessage;

        foreach (string AttachmentsFile in AttachmentsFiles)
            if (AttachmentsFile.Trim() != "")
                mail.Attachments.Add(new System.Net.Mail.Attachment(AttachmentsFile));

        System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient(sHost);
        smtp.Credentials = new System.Net.NetworkCredential(sUserName, sPassword);
        smtp.Port = nPort;
        smtp.Send(mail);
    }

    


    public string getAge(object DOB)
    {
        return getAge(DOB, DateTime.Now.Date);
    }

    public string getAge(object FromDate, object ToDate)
    {
        try
        {
            //DateTime dateOfBirth = (DateTime)FromDate;
            //DateTime currentDate = (DateTime)ToDate;

            int ageInYears = 0;
            int ageInMonths = 0;
            int ageInDays = 0;
            string dayText = "day";
            string monthText = "month";
            string yearText = "year";

            DateTime Bday = (DateTime)FromDate;
            DateTime Cday = DateTime.Today;

            if ((Cday.Year - Bday.Year) > 0 ||
                (((Cday.Year - Bday.Year) == 0) && ((Bday.Month < Cday.Month) ||
                ((Bday.Month == Cday.Month) && (Bday.Day <= Cday.Day)))))
            {
                int DaysInBdayMonth = DateTime.DaysInMonth(Bday.Year, Bday.Month);
                int DaysRemain = Cday.Day + (DaysInBdayMonth - Bday.Day);

                if (Cday.Month > Bday.Month)
                {
                    ageInYears = Cday.Year - Bday.Year;
                    ageInMonths = Cday.Month - (Bday.Month + 1) + Math.Abs(DaysRemain / DaysInBdayMonth);
                    ageInDays = (DaysRemain % DaysInBdayMonth + DaysInBdayMonth) % DaysInBdayMonth;
                }
                else if (Cday.Month == Bday.Month)
                {
                    if (Cday.Day >= Bday.Day)
                    {
                        ageInYears = Cday.Year - Bday.Year;
                        ageInMonths = 0;
                        ageInDays = Cday.Day - Bday.Day;
                    }
                    else
                    {
                        ageInYears = (Cday.Year - 1) - Bday.Year;
                        ageInMonths = 11;
                        ageInDays = DateTime.DaysInMonth(Bday.Year, Bday.Month) - (Bday.Day - Cday.Day);
                    }
                }
                else
                {
                    ageInYears = (Cday.Year - 1) - Bday.Year;
                    ageInMonths = Cday.Month + (11 - Bday.Month) + Math.Abs(DaysRemain / DaysInBdayMonth);
                    ageInDays = (DaysRemain % DaysInBdayMonth + DaysInBdayMonth) % DaysInBdayMonth;
                }
            }

            if (ageInYears == 0) yearText = "";
            else if (ageInYears == 1) yearText = ", " + ageInYears + " year";
            else yearText = ", " + ageInYears + " years";

            if (ageInMonths == 0) monthText = "";
            else if (ageInMonths == 1) monthText = ", " + ageInMonths + " month";
            else monthText = ", " + ageInMonths + " months";

            if (ageInDays == 0) dayText = "";
            else if (ageInDays == 1) dayText = ", " + ageInDays + " day";
            else dayText = ", " + ageInDays + " days";


            string Retval = string.Format("{0}{1}{2}", yearText, monthText, dayText);
            if (Retval.StartsWith(", ")) Retval = Retval.Substring(2);
            if (Retval.StartsWith(", ")) Retval = Retval.Substring(2);
            if (Retval.StartsWith(", ")) Retval = Retval.Substring(2);

            return Retval;
        }
        catch (Exception)
        { return ""; }
    }

    public string getIPAddress()
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

    public string getBrowserInfo()
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