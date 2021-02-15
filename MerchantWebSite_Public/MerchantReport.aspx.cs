using OfficeOpenXml;
using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ServiceCube
{
    public partial class MerchantReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
                txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);

                //       GetPaymentMarchentName();
          //      dblStatus.DataBind();


            }

          


            this.Title = "Checkout Payment Log";
           // this.Title = UserControl1.getValueOfKey("AppName");
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
        bool UsedVisible = false;
        bool VerifiedVisible = false;
        bool VatVisible = false;
        bool ServiceChargeVisible = false;
        bool TotalAmountVisible = false;


        protected void SqlDataSource_Payment_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
            lblStatus.Text = string.Format("Total <b>{0:N0}</b>", e.AffectedRows);
           // cmdExport.Visible = e.AffectedRows > 0;
            if (e.AffectedRows > 0)
            {
                cmdExport.Visible = true;
                 UsedVisible = (bool)e.Command.Parameters["@UsedVisible"].Value;
                 VerifiedVisible = (bool)e.Command.Parameters["@VerifiedVisible"].Value;
                 VatVisible = (bool)e.Command.Parameters["@VatVisible"].Value;
                 ServiceChargeVisible = (bool)e.Command.Parameters["@ServiceChargeVisible"].Value;
                 TotalAmountVisible = (bool)e.Command.Parameters["@TotalAmountVisible"].Value;                

                for (int i = 0; i < grdvPayment.Columns.Count; i++)
                {
                    // string a = grdvPayment.Columns[i].SortExpression;
                    if (grdvPayment.Columns[i].SortExpression == "Used")
                        grdvPayment.Columns[i].Visible = UsedVisible;
                    if (grdvPayment.Columns[i].SortExpression == "Verified")
                        grdvPayment.Columns[i].Visible = VerifiedVisible;
                    if (grdvPayment.Columns[i].SortExpression == "VatAmount")
                        grdvPayment.Columns[i].Visible = VatVisible;
                    if (grdvPayment.Columns[i].SortExpression == "ServiceCharge")
                        grdvPayment.Columns[i].Visible = ServiceChargeVisible;
                    if (grdvPayment.Columns[i].SortExpression == "Amount")
                        grdvPayment.Columns[i].Visible = TotalAmountVisible;


                }
            }
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
      
        protected void cmdOK_Click(object sender, EventArgs e)
        {
            //RefreshData();
            string a = ddlMerchant.Text.ToString();
        }

        protected void ddlMerchant_SelectedIndexChanged(object sender, EventArgs e)
        {
            dblStatus.Items.Clear();
            dblStatus.Items.Add(new ListItem("All", "-1"));
            dblStatus.DataBind();
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
                    int C = 0;

                    DataView DV = (DataView)SqlDataSource_Payment.Select(DataSourceSelectArguments.Empty);

                    //Adding Title Row
                    C++;
                    worksheet.Cells[StartRow, C].Value = "Ref ID";
                    worksheet.Column(C).Width = 16;

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Order ID";
                    worksheet.Column(C).Width = 25;

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Name";
                    worksheet.Column(C).Width = 25;

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Marchent ID";
                    worksheet.Column(C).Width = 15;

                    if (TotalAmountVisible)
                    {
                        C++;
                        worksheet.Cells[StartRow, C].Value = "Amount";
                        worksheet.Column(C).Width = 15;
                    }

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Fees";
                    worksheet.Column(C).Width = 15;

                    if (VatVisible)
                    {
                        C++;
                        worksheet.Cells[StartRow, C].Value = "Vat Amount";
                        worksheet.Column(C).Width = 15;
                    }

                    if (ServiceChargeVisible)
                    {
                        C++;
                        worksheet.Cells[StartRow, C].Value = "Service Charge";
                        worksheet.Column(C).Width = 15;
                    }

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Status";
                    worksheet.Column(C).Width = 10;

                    if (VerifiedVisible)
                    {
                        C++;
                        worksheet.Cells[StartRow, C].Value = "Verified";
                        worksheet.Column(C).Width = 10;
                    }

                    if (UsedVisible)
                    {
                        C++;
                        worksheet.Cells[StartRow, C].Value = "Used";
                        worksheet.Column(C).Width = 10;
                    }

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Email";
                    worksheet.Column(C).Width = 25;
                    

                    C++;
                    worksheet.Cells[StartRow, C].Value = "Trn Date";
                    worksheet.Column(C).Width = 15;
                    

                    int R;

                    for (int r = 0; r < DV.Table.Rows.Count; r++)
                    {
                        C = 0;
                        R = StartRow + r + 1;

                        C++;
                        if (DV.Table.Rows[r]["RefID"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["RefID"].ToString();
                        }

                        C++;
                        if (DV.Table.Rows[r]["OrderID"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["OrderID"].ToString();
                        }

                        C++;
                        if (DV.Table.Rows[r]["FullName"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["FullName"].ToString();
                        }

                        C++;
                        if (DV.Table.Rows[r]["MarchentID"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["MarchentID"].ToString();
                        }

                        if (TotalAmountVisible)
                        {
                            C++;
                            if (DV.Table.Rows[r]["Amount"] != DBNull.Value)
                            {
                                worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Amount"];
                                worksheet.Cells[R, C].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                            }
                        }

                        C++;
                        if (DV.Table.Rows[r]["Fees"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Fees"];
                            worksheet.Cells[R, C].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                        }

                        if (VatVisible)
                        {
                            C++;
                            if (DV.Table.Rows[r]["VatAmount"] != DBNull.Value)
                            {
                                worksheet.Cells[R, C].Value = DV.Table.Rows[r]["VatAmount"];
                                worksheet.Cells[R, C].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                            }
                        }

                        if (ServiceChargeVisible)
                        {
                            C++;
                            if (DV.Table.Rows[r]["ServiceCharge"] != DBNull.Value)
                            {
                                worksheet.Cells[R, C].Value = DV.Table.Rows[r]["ServiceCharge"];
                                worksheet.Cells[R, C].Style.Numberformat.Format = "#,##0.00;(#,##0.00)";
                            }
                        }

                        C++;
                        if (DV.Table.Rows[r]["Status"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Status"];
                        }

                        if (VerifiedVisible)
                        {
                            C++;
                            if (DV.Table.Rows[r]["Verified"] != DBNull.Value)
                            {
                                worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Verified"].ToString();
                            }
                        }

                        if (UsedVisible)
                        {
                            C++;
                            if (DV.Table.Rows[r]["Used"] != DBNull.Value && UsedVisible)
                            {
                                worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Used"].ToString();
                            }
                        }

                        C++;
                        if (DV.Table.Rows[r]["Email"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["Email"];
                         
                        }

                        C++;
                        if (DV.Table.Rows[r]["TrnDate"] != DBNull.Value)
                        {
                            worksheet.Cells[R, C].Value = DV.Table.Rows[r]["TrnDate"];
                            worksheet.Cells[R, C].Style.Numberformat.Format = "dd/MM/yyyy";
                        }
                   

                    }


                    worksheet.Cells["A1:Z1"].Style.WrapText = true;
                    worksheet.Cells["A1:Z1"].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    worksheet.Cells["A1:Z1"].Style.Font.Bold = true;

                    //worksheet.Cells["A1:B1"].Merge = true;

                    //Adding Properties
                    xlPackage.Workbook.Properties.Title = "Checkout Payments Trust Bank";
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
                    txtDateTo.Text.Replace("/", "")
                    ));
                Response.Cache.SetCacheability(HttpCacheability.NoCache);
                Response.BinaryWrite(content);
                Response.End();
            }
            catch (Exception ex)
            {
                // lblStatus.Text = ex.Message; 
            }
        }

        protected void grdvPayment_DataBound(object sender, EventArgs e)
        {
            //const int countriesColumnIndex = 4;
            //if (someCondition == true)
            //{
                // Hide the Countries column
            //    this.grdvPayment.Columns[countriesColumnIndex].Visible = false;
            //this.grdvPayment.Columns[5].Visible = false;
            //}
        }
    }
}