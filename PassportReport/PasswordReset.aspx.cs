using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class PasswordReset : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string focusScript = "document.getElementById('" + txtUserName.ClientID + "').focus();";
            AKControl1.ClientScriptStartup("setTimeout(\"" + focusScript + ";\",100);");
        }
    }

    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {

        //string Msg = e.Command.Parameters["@Msg"].Value.ToString();
        //AKControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());      
    }

    protected void cmdReset_Click(object sender, EventArgs e)
    {
        DataView DV = (DataView)(SqlDataSource1.Select(DataSourceSelectArguments.Empty));
        AKControl1.ClientMsg(DV.Table.Rows[0][0].ToString());
    }

    protected void SqlDataSource1_Selecting(object sender, SqlDataSourceSelectingEventArgs e)
    {
        int i = e.Command.Parameters.Count;
    }
}