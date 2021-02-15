using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ServiceCube
{
    public partial class CrSummary : System.Web.UI.Page
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

        protected void SqlDataSource_Summary_Selected(object sender, SqlDataSourceStatusEventArgs e)
        {
        
            if (e.AffectedRows > 0)
            {

                DetailsView1.Fields[1].Visible= (Boolean)e.Command.Parameters["@TotalAmountVisible"].Value;
                DetailsView1.Fields[3].Visible = (Boolean)e.Command.Parameters["@VatVisible"].Value;
                DetailsView1.Fields[4].Visible = (Boolean)e.Command.Parameters["@ServiceChargeVisible"].Value;
            }
        }

            }
}