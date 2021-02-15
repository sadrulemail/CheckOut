using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using OfficeOpenXml;
using System.IO;

public partial class PassportVerified : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            cmdExport.Visible = false;
        }

        Title = "Passport Verified Report";
    }

    private void RefreshData()
    {
        DataSet DS = ((DataView)SqlDataSource_s_Passport_Used_Report.Select(DataSourceSelectArguments.Empty)).Table.DataSet;
        GridView2.DataSource = DS.Tables[1];
        GridView2.DataBind();
        GridView1.DataSource = DS.Tables[0];
        GridView1.DataBind();
        cmdExport.Visible = (DS.Tables[0].Rows.Count > 0);

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
                worksheet.Cells[StartRow, 3].Value = "Email";
                worksheet.Cells[StartRow, 4].Value = "Amount";
                worksheet.Cells[StartRow, 5].Value = "Paid On";
                worksheet.Cells[StartRow, 6].Value = "Type";

                worksheet.Column(1).Width = 17;
                worksheet.Column(2).Width = 40;
                worksheet.Column(3).Width = 35;
                worksheet.Column(4).Width = 10;
                worksheet.Column(5).Width = 12;
                worksheet.Column(6).Width = 20;


                DataView DV = (DataView)SqlDataSource_s_Passport_Used_Report.Select(DataSourceSelectArguments.Empty);

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
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["TotalAmount"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["Email"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Email"];
                        // worksheet.Cells[R, 6].Style.Numberformat.Format = "{0:N2}";
                        worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";

                    }

                    if (DV.Table.Rows[r]["UsedDT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["UsedDT"];
                        worksheet.Cells[R, 5].Style.Numberformat.Format = "dd/MM/yyyy";

                    }

                    if (DV.Table.Rows[r]["Type"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["Type"];

                    }
                }

                worksheet.Cells["A1:F1"].Style.WrapText = true;
                worksheet.Cells["A1:F1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:F1"].Style.Font.Bold = true;


                //Adding Properties
                xlPackage.Workbook.Properties.Title = "Passport Payments Trust Bank";
                xlPackage.Workbook.Properties.Author = "Trust Bank Checkout";
                xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0}", Session["EMPNAME"]);


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
    }
    protected void cmdOK_Click(object sender, EventArgs e)
    {
    }
    protected void GridView1_PageIndexChanged1(object sender, EventArgs e)
    {

    }
    protected void txtDateFrom_TextChanged(object sender, EventArgs e)
    {
    }
    protected void txtDateTo_TextChanged(object sender, EventArgs e)
    {
    }
    protected void GridView1_Sorting(object sender, System.Web.UI.WebControls.GridViewSortEventArgs e)
    {

    }
    private string getSortDirectionString(SortDirection sortDireciton)
    {
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