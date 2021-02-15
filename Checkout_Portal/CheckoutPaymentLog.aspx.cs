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

        if (!IsPostBack)
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            cmdExport.Visible = false;
        }

        this.Title = "Checkout Payment Log";
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Checkout-TBL");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Ref ID";
                worksheet.Cells[StartRow, 2].Value = "Amount";
                worksheet.Cells[StartRow, 3].Value = "Marchent ID";
                worksheet.Cells[StartRow, 4].Value = "Order ID";
                worksheet.Cells[StartRow, 5].Value = "Insert DT";
                worksheet.Cells[StartRow, 6].Value = "Status";

                worksheet.Cells[StartRow, 7].Value = "Verified";
                worksheet.Cells[StartRow, 8].Value = "Used";
                worksheet.Cells[StartRow, 9].Value = "UsedDT";
                worksheet.Cells[StartRow, 10].Value = "Sender Mobile";
                worksheet.Cells[StartRow, 11].Value = "Type";
                worksheet.Cells[StartRow, 12].Value = "PaidDT";

                worksheet.Cells[StartRow, 13].Value = "Verified DT";
                worksheet.Cells[StartRow, 14].Value = "Fees";
                worksheet.Cells[StartRow, 15].Value = "Vat Amount";
                worksheet.Cells[StartRow, 16].Value = "Service Charge";
                worksheet.Cells[StartRow, 17].Value = "EMI Interest";
                worksheet.Cells[StartRow, 18].Value = "FullName";

                worksheet.Cells[StartRow, 19].Value = "Email";
                worksheet.Cells[StartRow, 20].Value = "Meta1";
                worksheet.Cells[StartRow, 21].Value = "Meta2";
                worksheet.Cells[StartRow, 22].Value = "Meta3";
                worksheet.Cells[StartRow, 23].Value = "Meta4";
                worksheet.Cells[StartRow, 24].Value = "Meta5";

                worksheet.Cells[StartRow, 25].Value = "PAN";
                worksheet.Cells[StartRow, 26].Value = "Trns ID";


                worksheet.Column(1).Width = 16;
                worksheet.Column(2).Width = 10;
                worksheet.Column(3).Width = 15;
                worksheet.Column(4).Width = 15;
                worksheet.Column(5).Width = 15;
                worksheet.Column(6).Width = 15;

                worksheet.Column(7).Width = 15;
                worksheet.Column(8).Width = 15;
                worksheet.Column(9).Width = 15;
                worksheet.Column(10).Width = 15;
                worksheet.Column(11).Width = 15;
                worksheet.Column(12).Width = 15;

                worksheet.Column(13).Width = 15;
                worksheet.Column(14).Width = 15;
                worksheet.Column(15).Width = 15;
                worksheet.Column(16).Width = 15;
                worksheet.Column(17).Width = 15;
                worksheet.Column(18).Width = 22;
             
                worksheet.Column(19).Width = 28;
                worksheet.Column(20).Width = 15;
                worksheet.Column(21).Width = 15;
                worksheet.Column(22).Width = 15;
                worksheet.Column(23).Width = 15;
                worksheet.Column(24).Width = 15;

                worksheet.Column(25).Width = 20;
                worksheet.Column(26).Width = 25;

                DataView DV = (DataView)SqlDataSource_Payment_Checkout.Select(DataSourceSelectArguments.Empty);

                int R;

                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    R = StartRow + r + 1;
                    if (DV.Table.Rows[r]["RefID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["RefID"].ToString();
                    }
                    if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Amount"];
                        worksheet.Cells[R, 2].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }
                    if (DV.Table.Rows[r]["MarchentID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["MarchentID"].ToString();
                    }
                    if (DV.Table.Rows[r]["OrderID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["OrderID"].ToString();
                    }
                    if (DV.Table.Rows[r]["InsertDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["InsertDT"];
                        worksheet.Cells[R, 5].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                    if (DV.Table.Rows[r]["Status"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["Status"].ToString();
                    }

                    if (DV.Table.Rows[r]["Verified"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Verified"].ToString();
                    }
                    if (DV.Table.Rows[r]["Used"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["Used"].ToString();
                    }
                    if (DV.Table.Rows[r]["UsedDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["UsedDT"];
                        worksheet.Cells[R, 9].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                    if (DV.Table.Rows[r]["SenderMobile"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["SenderMobile"].ToString();
                    }
                    if (DV.Table.Rows[r]["Type"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["Type"].ToString();
                    }
                    if (DV.Table.Rows[r]["PaidDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["PaidDT"];
                        worksheet.Cells[R, 12].Style.Numberformat.Format = "dd/MM/yyyy";
                    }


                    if (DV.Table.Rows[r]["VerifiedDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 13].Value = DV.Table.Rows[r]["VerifiedDT"];
                        worksheet.Cells[R, 13].Style.Numberformat.Format = "dd/MM/yyyy";
                    }
                    if (DV.Table.Rows[r]["Fees"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 14].Value = DV.Table.Rows[r]["Fees"];
                        worksheet.Cells[R, 14].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }
                    if (DV.Table.Rows[r]["VatAmount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 15].Value = DV.Table.Rows[r]["VatAmount"];
                        worksheet.Cells[R, 15].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }
                    if (DV.Table.Rows[r]["ServiceCharge"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 16].Value = DV.Table.Rows[r]["ServiceCharge"];
                        worksheet.Cells[R, 16].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }

                    if (DV.Table.Rows[r]["InterestAmount"] != DBNull.Value) //
                    {
                        worksheet.Cells[R, 17].Value = DV.Table.Rows[r]["InterestAmount"];
                        worksheet.Cells[R, 17].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }

                    if (DV.Table.Rows[r]["FullName"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 18].Value = DV.Table.Rows[r]["FullName"].ToString();
                    }
                    if (DV.Table.Rows[r]["Email"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 19].Value = DV.Table.Rows[r]["Email"].ToString();
                    }

                    if (DV.Table.Rows[r]["Meta1"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 20].Value = DV.Table.Rows[r]["Meta1"];
                      
                     
                    }

                    if (DV.Table.Rows[r]["Meta2"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 21].Value = DV.Table.Rows[r]["Meta2"];
                       
                    }

                    if (DV.Table.Rows[r]["Meta3"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 22].Value = DV.Table.Rows[r]["Meta3"];
                     
                    }

                    if (DV.Table.Rows[r]["Meta4"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 23].Value = DV.Table.Rows[r]["Meta4"];
                       
                    }
                   

                    if (DV.Table.Rows[r]["Meta5"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 24].Value = DV.Table.Rows[r]["Meta5"];
                       
                    }


                    if (DV.Table.Rows[r]["PAN"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 25].Value = DV.Table.Rows[r]["PAN"];

                    }

                    if (DV.Table.Rows[r]["TransactionID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 26].Value = DV.Table.Rows[r]["TransactionID"].ToString();

                    }

                }


                worksheet.Cells["A1:J1"].Style.WrapText = true;
                worksheet.Cells["A1:J1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:J1"].Style.Font.Bold = true;

                //worksheet.Cells["A1:B1"].Merge = true;

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
                string.Format("attachment;filename=" + "Checkout_TBL_{0}_{1}.xlsx",
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
        GridView1.DataBind();
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
        //litTotalAmount.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        //litTotalPaid.Text = string.Format(AKControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);

        //litTotal_Amount_WithOutVat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalFees"].Value);
        //litTotal_Vat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Vat"].Value);
    }
    protected void SqlDataSource_Payment_Checkout_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblStatus.Text = string.Format("Total <b>{0:N0}</b>", e.AffectedRows);
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.ForeColor = System.Drawing.ColorTranslator.FromHtml(string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "color")));
    }
}
