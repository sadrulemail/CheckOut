using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

public partial class BtclPayReport1 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        Title = "Date wise BTCL Payment Report";

        //if (!IsPostBack) txtFilter.Focus();

        if (!IsPostBack)
        {
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
        }
    //    CrystalReportViewer1.Visible = IsPostBack;
        //GridView1.Visible = IsPostBack;
        //cmdExport.Visible = IsPostBack;
    }
  //  HttpContext context;

    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
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
        }
        catch (Exception) { }
    }

    protected void cboBranch_DataBound(object sender, EventArgs e)
    {
        if (!TrustControl1.isRole("ADMIN"))
        {
            foreach (ListItem LI in cboBranch.Items)
                LI.Selected = false;
            if (Session["BRANCHID"].ToString() == "1")
            {
                foreach (ListItem LI in cboBranch.Items)
                    if (LI.Value == Session["BRANCHID"].ToString())
                        LI.Selected = true;
            }
            else
            {
                foreach (ListItem LI in cboBranch.Items)
                    if (LI.Value == Session["BRANCHID"].ToString())
                        LI.Selected = true;
                    else
                        LI.Enabled = false;
            }
        }
    }
    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        litTotalAmount.Text = string.Format(TrustControl1.Bangla, "{0:N2}", e.Command.Parameters["@TotalAmountAll"].Value);
        //litTotalPaid.Text = string.Format(TrustControl1.Bangla, "{0:N0}", e.Command.Parameters["@TotalPaid"].Value);
    }

    protected void btnDetails_Click(object sender, EventArgs e)
    {

        CrystalReportViewer1.DataBind();
        CrystalReportViewer1.Visible = true;

        //bool hasFile = false;
        //byte[] output = null;
        //string Msg = "";
        //using (SqlConnection conn = new SqlConnection())
        //{
        //    string Query = "s_BtclPayDetailsDateWise";

        //    conn.ConnectionString = System.Configuration.ConfigurationManager
        //                    .ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;


        //    using (SqlCommand cmd = new SqlCommand(Query, conn))
        //    {
        //        cmd.CommandText = Query;
        //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        cmd.Parameters.Add("@FromDate ", System.Data.SqlDbType.Date).Value = txtDateFrom.Text;
        //        cmd.Parameters.Add("@ToDate", System.Data.SqlDbType.Date).Value = txtDateTo.Text;
        //        cmd.Parameters.Add("@BranchCode", System.Data.SqlDbType.VarChar).Value = cboBranch.SelectedValue.ToString();


        //        cmd.Connection = conn;
        //        conn.Open();

        //        using (SqlDataReader sdr = cmd.ExecuteReader())
        //        {
        //            if (sdr.HasRows)
        //            {
        //                Checkout_Receipt.CheckoutReceipt r = new Checkout_Receipt.CheckoutReceipt();
        //                 hasFile = true;
        //                while (sdr.Read())
        //                {

        //                        output = r.getBTCLBytesFromCrystalReport(
        //                              sdr["ExchangeCode"].ToString(),
        //                               sdr["PhoneNumber"].ToString(),
        //                              sdr["BillMonth"].ToString(),
        //                              sdr["BillYear"].ToString(),
        //                              double.Parse(sdr["BTCLAmount"].ToString()),
        //                                 double.Parse(sdr["VatAmount"].ToString()),
        //                                  double.Parse(sdr["TotalAmount"].ToString()),

        //                              sdr["RefID_Merchant"].ToString(),
        //                              sdr["Meta2"].ToString(),
        //                              sdr["BranchName"].ToString(),
        //                              DateTime.Parse(txtDateFrom.Text),
        //                               DateTime.Parse(txtDateTo.Text)
        //                              );

        //                }
        //            }
        //        }

        //    }
        //}


        //if (hasFile)
        //{
        //   Response.Clear();
        //    Response.AddHeader("content-disposition", "inline; filename=\"" + "refid" + ".pdf\"");
        //    Response.AddHeader("content-length", output.Length.ToString());
        //    Response.ContentType = "application/pdf";
        //    Response.AddHeader("Pragma", "public");
        //    Response.AddHeader("X-Content-Type-Options", "nosniff");
        //    Response.AddHeader("X-Download-Options", "noopen");
        //    Response.BinaryWrite(output);
        //    Response.Flush();
        //    Response.Close();
        //}
        //else
        //{
        //    TrustControl1.ClientMsg(Msg);
        //}

        //try
        //{
        //    string ContentType = "attachment";
        //    using (Stream oStream = (Stream)CrystalReportSource1.ReportDocument.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
        //    {
        //        using (MemoryStream ms = new MemoryStream())
        //        {
        //            //SqlDataSourcePrintLog_Insert.Select(DataSourceSelectArguments.Empty);
        //            oStream.CopyTo(ms);
        //            Response.Clear();
        //            Response.ClearContent();
        //            Response.ClearHeaders();
        //            Response.Buffer = true;
        //            Response.ContentType = "application/pdf";
        //            Response.AddHeader("Content-Disposition", string.Format("{1};filename=Request_{0}.pdf", Request.QueryString["reqid"], ContentType));
        //            Response.Cache.SetCacheability(HttpCacheability.NoCache);
        //            Response.BinaryWrite(ms.ToArray());
        //            Response.End();
        //        }
        //    }
        //}
        //catch (Exception ex)
        //{
        //    Response.Write(ex.Message);
        //}

    }



    protected void btnSummary_Click(object sender, EventArgs e)
    {
        CrystalReportViewer2.DataBind();
        CrystalReportViewer2.Visible = true;
    }
}