using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ServiceCube
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
                  
            //if(!IsPostBack)
            //{
            //    GetData();
            //}

            this.Title = "Checkout Payment Log";
            this.Title = UserControl1.getValueOfKey("AppName");
        }

    

     

   
    }
}