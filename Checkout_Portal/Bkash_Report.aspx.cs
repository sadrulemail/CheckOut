using System;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

public partial class Bkash_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AKControl1.getUserRoles();

        if (!IsPostBack)
        {
            txtDateTran.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
          
            cmdExport.Visible = false;
        }

        this.Title = "bKash Notification  Report";
    }
    private void RefreshData()
    {
        //DataSet DS = ((DataView)SqlDataSource_s_Passport_Used_Report.Select(DataSourceSelectArguments.Empty)).Table.DataSet;
        //GridView2.DataSource = DS.Tables[1];
        //GridView2.DataBind();
        //GridView1.DataSource = DS.Tables[0];
        //GridView1.DataBind();
        //cmdExport.Visible = (DS.Tables[0].Rows.Count > 0);

    }
    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateTran.Text);
            txtDateTran.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
    
        }
        catch (Exception) { }
    }

    protected void cmdNextDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateTran.Text);
            txtDateTran.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
           
        }
        catch (Exception) { }
    }
    protected void cmdExport_Click(object sender, EventArgs e)
    {
        try
        {
            string FileName = Path.GetTempFileName();
            if (File.Exists(FileName)) File.Delete(FileName);
            FileInfo FI = new FileInfo(FileName);
            using (ExcelPackage xlPackage = new ExcelPackage(FI))
            {
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("bKash-TBL");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Trace No";
                worksheet.Cells[StartRow, 2].Value = "Transaction Date";
                worksheet.Cells[StartRow, 3].Value = "Transaction Particulars";
                worksheet.Cells[StartRow, 4].Value = "AmountTk";
                worksheet.Cells[StartRow, 5].Value = "Remarks";

                worksheet.Cells[StartRow, 6].Value = "TBL Status";
                worksheet.Cells[StartRow, 7].Value = "TBL Status Name";
                worksheet.Cells[StartRow, 8].Value = "bKash Response";
                worksheet.Cells[StartRow, 9].Value = "bKash Response Name";
                //worksheet.Cells[StartRow, 7].Value = "Type";
                //worksheet.Cells[StartRow, 8].Value = "Status";

                worksheet.Column(1).Width = 12;
                worksheet.Column(2).Width = 12;
                worksheet.Column(3).Width = 25;
                worksheet.Column(4).Width = 15;
                worksheet.Column(5).Width = 25;

                worksheet.Column(6).Width = 10;
                worksheet.Column(7).Width = 20;
                worksheet.Column(8).Width = 10;
                worksheet.Column(9).Width = 20;



                DataView DV = (DataView)SqlDataSource_s_Bkash_Report.Select(DataSourceSelectArguments.Empty);

                int R;

                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;
                    if (DV.Table.Rows[r]["TraceNo"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["TraceNo"].ToString();
                    }
                    if (DV.Table.Rows[r]["TransactionDate"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["TransactionDate"];
                        worksheet.Cells[R, 2].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                    if (DV.Table.Rows[r]["TransactionParticulars"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["TransactionParticulars"];
                    }
               
                    if (DV.Table.Rows[r]["AmountTk"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["AmountTk"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                    if (DV.Table.Rows[r]["Remarks"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Remarks"];
                    }
                    if (DV.Table.Rows[r]["TBL_Status"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["TBL_Status"];
                    }
                    if (DV.Table.Rows[r]["TBL_StatusName"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["TBL_StatusName"];
                    }
                    if (DV.Table.Rows[r]["bKash_Response"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["bKash_Response"];
                    }
                    if (DV.Table.Rows[r]["bKash_ResponseName"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["bKash_ResponseName"];
                    }





                }

                //worksheet.Cells["G1:AA1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["A1:AA1"].Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Top;
                // worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["G1:G"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["H1:H"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                worksheet.Cells["A1:J1"].Style.WrapText = true;
                worksheet.Cells["A1:J1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:J1"].Style.Font.Bold = true;

     
                //Adding Properties
                xlPackage.Workbook.Properties.Title = "Trust Bank Transaction Notification";
                xlPackage.Workbook.Properties.Author = "Trust Bank IT Div";
                xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                //xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);


                xlPackage.Save();
            }


            //Reading File Content
            byte[] content = File.ReadAllBytes(FileName);
            File.Delete(FileName);

            //Downloading File
            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/xlsx";
            Response.AddHeader("Content-Disposition",
                string.Format("attachment;filename=" + "bKash_TBL_{0}_{1}.xlsx","",
                txtDateTran.Text.Replace("/", "")));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.BinaryWrite(content);
            Response.End();
        }
        catch (Exception ex)
        {
            // lblStatus.Text = ex.Message; 
        }
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
    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        cmdExport.Visible = (GridView1.Rows.Count > 0);
    }
  
}
