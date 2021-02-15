using System;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

public partial class CheckoutPaymentSummary : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AKControl1.getUserRoles();

        if (!IsPostBack)
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            cmdExport.Visible = false;
        }

        this.Title = "Checkout Payment Summary";
    }
  
    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            //RefreshData();
        }
        catch (Exception) { }
    }

    protected void cmdNextDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            //RefreshData();
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("NID-TBL");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Ref ID";
                worksheet.Cells[StartRow, 2].Value = "NID Number";
                worksheet.Cells[StartRow, 3].Value = "Amount";
                worksheet.Cells[StartRow, 4].Value = "Vat";
                worksheet.Cells[StartRow, 5].Value = "Total";
                worksheet.Cells[StartRow, 6].Value = "Payment Date";
           

                worksheet.Column(1).Width = 25;
                worksheet.Column(2).Width = 22;
                worksheet.Column(3).Width = 15;
                worksheet.Column(4).Width = 15;
                worksheet.Column(5).Width = 15;
                worksheet.Column(6).Width = 15;

                DataView DV = (DataView)SqlDataSource_Checkout_Summary.Select(DataSourceSelectArguments.Empty);

                int R;

                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;
                    if (DV.Table.Rows[r]["RefID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["RefID"].ToString();
                    }


                    if (DV.Table.Rows[r]["Meta1"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Meta1"];
                        worksheet.Cells[R, 2].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["TotalFees"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["TotalFees"];
                        worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["TotalVatAmount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["TotalVatAmount"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["TotalAmount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["TotalAmount"];
                        worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                   

                    if (DV.Table.Rows[r]["InsertDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["InsertDT"];
                        worksheet.Cells[R, 6].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                

                }


                worksheet.Cells["A1:J1"].Style.WrapText = true;
                worksheet.Cells["A1:J1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:J1"].Style.Font.Bold = true;

                //Adding Properties
                xlPackage.Workbook.Properties.Title = "Passport Payments Trust Bank";
                xlPackage.Workbook.Properties.Author = "Trust Bank Checkout";
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
                string.Format("attachment;filename=" + "NID_TBL_{0}_{1}.xlsx",
                txtDateFrom.Text.Replace("/", ""),
                txtDateTo.Text.Replace("/", "")));
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

        double Col_01 = 0;
        double Col_02 = 0;
        double Col_03 = 0;
        double Col_04 = 0;
        double Col_05 = 0;
        double Col_06 = 0;
        double Col_07 = 0;
        double Col_08 = 0;
        double Col_09 = 0;
        double Col_10 = 0;
        double Col_11 = 0;
        double Col_12 = 0;
        double Col_13 = 0;
        double Col_14 = 0;

        for (int r = 0; r < GridView1.Rows.Count; r++)
        {
            Col_01 += double.Parse(GridView1.Rows[r].Cells[2].Text);
            Col_02 += double.Parse(GridView1.Rows[r].Cells[3].Text);
            Col_03 += double.Parse(GridView1.Rows[r].Cells[4].Text);
            Col_04 += double.Parse(GridView1.Rows[r].Cells[5].Text);
            Col_05 += double.Parse(GridView1.Rows[r].Cells[6].Text);
            Col_06 += double.Parse(GridView1.Rows[r].Cells[7].Text);
            Col_07 += double.Parse(GridView1.Rows[r].Cells[8].Text);
            Col_08 += double.Parse(GridView1.Rows[r].Cells[9].Text);
            Col_09 += double.Parse(GridView1.Rows[r].Cells[10].Text);
            Col_10 += double.Parse(GridView1.Rows[r].Cells[11].Text);
            Col_11 += double.Parse(GridView1.Rows[r].Cells[12].Text);
            Col_12 += double.Parse(GridView1.Rows[r].Cells[13].Text);
            Col_13 += double.Parse(GridView1.Rows[r].Cells[14].Text);
            Col_14 += double.Parse(GridView1.Rows[r].Cells[15].Text);
        }
        try
        {
            GridView1.FooterRow.Cells[2].Text = string.Format("{0:N0}", Col_01);
            GridView1.FooterRow.Cells[2].CssClass = "center";

            GridView1.FooterRow.Cells[3].Text = string.Format("{0:N2}", Col_02);

            GridView1.FooterRow.Cells[4].Text = string.Format("{0:N0}", Col_03);
            GridView1.FooterRow.Cells[4].CssClass = "center";

            GridView1.FooterRow.Cells[5].Text = string.Format("{0:N2}", Col_04);

            GridView1.FooterRow.Cells[6].Text = string.Format("{0:N0}", Col_05);
            GridView1.FooterRow.Cells[6].CssClass = "center";

            GridView1.FooterRow.Cells[7].Text = string.Format("{0:N2}", Col_06);

            GridView1.FooterRow.Cells[8].Text = string.Format("{0:N0}", Col_07);
            GridView1.FooterRow.Cells[8].CssClass = "center";

            GridView1.FooterRow.Cells[9].Text = string.Format("{0:N2}", Col_08);            

            GridView1.FooterRow.Cells[10].Text = string.Format("{0:N0}", Col_09);
            GridView1.FooterRow.Cells[10].CssClass = "center";

            GridView1.FooterRow.Cells[11].Text = string.Format("{0:N2}", Col_10);            

            GridView1.FooterRow.Cells[12].Text = string.Format("{0:N0}", Col_11);
            GridView1.FooterRow.Cells[12].CssClass = "center";

            GridView1.FooterRow.Cells[13].Text = string.Format("{0:N2}", Col_12);            

            GridView1.FooterRow.Cells[14].Text = string.Format("{0:N0}", Col_13);
            GridView1.FooterRow.Cells[14].CssClass = "center";

            GridView1.FooterRow.Cells[15].Text = string.Format("{0:N2}", Col_14);
        }
        catch (Exception) { }
    }
    protected void SqlDataSource_s_Passport_Report_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        //litTotalAmount.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        //litTotalPaid.Text = string.Format(AKControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);

        //litTotal_Amount_WithOutVat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalFees"].Value);
        //litTotal_Vat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Vat"].Value);
    }
  
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
      //  e.Row.ForeColor = System.Drawing.ColorTranslator.FromHtml(string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "color")));
    }
    protected void SqlDataSource_Checkout_Summary_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total <b>{0:N0}</b>", e.AffectedRows);
    }
}
