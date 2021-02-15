using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI.WebControls;

public partial class Titas_Report : System.Web.UI.Page
{
    DataTable DT = new DataTable();
    string CANCELED = "";
    string Signature = "<table width='100%' style='margin-top:100px;margin-bottom:20px;'><tr><td width='50%' class='center bold'>____________________________<div class='bold center'>Authorized Seal & Signature</div></td><td width='50%' class='center'>_________________________________<div class='bold center'>Manager/2nd off. Seal & Signature</div></td></tr></table>";

    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();

        if (IsPostBack)
        {
            //RefreshReport();
        }
        else
        {
            
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
        }        
    }

    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            RefreshReport();
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
            RefreshReport();
        }
        catch (Exception) { }
    }

    protected void txtDateFrom_TextChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void txtDateTo_TextChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void cmdOK_Click(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void cboBranch_DataBound(object sender, EventArgs e)
    {
        if (!TrustControl1.isRole("ADMIN"))
        {
            foreach (ListItem LI in cboBranch.Items)
                LI.Selected = false;

            foreach (ListItem LI in cboBranch.Items)
                if (LI.Value == Session["BRANCHID"].ToString())
                    LI.Selected = true;
                else
                    LI.Enabled = false;
        }
    }

    private void DataFill(string _Query)
    {
        using (SqlDataAdapter da = new SqlDataAdapter())
        {
            using (SqlConnection conn = new SqlConnection())
            {
                conn.ConnectionString = 
                    ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = _Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@Filter", System.Data.SqlDbType.VarChar).Value = txtRefID.Text;
                    cmd.Parameters.Add("@TransID", System.Data.SqlDbType.VarChar).Value = txtTrnsID.Text;
                    cmd.Parameters.Add("@PDateFrom", System.Data.SqlDbType.Date).Value = txtDateFrom.Text;
                    cmd.Parameters.Add("@PDateTo", System.Data.SqlDbType.Date).Value = txtDateTo.Text;
                    cmd.Parameters.Add("@Status", System.Data.SqlDbType.Int).Value = dblStatus.SelectedItem.Value;
                    cmd.Parameters.Add("@Branch", System.Data.SqlDbType.Int).Value = cboBranch.SelectedItem.Value;
                    cmd.Parameters.Add("@Zone", System.Data.SqlDbType.VarChar).Value = cboZones.SelectedItem.Value;
                    cmd.Parameters.Add("@isMeter", System.Data.SqlDbType.Bit).Value = dboType.SelectedItem.Value;

                    cmd.Connection = conn;
                    if (conn.State == ConnectionState.Closed) conn.Open();

                    da.SelectCommand = cmd;
                    da.Fill(DT);
                }
            }
        }
    }

    private void ZoneWiseDetailsReport()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Zone wise Bill Collection Details Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_BranchWiseDetails";
        DataFill(Query);

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;
        string LastZone = "";

        double G_BillAmount = 0;
        double G_SurCharge = 0;
        double G_TotalAmount = 0;
        double G_RevStamp = 0;
        string TableHeader = "<tr class='bold table-title " + CANCELED + "'><td>SL</td><td>Routing No</td><td>Customer Code</td><td>Customer Name</td><td>Particulers</td><td>Batch No.</td><td>Bill Amount</td><td>Surcharge</td><td>Total Collection</td><td>Rev. Stamp</td><td class='hidden-print'>Payment ID</td><td class='hidden-print'>Date</td></tr>";
        string ZoneHeader = "";
        string TotalRow = "";
        string G_TotalRow = "";
        int SL = 0;
        bool NewGroup = false;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastZone != DT.Rows[r]["ZoneName"].ToString())
                {
                    NewGroup = true;
                    LastZone = DT.Rows[r]["ZoneName"].ToString();

                    ZoneHeader = string.Format("<tr><td class='bold left table-title2' style='' colspan='10'>Zone / ZMO: {0}</td><td colspan='2' class='hidden-print table-title2'></td></tr>", LastZone);

                    s.Append(TotalRow);

                    if (r == 0)
                    {
                        s.Append(string.Format("<div class='bold'>{0}{1}{2}</div>",
                        cboBranch.SelectedItem.Text,
                        (cboBranch.SelectedItem.Value == "-1" ? "" : ", Routing Number: "),
                        (cboBranch.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["RoutingNo"]))
                        );
                    }
                    //s.Append("<thead>" + ZoneHeader + TableHeader + "</thead>");
                    s.Append("" + ZoneHeader + TableHeader + "");
                    SL = 1;
                    BillAmount = 0;
                    SurCharge = 0;
                    TotalAmount = 0;
                    RevStamp = 0;
                }
                else
                {
                    NewGroup = false;
                }

                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                G_BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                G_SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                G_TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());


                s.Append("<tr>");

                s.Append(string.Format("<td class='center'><a href='Checkout_Link.aspx?refid={1}' title='View' target='_blank'>{0}</a></td>"
                    , SL++, DT.Rows[r]["RefID"]));               

                //s.Append(string.Format("<td>{0}</td>"
                //    , DT.Rows[r]["ZoneName"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["RoutingNo"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["CustomerCode"]));             

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["CustomerName"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["Particulars"]));               

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["BatchNo"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["Amount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["Surcharge"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["TotalAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));               

                

                s.Append(string.Format("<td class='center hidden-print'>{0}</td>"
                   , DT.Rows[r]["PaymentId"]));

                s.Append(string.Format("<td class='center hidden-print'>{0:dd/MM/yyyy}</td>"
                    , DT.Rows[r]["TrnDate"]));

                s.Append("</tr>");

                //s.Append(
                //        string.Format("<tr><td class='center'><a href='Checkout_Link.aspx?refid={10}' title='View' target='_blank'>{0}</a></td><td>{11:dd/MM/yyyy}</td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td class='center'>{5}</td><td class='right'>{6:N2}</td><td class='right'>{7:N2}</td><td class='right'>{8:N2}</td><td class='right'>{9:N2}</td></tr>",
                //            SL++,
                //            DT.Rows[r]["ZoneName"],
                //            DT.Rows[r]["CustomerCode"],
                //            DT.Rows[r]["CustomerName"],
                //            DT.Rows[r]["Particulars"],
                //            DT.Rows[r]["PaymentId"],
                //            DT.Rows[r]["Amount"],
                //            DT.Rows[r]["Surcharge"],
                //            DT.Rows[r]["TotalAmount"],
                //            DT.Rows[r]["RevStamp"],
                //            DT.Rows[r]["RefID"],
                //            DT.Rows[r]["TrnDate"]
                //        ));

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='6'>({0}) Total: ({5:N0})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2' class='hidden-print'></td></tr>",

                            DT.Rows[r]["ZoneName"],
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            SL - 1
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='6'>{0:N0} Total: ({5})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2' class='hidden-print'></td></tr>",

                            "Grand",
                            G_BillAmount,
                            G_SurCharge,
                            G_TotalAmount,
                            G_RevStamp,
                            DT.Rows.Count
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            s.Append(Signature);
            
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void ZoneWiseDetailsReport_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Daily Zone Wise Details Bill Collection (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_BranchWiseDetails";
        DataFill(Query);

        double SourceTaxAmount = 0;
        double CollectionAmount = 0;
        double RevStamp = 0;
        double InvoiceAmount = 0;        
        string LastZone = "";

        double G_SourceTaxAmount = 0;
        double G_CollectionAmount = 0;
        double G_RevStamp = 0;
        double G_InvoiceAmount = 0;
        
        string TableHeader = "<tr class='bold table-title " + CANCELED + "'><td>SL</td><td>Date</td><td>Customer Code</td><td>Invoice No</td><td>Customer Name</td><td>Payment ID</td><td>AIT/Source Tax</td><td>Collection Amount</td><td>Rev. Stamp</td><td>Invoice Amount</td><td class='hidden-print'>Branch Name</td><td class='hidden-print'>Routing</td></tr>";
        string ZoneHeader = "";
        string TotalRow = "";
        string G_TotalRow = "";
        int SL = 0;
        bool NewGroup = false;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastZone != DT.Rows[r]["Zone"].ToString())
                {
                    NewGroup = true;
                    LastZone = DT.Rows[r]["Zone"].ToString();

                    ZoneHeader = string.Format("<tr><td class='bold left table-title2' style='' colspan='10'>Zone / ZMO: {0}</td><td colspan='2' class='hidden-print table-title2'></td></tr>", LastZone);

                    s.Append(TotalRow);

                    if (r == 0)
                    {
                        s.Append(string.Format("<div class='bold'>{0}{1}{2}</div>",
                        cboBranch.SelectedItem.Text,
                        (cboBranch.SelectedItem.Value == "-1" ? "" : ", Routing Number: "),
                        (cboBranch.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["RoutingNo"]))
                        );
                    }

                    s.Append("" + ZoneHeader + TableHeader + "");
                    SL = 1;
                    SourceTaxAmount = 0;
                    CollectionAmount = 0;
                    InvoiceAmount = 0;
                    RevStamp = 0;
                }
                else
                {
                    NewGroup = false;
                }

                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                G_SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                G_CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                G_InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'><a href='Checkout_Link.aspx?refid={1}' title='View' target='_blank'>{0}</a></td>"
                    , SL++, DT.Rows[r]["RefID"]));

                s.Append(string.Format("<td class='center'>{0:dd/MM/yyyy}</td>"
                    , DT.Rows[r]["TrnDate"]));

               
                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["CustomerCode"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["InvoiceNo"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["CustomerName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["PaymentId"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));

                s.Append(string.Format("<td class='hidden-print'>{0:N2}</td>"
                                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center hidden-print'>{0:N2}</td>"
                                    , DT.Rows[r]["RoutingNo"]));

                s.Append("</tr>");

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='6'>({0}) Total: ({5:N0})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2' class='hidden-print'></td></tr>",

                            DT.Rows[r]["Zone"],
                            SourceTaxAmount,
                            CollectionAmount,                            
                            RevStamp,
                            InvoiceAmount,
                            SL - 1
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='6'>{0:N0} Total: ({5})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2' class='hidden-print'></td></tr>",

                            "Grand",
                            G_SourceTaxAmount,
                            G_CollectionAmount,
                            G_RevStamp,
                            G_InvoiceAmount,                            
                            DT.Rows.Count
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void BranchWiseDetailsReport_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Daily Bank Branch Wise Details Bill Collection (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseDetails";
        DataFill(Query);

        double SourceTaxAmount = 0;
        double CollectionAmount = 0;
        double RevStamp = 0;
        double InvoiceAmount = 0;
        string LastBranch = "";

        double G_SourceTaxAmount = 0;
        double G_CollectionAmount = 0;
        double G_RevStamp = 0;
        double G_InvoiceAmount = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Date</td><td>Branch Name</td><td>Customer Code</td><td>Invoice No</td><td>Customer Name</td><td>Payment ID</td><td>AIT/Source Tax</td><td>Collection Amount</td><td>Rev. Stamp</td><td>Invoice Amount</td><td>Zone</td><td>Routing</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int SL = 0;
        bool NewGroup = false;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastBranch != DT.Rows[r]["BranchName"].ToString())
                {
                    NewGroup = true;
                    LastBranch = DT.Rows[r]["BranchName"].ToString();

                    s.Append(TotalRow);

                    if (r == 0)
                    {
                        s.Append(string.Format("<div class='bold' style='padding:5px'>{0}{1}{2}</div>",
                        cboZones.SelectedItem.Text,
                        (cboZones.SelectedItem.Value == "-1" ? "" : ", Zone Code: "),
                        (cboZones.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["ZoneCode"]))
                        );
                    }

                    s.Append(TableHeader);
                    SL = 1;
                    SourceTaxAmount = 0;
                    CollectionAmount = 0;
                    InvoiceAmount = 0;
                    RevStamp = 0;
                }
                else
                {
                    NewGroup = false;
                }

                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                G_SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                G_CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                G_InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'><a href='Checkout_Link.aspx?refid={1}' title='View' target='_blank'>{0}</a></td>"
                    , SL++, DT.Rows[r]["RefID"]));

                s.Append(string.Format("<td class='center'>{0:dd/MM/yyyy}</td>"
                    , DT.Rows[r]["TrnDate"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["CustomerCode"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["InvoiceNo"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["CustomerName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["PaymentId"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));

                s.Append(string.Format("<td>{0:N2}</td>"
                                    , DT.Rows[r]["Zone"]));

                s.Append(string.Format("<td class='center'>{0:N2}</td>"
                                    , DT.Rows[r]["RoutingNo"]));

                s.Append("</tr>");

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='7'>({0}) Total: ({5:N0})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2'></td></tr>",

                            DT.Rows[r]["BranchName"],
                            SourceTaxAmount,
                            CollectionAmount,
                            RevStamp,
                            InvoiceAmount,
                            SL - 1
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='7'>{0:N0} Total: ({5})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td colspan='2'></td></tr>",

                            "Grand",
                            G_SourceTaxAmount,
                            G_CollectionAmount,
                            G_RevStamp,
                            G_InvoiceAmount,
                            DT.Rows.Count
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void BranchWiseSummaryReport_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Daily Bank Branch Wise Summary Bill Collection (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_BranchWiseSummary";
        DataFill(Query);

        double CollectionAmount = 0;
        double SourceTaxAmount = 0;
        double InvoiceAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Branch Name</td><td>Routing</td><td>No. of Collection</td><td>Collection Amount</td><td>AIT/Source Tax</td><td>Rev. Stamp</td><td>Invoice Amount</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            //s.Append(string.Format("<div class='bold' style='padding:5px'>{0}</div>",
            //    cboZones.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            CollectionAmount = 0;
            SourceTaxAmount = 0;
            InvoiceAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , SL++));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["RoutingNo"]));

                s.Append(string.Format("<td class='center'>{0:N0}</td>"
                    , DT.Rows[r]["Total"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                   , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));

                s.Append("</tr>");
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='3'>Total:</td><td class='center'>{0:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            Total,
                            CollectionAmount,
                            SourceTaxAmount,
                            RevStamp,
                            InvoiceAmount);

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void ZoneWiseSummaryReport_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Daily Zone Wise Summary Bill Collection (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseSummary";
        DataFill(Query);

        double CollectionAmount = 0;
        double SourceTaxAmount = 0;
        double InvoiceAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Zone</td><td>No. of Collection</td><td>Collection Amount</td><td>AIT/Source Tax</td><td>Rev. Stamp</td><td>Invoice Amount</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            //s.Append(string.Format("<div class='bold' style='padding:5px'>{0}</div>",
            //    cboZones.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            CollectionAmount = 0;
            SourceTaxAmount = 0;
            InvoiceAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , SL++));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["Zone"]));

                s.Append(string.Format("<td class='center'>{0:N0}</td>"
                    , DT.Rows[r]["Total"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                   , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));

                s.Append("</tr>");
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='2'>Total:</td><td class='center'>{0:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            Total,
                            CollectionAmount,
                            SourceTaxAmount,
                            RevStamp,
                            InvoiceAmount);

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void DateWiseSummaryReport_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Date Wise Summary Bill Collection (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_DateWiseSummary";
        DataFill(Query);

        double CollectionAmount = 0;
        double SourceTaxAmount = 0;
        double InvoiceAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Date</td><td>No. of Collection</td><td>Collection Amount</td><td>AIT/Source Tax</td><td>Rev. Stamp</td><td>Invoice Amount</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            //s.Append(string.Format("<div class='bold' style='padding:5px'>{0}</div>",
            //    cboZones.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            CollectionAmount = 0;
            SourceTaxAmount = 0;
            InvoiceAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , SL++));

                s.Append(string.Format("<td class='center'>{0:dd/MM/yyyy}</td>"
                    , DT.Rows[r]["TrnDate"]));

                s.Append(string.Format("<td class='center'>{0:N0}</td>"
                    , DT.Rows[r]["Total"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                   , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));

                s.Append("</tr>");
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='2'>Total:</td><td class='center'>{0:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            Total,
                            CollectionAmount,
                            SourceTaxAmount,
                            RevStamp,
                            InvoiceAmount);

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void BranchWiseDetailsReport()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Branch wise Bill Collection Details Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseDetails";
        DataFill(Query);

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;
        string LastBranch = "";

        double G_BillAmount = 0;
        double G_SurCharge = 0;
        double G_TotalAmount = 0;
        double G_RevStamp = 0;
        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Branch Name</td><td>Customer Code</td><td>Customer Name</td><td>Particulers</td><td>Batch ID</td><td>Bill Amount</td><td>Surcharge</td><td>Total Amount</td><td>Rev. Stamp</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int SL = 0;
        bool NewGroup = false;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastBranch != DT.Rows[r]["BranchName"].ToString())
                {
                    NewGroup = true;
                    LastBranch = DT.Rows[r]["BranchName"].ToString();

                    s.Append(TotalRow);
                    if (r == 0)
                    {
                        s.Append(string.Format("<div class='bold' style='padding:5px'>{0}{1}{2}</div>",
                        cboZones.SelectedItem.Text,
                        (cboZones.SelectedItem.Value == "-1" ? "" : ", Zone Code: "),
                        (cboZones.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["ZoneCode"]))
                        );
                    }

                    s.Append(TableHeader);
                    SL = 1;
                    BillAmount = 0;
                    SurCharge = 0;
                    TotalAmount = 0;
                    RevStamp = 0;
                }
                else
                {
                    NewGroup = false;
                }

                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                G_BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                G_SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                G_TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());

                //s.Append(
                //        string.Format("<tr><td class='center'><a href='Checkout_Link.aspx?refid={10}' title='View' target='_blank'>{0}</a></td><td>{1}</td><td>{2}</td><td>{3}</td><td>{4}</td><td class='center'>{5}</td><td class='right'>{6:N2}</td><td class='right'>{7:N2}</td><td class='right'>{8:N2}</td><td class='right'>{9:N2}</td></tr>",
                //            SL++,
                //            DT.Rows[r]["BranchName"],
                //            DT.Rows[r]["CustomerCode"],
                //            DT.Rows[r]["CustomerName"],
                //            DT.Rows[r]["BatchNo"],
                //            DT.Rows[r]["PaymentId"],
                //            DT.Rows[r]["Amount"],
                //            DT.Rows[r]["Surcharge"],
                //            DT.Rows[r]["TotalAmount"],
                //            DT.Rows[r]["RevStamp"],
                //            DT.Rows[r]["RefID"]
                //        ));

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'><a href='Checkout_Link.aspx?refid={1}' title='View' target='_blank'>{0}</a></td>"
                    , SL++, DT.Rows[r]["RefID"]));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["CustomerCode"]));

                s.Append(string.Format("<td>{0:N}</td>"
                    , DT.Rows[r]["CustomerName"]));

                s.Append(string.Format("<td>{0:N}</td>"
                    , DT.Rows[r]["Particulars"]));

                s.Append(string.Format("<td class='center'>{0:N}</td>"
                   , DT.Rows[r]["BatchNo"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["Amount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["Surcharge"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["TotalAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append("</tr>");

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='6'>({0}) Total: ({5:N0})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",

                            DT.Rows[r]["BranchName"],
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            SL - 1
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='6'>{0:N0} Total: ({5})</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",

                            "Grand",
                            G_BillAmount,
                            G_SurCharge,
                            G_TotalAmount,
                            G_RevStamp,
                            DT.Rows.Count
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }    

    private void BranchWiseSummaryReport()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Branch wise Bill Collection Summary Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_BranchWiseSummary";
        DataFill(Query);

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Branch Name</td><td>Routing No.</td><td>No. of Voucher</td><td>Bill Amount</td><td>Surcharge</td><td>Collection Amount</td><td>Rev. Stamp</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            s.Append(string.Format("<div class='bold hidden-print' style='padding:5px'>{0}</div>",
                cboZones.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            BillAmount = 0;
            SurCharge = 0;
            TotalAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());

                s.Append(
                        string.Format("<tr><td class='center'>{0}</td><td>{1}</td><td class='center'>{7}</td><td class='center'>{2:0}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td class='right'>{5:N2}</td><td class='right'>{6:N2}</td></tr>",
                            SL++,
                            DT.Rows[r]["BranchName"],
                            DT.Rows[r]["Total"],
                            DT.Rows[r]["Amount"],
                            DT.Rows[r]["Surcharge"],
                            DT.Rows[r]["TotalAmount"],
                            DT.Rows[r]["RevStamp"],
                            DT.Rows[r]["RoutingNo"]
                        ));
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='3'>{0:N0} Total:</td><td class='center'>{5:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            "",
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            Total
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            s.Append(Signature);
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void ZoneWiseSummaryReport()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Branch Bill Collection Summary Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseSummary";
        DataFill(Query);

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Zone Name</td><td>No. of Collection</td><td>Bill Amount</td><td>Surcharge</td><td>Total Amount</td><td>Rev. Stamp</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            s.Append(string.Format("<div class='bold' style='padding:5px'>{0}</div>",
                cboBranch.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            BillAmount = 0;
            SurCharge = 0;
            TotalAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());                

                s.Append(
                        string.Format("<tr><td class='center'>{0}</td><td>{1}</td><td class='center'>{2:0}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td class='right'>{5:N2}</td><td class='right'>{6:N2}</td></tr>",
                            SL++,
                            DT.Rows[r]["ZoneName"],
                            DT.Rows[r]["Total"],
                            DT.Rows[r]["Amount"],
                            DT.Rows[r]["Surcharge"],
                            DT.Rows[r]["TotalAmount"],
                            DT.Rows[r]["RevStamp"]
                        ));
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='2'>{0:N0} Total:</td><td class='center'>{5:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            "",
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            Total
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            s.Append(string.Format("<div style='font-size:110%' class='bold center'>Net Titas Amount: {0:N2}</div>", TotalAmount - RevStamp));
            s.Append(Signature);
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void DateWiseSummaryReport()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Date wise Collection Summary Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_DateWiseSummary";
        DataFill(Query);

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;

        string TableHeader = "<thead><tr class='" + CANCELED + "'><td>SL</td><td>Date</td><td>No. of Collection</td><td>Bill Amount</td><td>Surcharge</td><td>Total Amount</td><td>Rev. Stamp</td></tr></thead>";
        string TotalRow = "";
        string G_TotalRow = "";
        int Total = 0;
        int SL = 0;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            //s.Append(string.Format("<div class='bold' style='padding:5px'>{0}</div>",
            //    cboBranch.SelectedItem.Text));
            s.Append(TableHeader);
            SL = 1;
            BillAmount = 0;
            SurCharge = 0;
            TotalAmount = 0;
            RevStamp = 0;

            for (int r = 0; r < DT.Rows.Count; r++)
            {
                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += int.Parse(DT.Rows[r]["Total"].ToString());

                s.Append(
                        string.Format("<tr><td class='center'>{0}</td><td class='center'>{1:dd/MM/yyyy}</td><td class='center'>{2:0}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td><td class='right'>{5:N2}</td><td class='right'>{6:N2}</td></tr>",
                            SL++,
                            DT.Rows[r]["TrnDate"],
                            DT.Rows[r]["Total"],
                            DT.Rows[r]["Amount"],
                            DT.Rows[r]["Surcharge"],
                            DT.Rows[r]["TotalAmount"],
                            DT.Rows[r]["RevStamp"]
                        ));
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='2'>{0:N0} Total:</td><td class='center'>{5:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            "",
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            Total
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void ZoneWiseSummary2Report()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "Zone wise Bill Collection Summary Report (NON-METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseSummary2";
        DataFill(Query);
        

        double BillAmount = 0;
        double SurCharge = 0;
        double TotalAmount = 0;
        double RevStamp = 0;
        string LastZone = "";
        double Total = 0;

        double G_BillAmount = 0;
        double G_SurCharge = 0;
        double G_TotalAmount = 0;
        double G_RevStamp = 0;
        string TableHeader = "<tr class='bold table-title " + CANCELED + "'><td>SL</td><td>Branch Name</td><td>Routing No</td><td>No. of Voucher</td><td>Bill Amount</td><td>SurCharge</td><td>Total Amount</td><td>Rev. Stamp</td></tr>";
        string ZoneHeader = "";
        string TotalRow = "";
        string G_TotalRow = "";
        double G_Total = 0;
        int SL = 0;
        bool NewGroup = false;
        
        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastZone != DT.Rows[r]["ZoneName"].ToString())
                {
                    NewGroup = true;
                    LastZone = DT.Rows[r]["ZoneName"].ToString();

                    ZoneHeader = string.Format("<tr><td class='bold left table-title2' style='' colspan='8'>Zone / ZMO: {0}</td></tr>", LastZone);

                    s.Append(TotalRow);
                    //if (r == 0)
                    //{
                    //    s.Append(string.Format("<div class='bold' style='padding:5px'>{0}{1}{2}</div>",
                    //    cboZones.SelectedItem.Text,
                    //    (cboZones.SelectedItem.Value == "-1" ? "" : ", Zone Code: "),
                    //    (cboZones.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["ZoneCode"]))
                    //    );
                    //}
                    //s.Append("<thead>" + ZoneHeader + TableHeader + "</thead>");
                    s.Append("" + ZoneHeader + TableHeader + "");
                    SL = 1;
                    BillAmount = 0;
                    SurCharge = 0;
                    TotalAmount = 0;
                    RevStamp = 0;
                    Total = 0;
                }
                else
                {
                    NewGroup = false;
                }

                BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += double.Parse(DT.Rows[r]["Total"].ToString());

                G_BillAmount += double.Parse(DT.Rows[r]["Amount"].ToString());
                G_SurCharge += double.Parse(DT.Rows[r]["Surcharge"].ToString());
                G_TotalAmount += double.Parse(DT.Rows[r]["TotalAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                G_Total += double.Parse(DT.Rows[r]["Total"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , SL++));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["RoutingNo"]));

                s.Append(string.Format("<td class='center'>{0:N0}</td>"
                    , DT.Rows[r]["Total"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["Amount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["SurCharge"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["TotalAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append("</tr>");

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='3'>Zone / ZMO: ({0}) Total:</td><td class='center'>{5:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",

                            DT.Rows[r]["ZoneName"],
                            BillAmount,
                            SurCharge,
                            TotalAmount,
                            RevStamp,
                            Total
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='3'>{0:N0} Total:</td><td class='center'>{5}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            "Grand",
                            G_BillAmount,
                            G_SurCharge,
                            G_TotalAmount,
                            G_RevStamp,
                            G_Total
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            s.Append(Signature);
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    private void ZoneWiseSummary2Report_Metered()
    {
        StringBuilder s = new StringBuilder();
        litReportTitle.Text = "TITAS - Bill Collection Statement<br>Zone wise Bill Collection Summary Report (METERED)";
        litReportTitle2.Text = "Collection Date: " + txtDateFrom.Text + " to " + txtDateTo.Text;
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string Query = "s_TitasBillPayment_ZoneWiseSummary_M";
        DataFill(Query);


        double CollectionAmount = 0;
        double SourceTaxAmount = 0;
        double InvoiceAmount = 0;
        double RevStamp = 0;
        long Total = 0;
        string LastZone = "";

        double G_CollectionAmount = 0;
        double G_SourceTaxAmount = 0;
        double G_InvoiceAmount = 0;
        double G_RevStamp = 0;
        long G_Total = 0;
        string TableHeader = "<tr class='bold table-title " + CANCELED + "'><td>SL</td><td>Branch Name</td><td>Routing No</td><td>No. of Voucher</td><td>Collection Amount</td><td>AIT/Source Tax</td><td>Rev. Stamp</td><td>Invoice Amount</td></tr>";
        string ZoneHeader = "";
        string TotalRow = "";
        string G_TotalRow = "";
        int SL = 0;
        bool NewGroup = false;

        if (DT.Rows.Count > 0)
        {
            s.Append("<table width='100%' class='table'>");
            for (int r = 0; r < DT.Rows.Count; r++)
            {
                if (LastZone != DT.Rows[r]["Zone"].ToString())
                {
                    NewGroup = true;
                    LastZone = DT.Rows[r]["Zone"].ToString();

                    ZoneHeader = string.Format("<tr><td class='bold left table-title2' style='' colspan='8'>Zone / ZMO: {0}</td></tr>", LastZone);

                    s.Append(TotalRow);
                    //if (r == 0)
                    //{
                    //    s.Append(string.Format("<div class='bold' style='padding:5px'>{0}{1}{2}</div>",
                    //    cboZones.SelectedItem.Text,
                    //    (cboZones.SelectedItem.Value == "-1" ? "" : ", Zone Code: "),
                    //    (cboZones.SelectedItem.Value == "-1" ? "" : DT.Rows[r]["ZoneCode"]))
                    //    );
                    //}
                    //s.Append("<thead>" + ZoneHeader + TableHeader + "</thead>");
                    s.Append("" + ZoneHeader + TableHeader + "");
                    SL = 1;
                    CollectionAmount = 0;
                    SourceTaxAmount = 0;
                    InvoiceAmount = 0;
                    RevStamp = 0;
                }
                else
                {
                    NewGroup = false;
                }

                CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                Total += long.Parse(DT.Rows[r]["Total"].ToString());

                G_CollectionAmount += double.Parse(DT.Rows[r]["CollectionAmount"].ToString());
                G_SourceTaxAmount += double.Parse(DT.Rows[r]["SourceTaxAmount"].ToString());
                G_InvoiceAmount += double.Parse(DT.Rows[r]["InvoiceAmount"].ToString());
                G_RevStamp += double.Parse(DT.Rows[r]["RevStamp"].ToString());
                G_Total += long.Parse(DT.Rows[r]["Total"].ToString());

                s.Append("<tr>");

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , SL++));

                s.Append(string.Format("<td>{0}</td>"
                    , DT.Rows[r]["BranchName"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["RoutingNo"]));

                s.Append(string.Format("<td class='center'>{0}</td>"
                    , DT.Rows[r]["Total"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["CollectionAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["SourceTaxAmount"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["RevStamp"]));

                s.Append(string.Format("<td class='right'>{0:N2}</td>"
                    , DT.Rows[r]["InvoiceAmount"]));
                

                s.Append("</tr>");

                TotalRow = string.Format("<tr class='bold'><td class='right' colspan='3'>Zone / ZMO: ({0}) Total:</td><td class='center'>{5:N0}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",

                            DT.Rows[r]["Zone"],
                            CollectionAmount,
                            SourceTaxAmount,                            
                            RevStamp,
                            InvoiceAmount,
                            Total
                        );
                if (NewGroup)
                {

                }
            }
            s.Append(TotalRow);

            G_TotalRow = string.Format("<tr class='bold footer-row'><td class='right' colspan='3'>{0:N0} Total:</td><td class='center'>{5}</td><td class='right'>{1:N2}</td><td class='right'>{2:N2}</td><td class='right'>{3:N2}</td><td class='right'>{4:N2}</td></tr>",
                            "Grand",
                            G_CollectionAmount,
                            G_SourceTaxAmount,                            
                            G_RevStamp,
                            G_InvoiceAmount,
                            G_Total
                        );

            s.Append(G_TotalRow);

            s.Append("</table>");
            s.Append(string.Format("<div style='font-size:80%;margin-top:5px'>Report generated on: {0:dddd, dd MMM, yyyy} at {0:h:mm:ss tt}</div>", DateTime.Now));
            s.Append(Signature);
            litReport.Text = s.ToString();
        }
        lblStatus.Text = string.Format("Total: {0}", DT.Rows.Count);
    }

    

    protected void dboReportType_SelectedIndexChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void cboZones_SelectedIndexChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void cboBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void dblStatus_SelectedIndexChanged(object sender, EventArgs e)
    {
        RefreshReport();
    }

    protected void dboType_SelectedIndexChanged(object sender, EventArgs e)
    {
        foreach (ListItem LI in cboZones.Items)
        {
            LI.Selected = false;            
        }

        cboZones.Items.Clear();
        cboZones.Items.Add(new ListItem("All Zones", "-1"));

        //cboZones.DataBind();
        RefreshReport();
    }

    private void RefreshReport()
    {
        PanelPrint.Visible = true;
        litReport.Text = "";
        lblStatus.Text = "";

        litReportTitle.Text = "";
        litReportTitle2.Text = "";
        litReport.Text = "<h2 class='center Panel1'>No Data Found.</h2>";

        string ReportType = dboReportType.SelectedItem.Value;
        if (dblStatus.SelectedItem.Value == "9")
        {
            CANCELED = "red-back";
        }

        if (dboType.SelectedItem.Value == "false")
        {
            switch (ReportType)
            {
                case "1":
                    BranchWiseDetailsReport();
                    break;
                case "2":
                    ZoneWiseDetailsReport();
                    break;
                case "3":
                    BranchWiseSummaryReport();
                    break;
                case "4":
                    ZoneWiseSummaryReport();
                    break;
                case "5":
                    DateWiseSummaryReport();
                    break;
                case "6":
                    ZoneWiseSummary2Report();
                    break;
                default:
                    PanelPrint.Visible = false;
                    break;
            }
        }
        else
        {
            switch (ReportType)
            {
                case "1":
                    BranchWiseDetailsReport_Metered();
                    break;
                case "2":
                    ZoneWiseDetailsReport_Metered();
                    break;
                case "3":
                    BranchWiseSummaryReport_Metered();
                    break;
                case "4":
                    ZoneWiseSummaryReport_Metered();
                    break;
                case "5":
                    DateWiseSummaryReport_Metered();
                    break;
                case "6":
                    ZoneWiseSummary2Report_Metered();
                    break;
                default:
                    PanelPrint.Visible = false;
                    break;
            }
        }

        if (dblStatus.SelectedItem.Value == "9")
        {
            litReportTitle.Text += " <span class='bold red'>(CANCELED)</span>";
        }
    }
}