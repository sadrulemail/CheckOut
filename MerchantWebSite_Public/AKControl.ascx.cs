﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Globalization;

public partial class AKControl : System.Web.UI.UserControl
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
            Response.Redirect("Default.aspx?Prev=" + Request.Url.ToString().Replace("&", "%26"), true);
        }
        else
            try
            {
                ((Literal)(this.Page.Master.FindControl("LoginStatus"))).Text = string.Format("<b>{0}</b> (<span data-toggle='tooltip' data-placement='left' title='{3}'>{1}</span>)<br />{4}, {5}<br />Role: {2} <a href='Logout.aspx' class='ButtonSmall'>Logout</a>"
                    , Session["FULLNAME"]
                    , Session["USERNAME"]
                    , Session["ROLES"].ToString().Replace(",",", ")
                    , Session["Email"]
                    , Session["OrganizationName"]
                    , Session["BranchName"]
                    );
                

                //Load Sessions
                SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
                string Q = "execute s_getUser '" + Session["USERNAME"].ToString() + "', NULL";
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
                            Session["ROLES"] = oReader["UserRole"].ToString();
                            Session["EMAIL"] = oReader["Email"].ToString();
                            Session["ORGID"] = oReader["OrgID"].ToString();
                            Session["BID"] = oReader["BID"].ToString();
                            Session["OrganizationName"] = oReader["OrganizationName"].ToString();
                            Session["BranchID"] = oReader["BranchID"].ToString();
                            Session["BranchName"] = oReader["BranchName"].ToString();
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
                    Response.Write("<h1>Sorry! You have no permission to use this page.</h1>");
                    Response.End();
                }
            }
            catch (Exception) { }
    }

    public string getUsername()
    {
        return Session["USERNAME"].ToString();
    }

    public bool isRole(params string[] RoleNames)
    {
        try
        {
            foreach (string RoleName in RoleNames)
            {
                if (isRole(RoleName))
                    return true;
            }
            return false;
        }
        catch (Exception)
        {
            return false;
        }
    }

    public bool isRole(string RoleName)
    {
        try
        {
            string[] Roles = Session["ROLES"].ToString().Split(',');
            foreach (string Role in Roles)
                if (Role.Trim().ToLower() == RoleName.Trim().ToLower())
                    return true;
        }
        catch (Exception)
        {
            Response.Redirect("Default.aspx?Prev=" + Request.Url.ToString().Replace("&", "%26"), true);
        }
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
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
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
    public object GetQueryOut1(string Query)
    {
        object Retval = null;
        
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["MainConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);

        try
        {
            if (oConn.State == ConnectionState.Closed)
                oConn.Open();

            SqlDataReader oReader = oCommand.ExecuteReader();
            if (oReader.HasRows)
            {
                while (oReader.Read())
                {
                    {
                        Retval = oReader[0];
                        return Retval;
                    }
                }
            }
        }
        catch (Exception) { }
        return Retval;
    }
    public void ClientMsg(string MsgTxt)
    {
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "')", true);
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

    public string ToTimeAgo(DateTime input)
    {
        return string.Format(English, "{0:yyyy-MM-dd HH:mm:ss}", input);
    }

    public string ToTimeAgo(object input)
    {
        try
        {
            return ToTimeAgo((DateTime)(input));
        }
        catch (Exception) { return string.Empty; }
    }

    public CultureInfo Bangla
    {
        get
        {
            return new CultureInfo("bn-BD");
        }
    }

    public CultureInfo English
    {
        get
        {
            return new CultureInfo("en-NZ");
        }
    }
}
