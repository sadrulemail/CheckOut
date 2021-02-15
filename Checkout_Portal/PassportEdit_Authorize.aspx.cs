using OfficeOpenXml;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class PassportEdit_Authorize : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        if (!IsPostBack)
        {
            txtFilter.Text = string.Format("{0}", Request.QueryString["batchid"]);

            this.Title = "Follow Up Authorize Pending";
        }
    }

    protected void cboBranch_DataBound(object sender, EventArgs e)
    {
        try
        {
            //if (!TrustControl1.isRole("ADMIN"))
            //{
            foreach (ListItem i in cboBranch.Items)
                i.Selected = false;


            if (Session["BRANCHID"].ToString() != "1")
            {
                foreach (ListItem ii in cboBranch.Items)
                {
                    if (ii.Value == Session["BRANCHID"].ToString())
                    {
                        ii.Selected = true;
                        cboBranch.Enabled = false;
                    }
                    else
                    {
                        ii.Enabled = false;
                    }
                }
            }
            else if (Session["BRANCHID"].ToString() == "1")
            {
                if (TrustControl1.isRole("ADMIN"))
                {
                    foreach (ListItem ii in cboBranch.Items)
                    {
                        if (ii.Value == Session["BRANCHID"].ToString())
                        {
                            ii.Selected = true;
                            cboBranch.Enabled = true;
                        }
                    }
                }

                else
                {
                    foreach (ListItem ii in cboBranch.Items)
                    {
                        if (ii.Value == Session["BRANCHID"].ToString())
                        {
                            ii.Selected = true;
                            cboBranch.Enabled = false;
                        }
                    }

                }

            }
            //}
        }
        catch(Exception ex)
        { }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //Response.Redirect("BatchNoPrint.aspx?batchid=" + txtBatchNO.Text.Trim(), true);
    }


    protected void Gdv_Browse_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string BgColor = DataBinder.Eval(e.Row.DataItem, "BgColor").ToString();
                e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml(BgColor);
            }
        }
        catch (Exception ex)
        {
            //ErrorLabel.Text = ex.Message;
        }
    }

    protected void Sql_Browse_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblTotal.Text = string.Format("Total: <b>{0:N0}</b>", e.AffectedRows);
    }

    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
           if (e.CommandName.ToUpper() == "AUTHORIZE")
        {
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Passport_Payment_Authorization";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = e.CommandArgument;
                    cmd.Parameters.Add("@AuthorizeBy", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                    cmd.Parameters.Add("@AuthorizeByBranchID", System.Data.SqlDbType.Int).Value = Session["BRANCHID"].ToString();

                    SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
                    SQL_Msg.Direction = ParameterDirection.InputOutput;
                    SQL_Msg.Value = Msg;
                    cmd.Parameters.Add(SQL_Msg);

                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();

                    Msg = string.Format("{0}", SQL_Msg.Value);
                }
            }

            GridView1.DataBind();
            TrustControl1.ClientMsg(Msg);
        }
    }

    protected void ddlBranchID_SelectedIndexChanged(object sender, EventArgs e)
    {
        //ddlDeptID.DataBind();
    }
}