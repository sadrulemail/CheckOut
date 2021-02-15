using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class REB_ShowBatch : System.Web.UI.Page
{
    //string keycode = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!IsPostBack)
        {
            lilTitle.Text = string.Format("REB Upload Batch: {0}", Request.QueryString["batch"]);
            this.Title = string.Format("REB Batch: {0}", Request.QueryString["batch"]);
            //txtBatch.Text = string.Format("{0}", Request.QueryString["batch"]);
            //keycode = Request.QueryString["keycode"];
        }
    }
    protected void cmdShow_Click(object sender, EventArgs e)
    {
        //Response.Redirect(string.Format("ShowBatch.aspx?batch={0}&keycode={1}", Request.QueryString["batch"], Request.QueryString["keycode"]));
    }
}