using System;
using System.Web;
using System.Web.UI;
using OfficeOpenXml;
using System.IO;
using System.Data;
using System.Web.UI.WebControls;

public partial class Passport : System.Web.UI.Page
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

        this.Title = "Passport Payment Report";

        //GridView1.Visible = IsPostBack;
        //cmdExport.Visible = IsPostBack;
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("DIP-TBL");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Ref ID";
                worksheet.Cells[StartRow, 2].Value = "Full Name";
                worksheet.Cells[StartRow, 3].Value = "Total Amount";
                worksheet.Cells[StartRow, 4].Value = "Amount without Vat";
                worksheet.Cells[StartRow, 5].Value = "Vat Amount";
                worksheet.Cells[StartRow, 6].Value = "Payment Date";
                worksheet.Cells[StartRow, 7].Value = "Verify Date";
                worksheet.Cells[StartRow, 8].Value = "EID";
                worksheet.Cells[StartRow, 9].Value = "Type";
                worksheet.Cells[StartRow, 10].Value = "Status";
                worksheet.Cells[StartRow, 11].Value = "Account/PAN";
                worksheet.Cells[StartRow, 12].Value = "Transaction ID";
                worksheet.Cells[StartRow, 13].Value = "Update By";
                worksheet.Cells[StartRow, 14].Value = "Update On";
                worksheet.Cells[StartRow, 15].Value = "Update Reason";

                worksheet.Column(1).Width = 17;
                worksheet.Column(2).Width = 40;
                worksheet.Column(3).Width = 15;
                worksheet.Column(4).Width = 15;
                worksheet.Column(5).Width = 15;
                worksheet.Column(6).Width = 15;
                worksheet.Column(7).Width = 15;
                worksheet.Column(8).Width = 20;
                worksheet.Column(9).Width = 25;
                worksheet.Column(10).Width = 10;
                worksheet.Column(11).Width = 15;
                worksheet.Column(12).Width = 20;
                worksheet.Column(13).Width = 10;
                worksheet.Column(14).Width = 15;
                worksheet.Column(15).Width = 25;


                DataView DV = (DataView)SqlDataSource_s_Passport_Report.Select(DataSourceSelectArguments.Empty);

                int R;

                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;
                    if (DV.Table.Rows[r]["RefID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["RefID"].ToString();
                    }

                    if (DV.Table.Rows[r]["FullName"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["FullName"];
                    }

                    if (DV.Table.Rows[r]["TotalAmount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["TotalAmount"];
                        worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["Amount_WithOutVat"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["Amount_WithOutVat"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["Vat"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["Vat"];
                        worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["InsertDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["InsertDT"];
                        worksheet.Cells[R, 6].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["UsedDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["UsedDT"];
                        worksheet.Cells[R, 7].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["EID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["EID"];
                        // worksheet.Cells[R, 6].Style.Numberformat.Format = "{0:N2}";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }

                    if (DV.Table.Rows[r]["Type"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["Type"];
                    }

                    if (DV.Table.Rows[r]["Status"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["Status"];
                    }
                    if (DV.Table.Rows[r]["SenderMobile"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["SenderMobile"].ToString();
                    }
                    if (DV.Table.Rows[r]["TransactionID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["TransactionID"].ToString();
                    }
                    if (DV.Table.Rows[r]["UpdateBy"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 13].Value = DV.Table.Rows[r]["UpdateBy"].ToString();
                    }

                    if (DV.Table.Rows[r]["UpdateDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 14].Value = DV.Table.Rows[r]["UpdateDT"];
                        worksheet.Cells[R, 14].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["UpdateReason"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 15].Value = DV.Table.Rows[r]["UpdateReason"].ToString();
                    }
                }

                //worksheet.Cells["G1:AA1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["A1:AA1"].Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Top;
                // worksheet.Cells["B1:B"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["D1:D"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["G1:G"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                //worksheet.Cells["H1:H"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                worksheet.Cells["A1:K1"].Style.WrapText = true;
                worksheet.Cells["A1:K1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:K1"].Style.Font.Bold = true;

                //worksheet.Cells[R + 1, 4].Formula = "=SUM(D2:D" + R + ")";
                //worksheet.Cells[R + 1, 5].Formula = "=SUM(E2:E" + R + ")";
                //worksheet.Cells[R + 1, 7].Formula = "=SUM(G2:G" + R + ")";
                //worksheet.Cells[R + 1, 8].Formula = "=SUM(H2:H" + R + ")";
                //worksheet.Cells[R + 1, 9].Formula = "=SUM(I2:I" + R + ")";
                //worksheet.Cells[R + 1, 10].Formula = "=SUM(J2:J" + R + ")";
                //worksheet.Cells[R + 1, 11].Formula = "=SUM(K2:K" + R + ")";
                //worksheet.Cells[R + 1, 12].Formula = "=SUM(L2:L" + R + ")";
                //worksheet.Cells[R + 1, 13].Formula = "=SUM(M2:M" + R + ")";
                //worksheet.Cells[R + 1, 14].Formula = "=SUM(N2:N" + R + ")";
                //worksheet.Cells[R + 1, 15].Formula = "=SUM(O2:O" + R + ")";
                //worksheet.Cells[R + 1, 16].Formula = "=SUM(P2:P" + R + ")";
                //worksheet.Cells[R + 1, 17].Formula = "=SUM(Q2:Q" + R + ")";






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
                string.Format("attachment;filename=" + "DIP_TBL_{0}_{1}.xlsx",
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
    }
    protected void SqlDataSource_s_Passport_Report_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        litTotalAmount.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        litTotalPaid.Text = string.Format(AKControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);

        litTotal_Amount_WithOutVat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Amount_WithOutVat"].Value);
        litTotal_Vat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Vat"].Value);
    }
}