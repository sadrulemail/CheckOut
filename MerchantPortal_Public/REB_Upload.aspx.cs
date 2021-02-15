using System;
using System.IO;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Ionic.Zip;

public partial class REB_Upload : System.Web.UI.Page
{
    //string UploadTempFile;
    //string UploadTempFolder;
    string randomNumber;

    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.isRole("ADMIN", "REB_UPLOAD");

       
        if (!IsPostBack)
        {
            Random R = new Random(DateTime.Now.Millisecond +
                                 DateTime.Now.Second * 1000 +
                                 DateTime.Now.Minute * 60000 +
                                 DateTime.Now.Hour * 3600000);

            randomNumber = R.Next().ToString();

            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DateTime.Now.Date);
            //GridView2.DataBind();

            if (!Directory.Exists(Server.MapPath("Upload")))
            {
                Directory.CreateDirectory(Server.MapPath("Upload"));
            }
            //UploadTempFile = Server.MapPath("Upload/" + Session.SessionID.ToString() + randomNumber);
            //UploadTempFolder = Path.Combine(Path.GetDirectoryName(UploadTempFile), Session.SessionID.ToString() + randomNumber);

            UploadTempFile.Value = Server.MapPath("Upload/" + Session.SessionID.ToString() + randomNumber);
            UploadTempFolder.Value = Path.Combine(Path.GetDirectoryName(UploadTempFile.Value), Session.SessionID.ToString() + randomNumber);

            Panel2.Visible = false;
            //Panel3.Visible = false;
            CleanDatabase();
            try
            {
                //Directory.Delete(UploadTempFolder, true);
            }
            catch (Exception) { }
        }
        Session["SessionID"] = Session.SessionID;

        Title = "Upload REB Data";
    }

    protected void cmdPreviousDay_Click(object sender, EventArgs e)
    {
        try
        {
            DateTime DT = DateTime.Parse(txtDateFrom.Text);
            txtDateFrom.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            txtDateTo.Text = string.Format("{0:dd/MM/yyyy}", DT.AddDays(-1));
            //RefreshData();
            GridView2.DataBind();
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
            GridView2.DataBind();
        }
        catch (Exception) { }
    }

    private void CleanDatabase()
    {
        RunNonQuery("delete from Temp_REB where SessionID='" + Session.SessionID + "'", "PaymentsDBConnectionString", CommandType.Text);
    }

    protected void FileUpload1_UploadedComplete(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
    {
        Session["FILENAME"] = FileUpload1.FileName.Trim();
        //lblUploadStatus.Text = "Uploaded File: " + FileUpload1.FileName;
        

        if (FileUpload1.FileName.ToUpper().EndsWith("ZIP"))
            UploadTempFile.Value += ".zip";
        if (FileUpload1.FileName.ToUpper().EndsWith("CSV"))
            UploadTempFile.Value += ".csv";

        //if (File.Exists(UploadTempFile))
        //    File.Delete(UploadTempFile);

        FileUpload1.SaveAs(Path.Combine(UploadTempFolder.Value, UploadTempFile.Value));

        File.SetCreationTime(UploadTempFile.Value, DateTime.Now);

        FileInfo FI = new FileInfo(UploadTempFile.Value);

         try
        {
            if (FI.Extension.ToString().ToLower() == ".zip")
            {
                try
                {
                    Directory.Delete(UploadTempFile.Value, true);
                }
                catch (Exception) { }
                ZipFile zf = new ZipFile(UploadTempFile.Value);
                zf.ExtractAll(UploadTempFolder.Value, ExtractExistingFileAction.OverwriteSilently);
                zf.Dispose();
            }
            else
            {
                //FI.CopyTo(UploadTempFolder);
                if (!Directory.Exists(UploadTempFolder.Value)) Directory.CreateDirectory(UploadTempFolder.Value);
                FI.MoveTo(UploadTempFolder.Value + "\\" + FI.Name);
            }
        }
        catch (Exception) {
            //FileUpload1_UploadedFileError(sender, new AjaxControlToolkit.AsyncFileUploadEventArgs(AjaxControlToolkit.AsyncFileUploadState.Failed, "Invalid File", "", ""));
        }
        //File.Delete(UploadTempFile);
    }

    private void DeleteOldUploadedFiles()
    {
        string[] Files = Directory.GetFiles(Server.MapPath("Upload/"));
        foreach (string FileName in Files)
            if (File.GetCreationTime(FileName) < DateTime.Now.AddHours(-1) || FileName.Contains(Session.SessionID))
                File.Delete(FileName);
        if (Directory.Exists(Server.MapPath("Upload/")))
        {
            //Directory.Delete(Server.MapPath("Upload/"), true);
            foreach (string directory in Directory.GetDirectories(Server.MapPath("Upload/")))
            {
                Directory.Delete(directory,true);
            }
        }
    }

    protected void cmdCheck_Click(object sender, EventArgs e)
    {
        Panel1.Visible = false;
        CleanDatabase();        
        
        DirectoryInfo DI = new DirectoryInfo(UploadTempFolder.Value);
        FileInfo[] Files = DI.GetFiles("*.csv", SearchOption.AllDirectories);

        foreach (FileInfo FI in Files)
        {
            //ParseFile(FI.FullName, int.Parse(txtAccNoColumn.Text.Trim()), int.Parse(txtCardNoColumn.Text.Trim()), int.Parse(txtItclID.Text.Trim()), int.Parse(txtCustomerNameID.Text.Trim()), int.Parse(txtStatus.Text.Trim()), int.Parse(txtEmail.Text.Trim()));
            ParseFileFinal(FI.FullName);
            File.Delete(FI.FullName);
        }
        DeleteOldUploadedFiles();
    }

    

    private void ParseFileFinal(string FileName)
    {
        DataTable REBData = new DataTable();
        REBData.Columns.Add("SL", typeof(int));
        REBData.Columns.Add("SMSBillNo", typeof(string));
        REBData.Columns.Add("Book", typeof(string));
        REBData.Columns.Add("SMSAccountNo", typeof(string));
        REBData.Columns.Add("Month", typeof(int));
        REBData.Columns.Add("Year", typeof(int));
        REBData.Columns.Add("BilledDate", typeof(DateTime));
        REBData.Columns.Add("PayDate", typeof(DateTime));
        REBData.Columns.Add("Amount", typeof(decimal));
        REBData.Columns.Add("PayDateWithLPC", typeof(DateTime));
        REBData.Columns.Add("AmountWithLPC", typeof(decimal));
        REBData.Columns.Add("SessionID", typeof(string));

        //DataSetUpload.TempImportDataTable CardData = new DataSetUpload.TempImportDataTable();


        string[] lines = System.IO.File.ReadAllLines(FileName);

        ////string[] filter_line = null;


        foreach (string line in lines)
        {
            var cols = line.Split(',');
            int dt;
            if (cols.Length > 5)
            {
                if (int.TryParse(cols[0].Trim().ToString(), out dt))
                {
                    //filter_line.add
                    var colss = line.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
                    REBData.Rows.Add(colss[0].ToString().Trim(), colss[1].ToString().Trim(), colss[2].ToString().Trim(),
                        colss[3].ToString().Trim(), colss[4].ToString().Trim(), colss[5].ToString().Trim(), colss[6].ToString().Trim(),
                        colss[7].ToString().Trim(),colss[8].ToString().Trim(),colss[9].ToString().Trim(),colss[10].ToString().Trim(),
                        Session.SessionID.ToString());
                }
            }
        }


        string connString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

        //// open the destination data

        try
        {
            using (SqlConnection destinationConnection = new SqlConnection(connString))
            {
                // open the connection
                destinationConnection.Open();
                using (SqlBulkCopy bulkCopy =
                     new SqlBulkCopy(destinationConnection.ConnectionString,
                            SqlBulkCopyOptions.TableLock))
                {
                    bulkCopy.DestinationTableName = "Temp_REB";
                    bulkCopy.WriteToServer(REBData);
                }
            }
        }
        catch (Exception ex)
        {
            lblError.Text += (ex.Message);
            return;
        }

        Panel2.Visible = true;
        GridView1.DataBind();

        string TotalReocrd = REBData.Rows.Count.ToString();
        decimal amount = 0;
        decimal amountwithLPC = 0;

        foreach (DataRow dr in REBData.Rows)
        {
            amount =amount+ Convert.ToDecimal(dr["Amount"].ToString());
            amountwithLPC = amountwithLPC + Convert.ToDecimal(dr["AmountWithLPC"].ToString());
        }

        lblTotalRecord.Text ="Total Record: "+ "<b>"+TotalReocrd+"</b>";
        lblAmount.Text = "Total Amount: " + "<b>" + amount.ToString() + "</b>";
        lblAmountWithLPC.Text = "Total Amount With LPC: " + "<b>" + amountwithLPC.ToString() + "</b>";
        
        DataSet ds = new DataSet();

        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = "s_REB_Check_UploadData";
            cmd.Parameters.AddWithValue("SessionID", Session.SessionID.ToString());
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = conn;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            da.Fill(ds);
        }

        if (ds.Tables[0].Rows.Count > 0)
        {
            chkOverride.Visible = true;
            lblDuplicateCount.Text = "Total Duplicate Bill: " + "<b>" + ds.Tables[0].Rows.Count.ToString() + "</b>"; 
            lblDuplicateCount.Visible = true;
        }
        else
        {
            chkOverride.Visible = false;
            lblDuplicateCount.Visible = false;
        }

        if (ds.Tables[1].Rows.Count > 0)
        {
            chkPaid.Visible = true;
            chkPaid.Checked = true;
            lblPaidCount.Text = "Total Paid Bill: " + "<b>" + ds.Tables[1].Rows.Count.ToString() + "</b>";
            lblPaidCount.Visible = true;
        }
        else
        {
            chkPaid.Checked = false;
            chkPaid.Visible = false;
            lblPaidCount.Visible = false;
        }


    }

    protected void tabContainer_ActiveTabChanged(object sender, EventArgs e)
    {
        if (tabContainer.ActiveTabIndex == 0)
            GridView1.DataBind();
        else if (tabContainer.ActiveTabIndex == 1)
        {
        }
           // GridView1.DataBind();
    }

    private void RunNonQuery(string Query, string ConnectionStringsName, CommandType commandType)
    {
        string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings[ConnectionStringsName].ConnectionString;
        SqlConnection oConn = new SqlConnection(oConnString);        

        SqlCommand oCommand = new SqlCommand(Query, oConn);
        oCommand.CommandType = commandType;
        if (oConn.State == ConnectionState.Closed)
            oConn.Open();        
        oCommand.ExecuteNonQuery();
    }

    protected void cmdUpdate_Click(object sender, EventArgs e)
    {
        int Override=0;
        if(chkOverride.Checked)
            Override = 1;
        else
            Override = 0;

        RunNonQuery("EXEC s_REB_Insert '" + Session.SessionID + "','" + Session["USERNAME"].ToString() + "','" + Override + "'", "PaymentsDBConnectionString", CommandType.Text);
        Panel2.Visible = false;
        //Panel3.Visible = false;
        TrustControl1.ClientMsg("Data Saved Successfully.");
        GridView2.DataBind();
        CleanDatabase();
    }

    protected void FileUpload1_UploadedFileError(object sender, AjaxControlToolkit.AsyncFileUploadEventArgs e)
    {

    }

    
   

    protected void ObjectDataSource1_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
    {
        
    }



    protected void cmdUpdate0_Click(object sender, EventArgs e)
    {
        //RunNonQuery("EXEC sp_Update_CardNumber_from_TempImport_Flat_File '" + Session.SessionID + "','" + Session["EMPID"].ToString() + "'", "PaymentsDBConnectionString", CommandType.Text);
        //Panel2.Visible = false;
        //Panel3.Visible = false;
        //TrustControl1.ClientMsg("Updated in Old Card Database");
        //CleanDatabase();
        //GridView2.DataBind();
    }

    protected void cmdClearData_Click(object sender, EventArgs e)
    {
        CleanDatabase();
    }
}