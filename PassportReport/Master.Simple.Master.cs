﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Master_Simple : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Copyright.Text = System.Configuration.ConfigurationSettings.AppSettings["Copyright"].ToString();
    }
}