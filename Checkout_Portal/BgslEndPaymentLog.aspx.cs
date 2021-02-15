using System;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

public partial class BgslEndPaymentLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        

        this.Title = "BGSL End Payment status Log #" + Request.QueryString["refid"];
    }
  

   
    protected void SqlDataSource_Payment_Checkout_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total <b>{0:N0}</b>", e.AffectedRows);
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       // e.Row.ForeColor = System.Drawing.ColorTranslator.FromHtml(string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "color")));
    }
}
