using System;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Master : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string PageTitle = System.Configuration.ConfigurationSettings.AppSettings["AppTitle"].ToString();
        this.Page.Title = PageTitle;

        string InnerTitle = string.Empty;
        try
        {
            InnerTitle = " :: " + ((LiteralControl)cphTitle.Controls[0]).Text;
        }
        catch (Exception) { }
        this.Page.Title = string.Format("{0}{1}", PageTitle, InnerTitle);

        Copyright.Text = System.Configuration.ConfigurationSettings.AppSettings["Copyright"].ToString();
    }

    protected void TreeView1_TreeNodeDataBound(object sender, TreeNodeEventArgs e)
    {
        string[] Roles = Session["ROLES"].ToString().Split(',');

        //System.Web.UI.WebControls.TreeView tree = (System.Web.UI.WebControls.TreeView)sender;
        SiteMapNode mapNode = (SiteMapNode)e.Node.DataItem;

        if (mapNode.Roles.Count > 0)
        {
            if (mapNode.Title == "Site Admin")
            { }
            for (int i = 0; i < mapNode.Roles.Count; i++)
                foreach (string Role in Roles)
                    if (mapNode.Roles[i].ToString() == Role
                        || mapNode.Roles[i].ToString() == "*")
                        return;
            RemoveTreeNode(e);
        }
        else
            RemoveTreeNode(e);
    }

    private void RemoveTreeNode(TreeNodeEventArgs e)
    {
        System.Web.UI.WebControls.TreeNode parent = e.Node.Parent;
        if (parent != null)
            parent.ChildNodes.Remove(e.Node);
        else         
            TreeView2.Nodes.Remove(e.Node);
    }

    protected void Page_PreInit(object sender, EventArgs e)
    {
        // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
        // All webpages displaying an ASP.NET menu control must inherit this class.
        if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
            Page.ClientTarget = "uplevel";
    }

    //protected override void AddedControl(Control control, int index)
    //{
    //    // This is necessary because Safari and Chrome browsers don't display the Menu control correctly.
    //    // Add this to the code in your master page.
    //    if (Request.ServerVariables["http_user_agent"].IndexOf("Safari", StringComparison.CurrentCultureIgnoreCase) != -1)
    //        this.Page.ClientTarget = "uplevel";
    //    base.AddedControl(control, index);
    //}
}