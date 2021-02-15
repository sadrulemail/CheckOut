using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using OfficeOpenXml;
using System.IO;
//using SocialExplorer.IO.FastDBF;
using System.Net;
using System.Data.SqlClient;

public partial class REB_Download_Batch : System.Web.UI.Page
{
    string Batch ="";
    string type = "";
    string keycode ="";

    protected void Page_Load(object sender, EventArgs e)
    {
        //TrustControl.isRole("ADMIN", "REB_UPLOAD");

        string Batch = Request.QueryString["Batch"];
        string type = Request.QueryString["type"];
        string keycode = Request.QueryString["keycode"];

        litDownlaod.Text = string.Format("Download: <a  href='REB_Download_Batch.aspx?Batch={0}&keycode={1}&type=csv'><b>Batch: {0}</b></a>", Batch, keycode);
        //btnDownload.Visible = false;

        //target='_blank'

        this.Title = string.Format("REB Download Batch: {0}", Request.QueryString["batch"]);
        lilTitle.Text = string.Format("REB Download Batch: {0}", Request.QueryString["batch"]);

        if (!string.IsNullOrEmpty(Batch.ToString()) && !string.IsNullOrEmpty(type) && !string.IsNullOrEmpty(keycode))
        {
            if (string.Format("{0}", Request.QueryString["type"]) == "csv")
            {

                string connString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
                SqlConnection conn = new SqlConnection(connString);
                conn.Open();
                SqlCommand cmd = new SqlCommand();
                cmd.CommandText = "s_REB_DownloadBatch_Show";
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("EmpID", Session["USERNAME"].ToString());
                cmd.Parameters.AddWithValue("Batch", Request.QueryString["batch"]);
                cmd.Parameters.AddWithValue("keycode", Request.QueryString["keycode"]);
                cmd.Connection = conn;
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                string columns = "SL,SMSBILLNO,BOOK,SMSACCOUNTNO,MONTH,YEAR,BILLEDDATE,PAYDATE,AMOUNT,PAYDATEWITHLPC,AMOUNTWITHLPC,COLLCODE,COLLDATE,COLLAMOUNT";

                StringBuilder csv = new StringBuilder();

                if (dt.Rows.Count > 0)
                {
                    csv.Append(columns);
                    foreach (DataRow dr in dt.Rows)
                    {
                        csv.Append(Environment.NewLine);
                        string BilledDate = String.Format("{0:dd-MM-yyyy}", Convert.ToDateTime(dr["BilledDate"].ToString()));
                        string PayDate = String.Format("{0:dd-MM-yyyy}", Convert.ToDateTime(dr["PayDate"].ToString()));
                        string PayDateWithLPC = String.Format("{0:dd-MM-yyyy}", Convert.ToDateTime(dr["PayDateWithLPC"].ToString()));
                        string CollectionDT = String.Format("{0:dd-MM-yyyy}", Convert.ToDateTime(dr["CollectionDT"].ToString()));

                        string vv = dr["SL"].ToString() + "," + dr["SMSBillNo"].ToString() + "," + dr["Book"].ToString() + "," + dr["SMSAccountNo"].ToString() + ","
                            + dr["BillMonth"].ToString() + "," + dr["BillYear"].ToString() + "," + BilledDate + "," + PayDate + "," +
                            dr["Amount"].ToString() + "," + PayDateWithLPC + "," + dr["AmountWithLPC"].ToString() + "," +
                            dr["CollectionCode"].ToString() + "," + CollectionDT + "," + dr["PaymentAmount"].ToString();
                        csv.Append(vv);
                        // String.Format("{0:M/d/yyyy}", dt);
                    }
                }

                string attachment = "attachment; filename=REB_TBL_" + Request.QueryString["batch"].ToString() + ".csv";
                //TrustControl1.ClientMsg(GridView1.Rows[0].Cells[1].te()); return;                        
                HttpContext.Current.Response.ClearHeaders();
                HttpContext.Current.Response.Clear();
                HttpContext.Current.Response.ClearContent();
                HttpContext.Current.Response.AddHeader("content-disposition", attachment);
                HttpContext.Current.Response.ContentType = "application/CSV";
                HttpContext.Current.Response.AddHeader("Pragma", "public");

                HttpContext.Current.Response.Write(csv);
                HttpContext.Current.Response.End();
        
            
            }
            else if (string.Format("{0}", Request.QueryString["type"]) == "view")
            {
                GridView1.Visible=true;
            }

            else if (string.Format("{0}", Request.QueryString["type"]) == "xlsx")
            {
                //try
                //{
                //    string FileName = Path.GetTempFileName();
                //    string BatchID = Request.QueryString["batch"].ToString();
                //    string CardType = Request.QueryString["CardType"].ToString();
                //    //FileName = "C:\\1.xlsx";
                //    FileInfo FI = new FileInfo(FileName);
                //    if (File.Exists(FileName)) File.Delete(FileName);

                //    using (ExcelPackage xlPackage = new ExcelPackage(FI))
                //    {
                //        ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("Cards");
                //        int StartRow = 1;

                //        //Adding Title Row
                //        worksheet.Column(1).Width = 35;
                //        worksheet.Column(2).Width = 8;
                //        worksheet.Column(3).Width = 6;
                //        worksheet.Column(4).Width = 30;
                //        worksheet.Column(5).Width = 20;
                //        worksheet.Column(6).Width = 10;
                //        worksheet.Column(7).Width = 15;
                //        worksheet.Column(8).Width = 10;
                //        worksheet.Column(9).Width = 25;
                //        worksheet.Column(10).Width = 25;
                //        worksheet.Column(11).Width = 25;
                //        worksheet.Column(12).Width = 10;
                //        worksheet.Column(13).Width = 10;
                //        worksheet.Column(14).Width = 10;
                //        worksheet.Column(15).Width = 20;
                //        worksheet.Column(16).Width = 20;
                //        worksheet.Column(17).Width = 35;

                //        //worksheet.Cells["A1:C1"].Style.Font.Bold = true;

                //        //Adding Title Row
                //        worksheet.Cells[StartRow, 1].Value = "FIO";
                //        worksheet.Cells[StartRow, 2].Value = "SEX";
                //        worksheet.Cells[StartRow, 3].Value = "TITLE";
                //        worksheet.Cells[StartRow, 4].Value = "NAMEONCARD";
                //        worksheet.Cells[StartRow, 5].Value = "ACCOUNT";
                //        worksheet.Cells[StartRow, 6].Value = "ACCOUNTTP";
                //        worksheet.Cells[StartRow, 7].Value = "BIRTHDAY";
                //        worksheet.Cells[StartRow, 8].Value = "ACCTSTAT";
                //        worksheet.Cells[StartRow, 9].Value = "ADDRESS";
                //        worksheet.Cells[StartRow, 10].Value = "CORADDRESS";
                //        worksheet.Cells[StartRow, 11].Value = "RESADDRESS";
                //        worksheet.Cells[StartRow, 12].Value = "CNTRYREG";
                //        worksheet.Cells[StartRow, 13].Value = "CNTRYCONT";
                //        worksheet.Cells[StartRow, 14].Value = "CNTRYLIVE";
                //        worksheet.Cells[StartRow, 15].Value = "CELLPHONE";
                //        worksheet.Cells[StartRow, 16].Value = "PHONE";
                //        worksheet.Cells[StartRow, 17].Value = "CLIENTPROP";


                //        DataView DV = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
                //        int R = 0;
                //        for (int r = 0; r < DV.Table.Rows.Count; r++)
                //        {
                //            R = StartRow + r + 1;
                //            if (DV.Table.Rows[r]["FIO"] != DBNull.Value)
                //                worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["FIO"].ToString();
                //            if (DV.Table.Rows[r]["SEX"] != DBNull.Value)
                //                worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["SEX"].ToString();
                //            if (DV.Table.Rows[r]["TITLE"] != DBNull.Value)
                //                worksheet.Cells[R, 3].Value = DV.Table.Rows[r]["TITLE"].ToString();
                //            if (DV.Table.Rows[r]["NAMEONCARD"] != DBNull.Value)
                //                worksheet.Cells[R, 4].Value = DV.Table.Rows[r]["NAMEONCARD"].ToString();
                //            if (DV.Table.Rows[r]["ACCOUNT"] != DBNull.Value)
                //                worksheet.Cells[R, 5].Value = DV.Table.Rows[r]["ACCOUNT"].ToString();

                //            if (DV.Table.Rows[r]["ACCOUNTTP"] != DBNull.Value)
                //            {
                //                worksheet.Cells[R, 6].Value = DV.Table.Rows[r]["ACCOUNTTP"];
                //            }

                //            if (DV.Table.Rows[r]["BIRTHDAY"] != DBNull.Value)
                //            {
                //                worksheet.Cells[R, 7].Value = DV.Table.Rows[r]["BIRTHDAY"];
                //                worksheet.Cells[R, 7].Style.Numberformat.Format = "dd-MMM-yyyy";
                //            }

                //            if (DV.Table.Rows[r]["ACCTSTAT"] != DBNull.Value)
                //                worksheet.Cells[R, 8].Value = DV.Table.Rows[r]["ACCTSTAT"].ToString();
                //            if (DV.Table.Rows[r]["ADDRESS"] != DBNull.Value)
                //                worksheet.Cells[R, 9].Value = DV.Table.Rows[r]["ADDRESS"].ToString();
                //            if (DV.Table.Rows[r]["CORADDRESS"] != DBNull.Value)
                //                worksheet.Cells[R, 10].Value = DV.Table.Rows[r]["CORADDRESS"].ToString();
                //            if (DV.Table.Rows[r]["RESADDRESS"] != DBNull.Value)
                //                worksheet.Cells[R, 11].Value = DV.Table.Rows[r]["RESADDRESS"].ToString();
                //            if (DV.Table.Rows[r]["CNTRYREG"] != DBNull.Value)
                //                worksheet.Cells[R, 12].Value = DV.Table.Rows[r]["CNTRYREG"];
                //            if (DV.Table.Rows[r]["CNTRYCONT"] != DBNull.Value)
                //                worksheet.Cells[R, 13].Value = DV.Table.Rows[r]["CNTRYCONT"];
                //            if (DV.Table.Rows[r]["CNTRYLIVE"] != DBNull.Value)
                //                worksheet.Cells[R, 14].Value = DV.Table.Rows[r]["CNTRYLIVE"];
                //            if (DV.Table.Rows[r]["CELLPHONE"] != DBNull.Value)
                //                worksheet.Cells[R, 15].Value = DV.Table.Rows[r]["CELLPHONE"].ToString();
                //            if (DV.Table.Rows[r]["PHONE"] != DBNull.Value)
                //                worksheet.Cells[R, 16].Value = DV.Table.Rows[r]["PHONE"].ToString();
                //            if (DV.Table.Rows[r]["CLIENTPROP"] != DBNull.Value)
                //                worksheet.Cells[R, 17].Value = DV.Table.Rows[r]["CLIENTPROP"].ToString();
                //            //worksheet.Cells[R, 2].Value = "4";
                //            //worksheet.Cells[R, 3].Value = "1";
                //        }

                //        //worksheet.Cells["A1:C" + R].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;


                //        //Adding Properties
                //        xlPackage.Workbook.Properties.Title = "Export_to_ITCL (Batch " + BatchID + ")";
                //        xlPackage.Workbook.Properties.Author = "Ashik Iqbal (www.ashik.info)";
                //        xlPackage.Workbook.Properties.Company = "Trust Bank Limited";
                //        xlPackage.Workbook.Properties.LastModifiedBy = string.Format("{0} ({1})", Session["FULLNAME"], Session["EMAIL"]);

                //        xlPackage.Save();
                //    }


                //    //Reading File Content
                //    byte[] content = File.ReadAllBytes(FileName);
                //    File.Delete(FileName);

                //    //Downloading File
                //    Response.Clear();
                //    Response.ClearContent();
                //    Response.ClearHeaders();
                //    Response.ContentType = "application/ms-excel";
                //    Response.AddHeader("Content-Disposition", "attachment;filename=" + "Export_to_ITCL_" + BatchID + "_CardType_" + CardType + ".xlsx");
                //    Response.Cache.SetCacheability(HttpCacheability.NoCache);
                //    Response.BinaryWrite(content);
                //    Response.End();

                //}
                //catch (Exception ex)
                //{
                //    TrustControl1.ClientMsg(ex.Message);
                //}

            }
        }

    }

    private string getCSV_ReExport(string BatchID)
    {
        //StringBuilder csv = new StringBuilder();
        ////SqlDataSourceReExport.SelectParameters["BatchID"].DefaultValue = BatchID;
        //DataView dv = (DataView)SqlDataSourceReExport.Select(DataSourceSelectArguments.Empty);

        ////csv.Append("\"File ID\",\"File Name\",\"Description\",\"Rack Name\",\"Status\"");
        ////csv.Append(Environment.NewLine);

        //for (int i = 0; i < dv.Table.Rows.Count; i++)
        //{
        //    csv.Append(dv.Table.Rows[i][0]);
        //    csv.Append(Environment.NewLine);
        //}
        //return csv.ToString();

        return "";
    }


    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        if (GridView1.Rows.Count > 0)
            lilTitle.Visible = true;
        else
            lilTitle.Visible = false;
        
    }
}