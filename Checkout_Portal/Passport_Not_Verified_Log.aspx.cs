using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using OfficeOpenXml;
using System.Data;

public partial class Passport_Not_Verified_Log : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        AKControl1.getUserRoles();

        if (!IsPostBack)
        {
            txtReqDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtReqDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            cmdExport.Visible = false;
        }
    }

    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtReqDateFrom.Text);
            txtReqDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtReqDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            //RefreshData();
        }
        catch (Exception) { }
    }

    protected void cmdNextDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtReqDateFrom.Text);
            txtReqDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            txtReqDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(1));
            //RefreshData();
        }
        catch (Exception) { }
    }

    protected void txtDateFrom_TextChanged(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void txtDateTo_TextChanged(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void cmdOK_Click(object sender, EventArgs e)
    {
        //RefreshData();
    }
    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        //cmdExport.Visible = (GridView1.Rows.Count > 0);
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
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("DIP_Not_Verified");
                int StartRow = 1;

                //Adding Title Row
                worksheet.Cells[StartRow, 1].Value = "Ref ID";
                worksheet.Cells[StartRow, 2].Value = "Full Name";
                worksheet.Cells[StartRow, 3].Value = "Amount";
                worksheet.Cells[StartRow, 4].Value = "Request Date";
                worksheet.Cells[StartRow, 5].Value = "EID";
                worksheet.Cells[StartRow, 6].Value = "Enrolment Date";
                worksheet.Cells[StartRow, 7].Value = "Response";
                worksheet.Cells[StartRow, 8].Value = "Reasons";


                DataView DV = (DataView)SqlDataSourceData.Select(DataSourceSelectArguments.Empty);

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

                    if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["Amount"];
                        worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["DT"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["DT"];
                        worksheet.Cells[R, 4].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["EID"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["EID"];
                        //worksheet.Cells[R, 5].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["PassportEnrolmentDate"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["PassportEnrolmentDate"];
                        worksheet.Cells[R, 6].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["Msg"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["Msg"];
                        //worksheet.Cells[R, 7].Style.Numberformat.Format = "dd/MM/yyyy";
                    }

                    if (DV.Table.Rows[r]["Reasons"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["Reasons"];
                        // worksheet.Cells[R, 6].Style.Numberformat.Format = "{0:N2}";
                        //worksheet.Cells[R, 3].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                    }
                }

                worksheet.Cells["A1:K1"].Style.WrapText = true;
                worksheet.Cells["A1:K1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                worksheet.Cells["A1:K1"].Style.Font.Bold = true;
                worksheet.Cells["A1:K4"].Style.WrapText = true;
                worksheet.Cells.AutoFitColumns();

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
                string.Format("attachment;filename=" + "DIP_Not_Verified.xlsx"));
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.BinaryWrite(content);
            Response.End();
        }
        catch (Exception ex)
        {
            // lblStatus.Text = ex.Message; 
        }
    }

    protected void SqlDataSourceData_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        cmdExport.Visible = e.AffectedRows > 0;
        //litTotalAmount.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmount"].Value);
        litTotalPaid.Text = string.Format(AKControl1.Bangla, "{0:N0}", e.Command.Parameters["@Total"].Value);

        //litTotal_Amount_WithOutVat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Amount_WithOutVat"].Value);
        //litTotal_Vat.Text = string.Format(AKControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalPaid_Vat"].Value);
    }
}