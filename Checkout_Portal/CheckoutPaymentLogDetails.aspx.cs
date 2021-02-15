using System;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

public partial class CheckoutPaymentLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AKControl1.getUserRoles();

     

        this.Title = "Checkout Payment Log Details";
    }
  
   
   
    protected void GridView1_PageIndexChanged(object sender, EventArgs e)
    {

    }
    protected void GridView1_PageIndexChanging(object sender, System.Web.UI.WebControls.GridViewPageEventArgs e)
    {
        //GridView1.PageIndex = e.NewPageIndex;
        //RefreshData();
    }
    protected void cmdOK_Click(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void GridView1_PageIndexChanged1(object sender, EventArgs e)
    {

    }
    protected void txtDateFrom_TextChanged(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void txtDateTo_TextChanged(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void GridView1_Sorting(object sender, System.Web.UI.WebControls.GridViewSortEventArgs e)
    {
        //RefreshData();
        //DataTable dtSortTable = GridView1.DataSource as DataTable;
        //if (dtSortTable != null)
        //{
        //    DataView dvSortedView = new DataView(dtSortTable);
        //    dvSortedView.Sort = e.SortExpression + " " + getSortDirectionString(e.SortDirection);
        //    GridView1.DataSource = dvSortedView;
        //    GridView1.DataBind();
        //}
        //DataTable dtSortTable = GridView1.DataSource as DataTable;

        //if (dtSortTable != null)
        //{
        //    DataView dvSortedView = new DataView(dtSortTable);
        //    dvSortedView.Sort = e.SortExpression + " " + getSortDirectionString(e.SortDirection);

        //    GridView1.DataSource = dvSortedView;
        //    GridView1.DataBind();
        //}

        //DataSourceSelectArguments args = new DataSourceSelectArguments(e.SortExpression);
        //GridView1.DataSource = SqlDataSource_s_Passport_Used_Report.Select(args);
        //GridView1.DataBind();
    }
    private string getSortDirectionString(SortDirection sortDireciton)
    {
        //string newSortDirection = String.Empty;
        //if (sortDireciton == SortDirection.Ascending)
        //{
        //    newSortDirection = "ASC";
        //}
        //else
        //{
        //    newSortDirection = "DESC";
        //}
        //return newSortDirection;
        string newSortDirection = String.Empty;
        if (sortDireciton == SortDirection.Ascending)
        {
            newSortDirection = "ASC";
        }
        else
        {
            newSortDirection = "DESC";
        }

        return newSortDirection;
    }
  
    protected void SqlDataSource_s_Passport_Report_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        //litTotalAmount.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        //litTotalPaid.Text = string.Format(AKControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);

        //litTotal_Amount_WithOutVat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalFees"].Value);
        //litTotal_Vat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Vat"].Value);
    }
}
