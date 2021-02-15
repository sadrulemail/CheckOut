using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using OfficeOpenXml;
using System.IO;
using System.Net;

public partial class REB_Browse : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //GridView1.DataBind();

        if (GridView1.Rows.Count > 0)
        {
            btnDownload.Visible = true;
        }
    }
    protected void btnDownload_Click(object sender, EventArgs e)
    {
        try
        {

            string connString = System.Configuration.ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(connString);
            conn.Open();
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = "s_REB_download_Batch";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("EmpID", Session["USERNAME"].ToString());

            SqlParameter DownloadBatch = new SqlParameter();
            DownloadBatch.DbType = DbType.Int64;
            DownloadBatch.Value = 0;
            DownloadBatch.Direction = ParameterDirection.InputOutput;
            DownloadBatch.ParameterName = "@DownloadBatch";
            cmd.Parameters.Add(DownloadBatch);

            SqlParameter keycode = new SqlParameter();
            keycode.DbType = DbType.String;
            keycode.Size = 100;
            keycode.Direction = ParameterDirection.InputOutput;
            keycode.ParameterName = "@keycode";
            cmd.Parameters.Add(keycode);

            cmd.Connection = conn;

            cmd.ExecuteNonQuery();

            string batch = DownloadBatch.Value.ToString();
            string key = keycode.Value.ToString();

            if (batch == "0")
                AKControl.ClientMsg("Error Occured");
            else
            {
                litDownlaod.Text = string.Format("Download: <a target='_blank' href='REB_Download_Batch.aspx?Batch={0}&keycode={1}&type=csv'><b>Batch: {0}</b></a>", batch, key);
                btnDownload.Visible = false;
                GridView1.DataBind();
            }

        }
        catch (Exception ex)
        {
            litDownlaod.Text = ex.Message;
        }

       


    }
}