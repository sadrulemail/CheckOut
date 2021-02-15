using System;
using System.Web.UI.WebControls;

public partial class Users : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void cmdShowAll_Click(object sender, EventArgs e)
    {
        MultiView1.ActiveViewIndex = 0;
        GridView1.DataBind();
    }

    protected void cmdAddNew_Click(object sender, EventArgs e)
    {
        HiddenField1.Value = "";
        DetailsView1.ChangeMode(DetailsViewMode.Insert);
        MultiView1.ActiveViewIndex = 1;
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "OPEN")
        {
            HiddenField1.Value = e.CommandArgument.ToString();
            DetailsView1.DataBind();
            DetailsView1.ChangeMode(DetailsViewMode.ReadOnly);
            MultiView1.ActiveViewIndex = 1;
        }
    }

    protected void SqlDataSource2_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        if (e.Exception != null)
        {
            string s = e.Exception.Message;
        }
        HiddenField1.Value = e.Command.Parameters["@Username"].Value.ToString();
        DetailsView1.DataBind();
        GridView1.DataBind();
        try
        {
            //AKControl1.SendEmailDB("mail@ashik.info", "", "", "LMA User Created", "Username: " + HiddenField1.Value + ", by: " + Session["USERNAME"].ToString());
            AKControl1.SendEmailDB(e.Command.Parameters["@Email"].Value.ToString(),
                "", "", "[" + AKControl1.getValueOfKey("AppTitle") + "] User Created", "Username: " + e.Command.Parameters["@UserName"].Value.ToString() + "\nPassword: " + e.Command.Parameters["@UserName"].Value.ToString() + "\n\nLogin URL: " + AKControl1.getValueOfKey("AppUrl"));
        }
        catch (Exception) { }
        AKControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
    }

    protected void SqlDataSource2_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = e.Command.Parameters["@Msg"].Value.ToString();
        if (Msg != "User Information Saved.")
            e.Command.Cancel();
        try
        {
            //AKControl1.SendEmailDB("mail@ashik.info", "", "", "LMA User Updated", "Username: " + HiddenField1.Value + ", by: " + Session["USERNAME"].ToString());
            AKControl1.SendEmailDB(e.Command.Parameters["@Email"].Value.ToString(),
                "", "", "[" + AKControl1.getValueOfKey("AppTitle") + "] User Information Updated", "Username: " + e.Command.Parameters["@UserName"].Value.ToString() + "\n\nLogin URL: " + AKControl1.getValueOfKey("AppUrl"));
        }
        catch (Exception) { }
        AKControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = "Total Users: <b>" + e.AffectedRows.ToString() + "</b>";
    }

    protected void SqlDataSource2_Inserting(object sender, SqlDataSourceCommandEventArgs e)
    {
        AddUserRoleParameter(e);
    }

    protected void SqlDataSource2_Updating(object sender, SqlDataSourceCommandEventArgs e)
    {
        AddUserRoleParameter(e);
    }

    private void AddUserRoleParameter(SqlDataSourceCommandEventArgs e)
    {
        string Roles = "";
        CheckBoxList CBL = ((CheckBoxList)(DetailsView1.FindControl("chkRoles")));
        foreach (ListItem L in CBL.Items)
            if (L.Selected)
                Roles += L.Value + ",";
        if (Roles.EndsWith(","))
            Roles = Roles.Substring(0, Roles.Length - 1);
        e.Command.Parameters["@UserRole"].Value = Roles;
    }

    protected void DetailsView1_DataBound(object sender, EventArgs e)
    {
        try
        {
            string[] Roles = ((HiddenField)(DetailsView1.FindControl("HidUserRoles"))).Value.Split(",".ToCharArray());
            CheckBoxList CBL = ((CheckBoxList)(DetailsView1.FindControl("chkRoles")));
            foreach (ListItem L in CBL.Items)
                foreach (string Role in Roles)
                    if (Role.ToLower().Trim() == L.Value.ToLower().Trim())
                        L.Selected = true;
        }
        catch (Exception) { }
    }
}
