using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

public partial class Passport_Link : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        //int symbol;
        //symbol = 0;
        //while (true)
        //{
        //    if (symbol == 1)
        //        symbol = 0;
        //    else
        //        symbol = 1;
        //}


        TrustControl1.getUserRoles();
        

        if (!IsPostBack)
        {
            if (string.Format("{0}", Request.QueryString["refid"]) == "")
            {
                Title = "Passport Receipt";
                txtFilter.Focus();
                PanelVerificationReport.Visible = false;
                GridView1.Visible = false;
            }
            else
            {
                string RefID = string.Format("{0}", Request.QueryString["refid"]);
                txtFilter.Text = RefID;

                lblTitle.Text = "Passport Receipt #" + RefID;
                Title = RefID + " - Passport Receipt";
            }
            if (Session["ROLES"].ToString().Contains("ADMIN") && string.Format("{0}", Request.QueryString["refid"]) != "")
                //   if(Session["BRANCHID"].ToString()=="1" && Session["DEPTID"].ToString()=="7")
                PanelShowLog.Visible = true;
        }        
    }

    protected void SqlDataSource_Unlock_Log_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        PanelPassportUnlock.Visible = e.AffectedRows > 0;
    }

    //protected void cboBranch_DataBound(object sender, EventArgs e)
    //{
    //    foreach (ListItem i in dboBranch.Items)
    //        i.Selected = false;

    //    foreach (ListItem ii in dboBranch.Items)
    //    {
    //        if (ii.Value == Session["BRANCHID"].ToString())
    //            ii.Selected = true;
    //    }
    //    if (!TrustControl1.isRole("ADMIN"))
    //    {
    //        dboBranch.Enabled = false;
    //    }
    //}

    //protected void dboDept_DataBound(object sender, EventArgs e)
    //{
    //    foreach (ListItem i in dboDept.Items)
    //        i.Selected = false;

    //    foreach (ListItem ii in dboDept.Items)
    //    {
    //        if (ii.Value == Session["DEPTID"].ToString())
    //            ii.Selected = true;
    //    }
    //    if (!TrustControl1.isRole("ADMIN"))
    //    {
    //        dboDept.Enabled = false;
    //    }
    //}

    protected void GridViewTbmmResp_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToUpper() == "TBMMTRNCHK")
        {
            string _TrnNo = e.CommandArgument.ToString();
            //  double _Amount = double.Parse((e.CommandArgument.ToString().Split('|'))[1]);
            string RetVal = "Paid Amount: ";

            double TbmmAmount = TBMM_GetTransactionInfo(_TrnNo);
            RetVal += string.Format("{0:N2}", TbmmAmount);
            //if (TbmmAmount == _Amount) RetVal += "<br /><b>Amount Matched</b>";
            //else RetVal += "<br /><b>Amount Not Matched</b>";

            TrustControl1.ClientMsg(RetVal);
        }
    }
    protected void lnlAddNew_Click(object sender, EventArgs e)
    {
        txtRefIDAdd.Visible = true;
        txtRefIDAdd.Focus();
        lnlAddNew.Visible = false;
        cmdSearch.Visible = true;
        cmdCancel.Visible = true;
        DetailsView1.Visible = false;
        txtFilter.Enabled = false;
        txtRefIDAdd.Enabled = true;
    }
    protected void cmdCancel_Click(object sender, EventArgs e)
    {
        txtRefIDAdd.Text = "";
        txtRefIDAdd.Visible = false;
        lnlAddNew.Visible = true;
        cmdSearch.Visible = false;
        cmdCancel.Visible = false;
        DetailsView1.Visible = false;
        txtFilter.Enabled = true;
    }
    protected void cmdOK_Click(object sender, EventArgs e)
    {
        Response.Redirect("Passport_Link.aspx?refid=" + txtFilter.Text.Trim().ToUpper(), true);
        return;

        //txtRefIDAdd.Text = "";
        //txtRefIDAdd.Visible = false;
        //lnlAddNew.Visible = false;
        //cmdSearch.Visible = false;
        //cmdCancel.Visible = false;
        //DetailsView1.Visible = false;
        //GridView1.DataBind();
        //GridView2.DataBind();
        //txtFilter.Enabled = true;
        //GridView1.EditIndex = -1;   
    }
    protected void cmdSearch_Click(object sender, EventArgs e)
    {
        if (txtRefIDAdd.Text.Trim() == "")
        {
            TrustControl1.ClientMsg("Enter Ref No");
            DetailsView1.Visible = false;
            txtRefIDAdd.Text = "";
            txtRefIDAdd.Focus();
            return;
        }
        DetailsView1.DataBind();        
    }
    protected void SqlDataSource_Search_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
        bool NameMatched = (bool)e.Command.Parameters["@NameMatched"].Value;

        if (Msg.Trim() != "")
        {
            TrustControl1.ClientMsg(Msg);
            DetailsView1.Visible = false;
        }
        else
        {
            txtRefIDAdd.Enabled = false;
            DetailsView1.Visible = true;
            if (!NameMatched)
            {
                TrustControl1.ClientMsg("Name does not matched.");
                txtRefIDAdd.Enabled = true;
            }
        }        
    }

    protected void lnkCheckTrans_Click(object sender, EventArgs e)
    {


        //GridViewRow row = (GridViewRow)((LinkButton)sender).NamingContainer;
        //Label lblAcc = (Label)row.FindControl("lblAccountNo");
        //string Msg = "";
        //bool isVerified = false;
        //string Query = "[s_iBanking_Req_Delete]";

        //using (SqlConnection conn = new SqlConnection())
        //{
        //    conn.ConnectionString = System.Configuration.ConfigurationManager
        //                    .ConnectionStrings["Request_ProcessConnectionString"].ConnectionString;

        //    using (SqlCommand cmd = new SqlCommand(Query, conn))
        //    {

        //        cmd.CommandType = System.Data.CommandType.StoredProcedure;
        //        cmd.Parameters.Add("@ReqID", System.Data.SqlDbType.BigInt).Value = Request.QueryString["reqid"];
        //        cmd.Parameters.Add("@Accountno", System.Data.SqlDbType.VarChar).Value = lblAcc.Text.Trim();
        //        cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar).Value = Request.QueryString["email"];
        //        cmd.Parameters.Add("@KeyCode", System.Data.SqlDbType.VarChar).Value = Request.QueryString["keycode"];

        //        SqlParameter SQL_Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);

        //        SQL_Msg.Direction = ParameterDirection.InputOutput;
        //        SQL_Msg.Value = Msg;
        //        cmd.Parameters.Add(SQL_Msg);

        //        SqlParameter SQL_Done = new SqlParameter("@Done", SqlDbType.Bit);
        //        SQL_Done.Direction = ParameterDirection.InputOutput;
        //        SQL_Done.Value = isVerified;
        //        cmd.Parameters.Add(SQL_Done);

        //        cmd.Connection = conn;
        //        conn.Open();

        //        cmd.ExecuteNonQuery();

        //        isVerified = (bool)SQL_Done.Value;
        //        Msg = string.Format("{0}", SQL_Msg.Value);

        //    }

        //}
      
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string Used = string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "Used"));
            string StatusID = string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "Status"));
            lnlAddNew.Visible = (Used.ToUpper() != "TRUE" && StatusID == "1");

            if (Session["ROLES"].ToString().Contains("GUEST"))
            {
                //
                GridView1.Columns[0].Visible = false;
                GridView1.Columns[GridView1.Columns.Count - 1].Visible = false;
                // GridView1.Columns[GridView1.Columns.Count - 2].Visible = false;
                LinkButton lbCheckTrans = (LinkButton)e.Row.Cells[GridView1.Columns.Count - 2].FindControl("lnkCheckTrans");
                lbCheckTrans.Visible = false;
                DetailsView1.Visible = false;
            }
        }
        if (e.Row.RowType == DataControlRowType.EmptyDataRow)
        {
            lnlAddNew.Visible = false;
        }
       
    }
    protected void GridView1_DataBound(object sender, EventArgs e)
    {
        
    }

    protected void DetailsView1_ItemCommand(object sender, DetailsViewCommandEventArgs e)
    {
        if (e.CommandName == "ADDCHILD")
            SqlDataSource_Search.Insert();
    }
    protected void txtFilter_TextChanged(object sender, EventArgs e)
    {
        cmdOK_Click(sender, e);
    }
    protected void txtRefIDAdd_TextChanged(object sender, EventArgs e)
    {
        cmdSearch_Click(sender, e);
    }
    protected void SqlDataSource_Search_Inserted(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
        bool NameMatched = (bool)e.Command.Parameters["@NameMatched"].Value;
        bool Done = (bool)e.Command.Parameters["@Done"].Value;

        if (Done) cmdOK_Click(sender, e);       
        TrustControl1.ClientMsg(Msg);
    }

    protected void SqlDataSource2_Deleting(object sender, SqlDataSourceCommandEventArgs e)
    {

    }

    protected void SqlDataSource2_Deleted(object sender, SqlDataSourceStatusEventArgs e)
    {
        GridView1.DataBind();
        GridView1.EditIndex = -1;
        GridView2.DataBind();

        TrustControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
    }
    private double TBMM_GetTransactionInfo(string TrnID)
    {
        double RetVal = 0;
        string AccNo = TrustControl1.getValueOfKey("TBMM_DIP_ACC");
        try
        {
            ServiceReferencePassportCheckout.CheckMerchantTransactionSoapClient service = new ServiceReferencePassportCheckout.CheckMerchantTransactionSoapClient();
            string TBMM_Amount_S = service.GetTransactionInfo(TrnID, AccNo);
            RetVal = double.Parse(TBMM_Amount_S);
            
        }
        catch (Exception) { }

        return RetVal;
    }

    protected void GridView2_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToUpper() == "DELETE")
        {
            SqlDataSource2.DeleteParameters["RefID"].DefaultValue = e.CommandArgument.ToString().Split('_')[0];
            SqlDataSource2.DeleteParameters["ParentRefID"].DefaultValue = e.CommandArgument.ToString().Split('_')[1];
        }
        else if (e.CommandName.ToUpper() == "TRNCHK")
        {
            string _TrnNo = (e.CommandArgument.ToString().Split('|'))[0];
            double _Amount = double.Parse((e.CommandArgument.ToString().Split('|'))[1]);
            string RetVal = "Paid Amount: ";

            double TbmmAmount = TBMM_GetTransactionInfo(_TrnNo);
            RetVal += string.Format("{0:N2}", TbmmAmount);
            if (TbmmAmount == _Amount) RetVal += "<br /><b>Amount Matched</b>";
            else RetVal += "<br /><b>Amount Not Matched</b>";

            TrustControl1.ClientMsg(RetVal);
        }
    }
    protected void SqlDataSource1_Updated(object sender, SqlDataSourceStatusEventArgs e)
    {
        TrustControl1.ClientMsg(e.Command.Parameters["@Msg"].Value.ToString());
    }
    protected void SqlDataSource1_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        string Msg = string.Format("{0}", e.Command.Parameters["@Msg"].Value);
        if (Msg.Trim().Length > 0)
            TrustControl1.ClientMsg(Msg);
    }
    protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName.ToUpper() == "CANCELED" && TrustControl1.isRole("ADMIN"))
        {
            string Msg = "";

            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_Passport_Payment_Cancel";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = e.CommandArgument;
                    cmd.Parameters.Add("@CancelBy", System.Data.SqlDbType.VarChar).Value = Session["EMPID"].ToString();
                    GridViewRow row = (GridViewRow) ((LinkButton)e.CommandSource).NamingContainer;
                    string reason = ((TextBox)row.FindControl("txtPassportDeleteReason")).Text.ToString();
                    cmd.Parameters.Add("@CancelReason", System.Data.SqlDbType.VarChar).Value = reason;

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
        else if (e.CommandName.ToUpper() == "TRNCHK")
        {
            string _TrnNo = (e.CommandArgument.ToString().Split('|'))[0];
            double _Amount = double.Parse((e.CommandArgument.ToString().Split('|'))[1]);
            string RetVal = "Paid Amount: ";
            string Done = "";
            string RefID = (e.CommandArgument.ToString().Split('|'))[2];
            string Status = (e.CommandArgument.ToString().Split('|'))[3];

            double TbmmAmount = TBMM_GetTransactionInfo(_TrnNo);
            RetVal += string.Format("{0:N2}", TbmmAmount);
            if (TbmmAmount == _Amount)
            {
                if (Status == "0")
                {
                    using (SqlConnection conn = new SqlConnection())
                    {
                        string Query = "s_Passport_Payment_REQ_to_UNUSED";
                        conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.CommandText = Query;
                            cmd.CommandType = System.Data.CommandType.StoredProcedure;
                            cmd.Parameters.Add("@RefID", System.Data.SqlDbType.VarChar).Value = RefID;
                            //cmd.Parameters.Add("@Type", System.Data.SqlDbType.VarChar).Value = PaymentType;
                            cmd.Parameters.Add("@MobileMoneyStatus", System.Data.SqlDbType.VarChar).Value = "1";

                            SqlParameter sqlDone = new SqlParameter("@Done", SqlDbType.VarChar, 10);
                            sqlDone.Direction = ParameterDirection.InputOutput;
                            sqlDone.Value = "";
                            cmd.Parameters.Add(sqlDone);

                            cmd.Connection = conn;
                            conn.Open();

                            cmd.ExecuteNonQuery();
                            Done = string.Format("{0}", sqlDone.Value);
                        }
                    }
                    GridView1.DataBind();
                }
                RetVal += "<br /><b>Amount Matched.</b> " + Done;
            }
            else
            {
                RetVal += "<br /><b>Amount Not Matched</b>";
            }

            TrustControl1.ClientMsg(RetVal);
        }
        else if (e.CommandName.ToUpper() == "AUTHORIZE")
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
    protected void SqlDataSource_CheckPayment_Log_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        PanelVerificationReport.Visible = e.AffectedRows > 0;
    }

    protected void GridView2_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (Session["ROLES"].ToString().Contains("GUEST"))
            {
                //
                GridView2.Columns[0].Visible = false;
                GridView2.Columns[GridView2.Columns.Count - 1].Visible = false;
                LinkButton lbCheckTrans = (LinkButton)e.Row.Cells[GridView2.Columns.Count - 2].FindControl("lnkCheckTrans");
                lbCheckTrans.Visible = false;

            }
        }
    }

    protected void GridView_CheckPayment_Log_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.ForeColor = System.Drawing.ColorTranslator.FromHtml(DataBinder.Eval(e.Row.DataItem, "ForeColor").ToString());
        }
    }
}
