using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

public partial class CheckoutPayEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //int symbol;
        //symbol = 0;
        //while (true)
        //{
        //    if (symbol == 1)
        //        symbol = 0;
        //    else
        //        symbol = 1;
        //}


        TrustControl1.getUserRoles();


        if (!IsPostBack)
        {
            string RefID = string.Format("{0}", Request.QueryString["refid"]);
            txtFilter.Text = RefID;
        }
    }

 

 
    protected void cmdOK_Click(object sender, EventArgs e)
    {
        Response.Redirect("CheckoutPayEdit.aspx?refid=" + txtFilter.Text.Trim().ToUpper(), true);
        return;

    }

    protected void CheckoutTrnEditByRef_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
               
        TrustControl1.ClientMsg(string.Format("{0}", Msg));
    }






}
