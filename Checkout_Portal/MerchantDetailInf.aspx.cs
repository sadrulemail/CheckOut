using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MerchantDetailInf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
    }



  
    protected void SqlItemsInsert_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
        bool Done = (bool)e.Command.Parameters["@Done"].Value;
        //int BrandID = (int)e.Command.Parameters["@ID"].Value;
        //string Name = (string)e.Command.Parameters["@Name"].Value;
        GdvItemList.DataBind();
        TrustControl1.ClientMsg(string.Format("{0}", Msg));
    }
    protected void SqlMerchantListGrid_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblTotal.Text = string.Format("Total: <b>{0}</b>", e.AffectedRows);
    }
    protected void GdvItemList_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        ItemsDetailsView.ChangeMode(DetailsViewMode.ReadOnly);
    }
}
