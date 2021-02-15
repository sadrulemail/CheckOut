using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class PostXMLData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btnPost_Click(object sender, EventArgs e)
    {
        string xml_data= "<? xml version = 1.0?><Prodocts><Product>Camera</Product></Prodocts>";
        System.Net.WebRequest req = null;
        System.Net.WebResponse rsp = null;
        try
        {
            string uri = "http://localhost:18288/Default2.aspx";
            req = System.Net.WebRequest.Create(uri);
            req.Method = "POST";
            req.ContentType = "text/xml";
            System.IO.StreamWriter writer =
        new System.IO.StreamWriter(req.GetRequestStream());
            writer.WriteLine(txtXML.Text);
            writer.Close();
            rsp = req.GetResponse();
        }
        catch
        {
            throw;
        }
        finally
        {
            if (req != null) req.GetRequestStream().Close();
            if (rsp != null) rsp.GetResponseStream().Close();
        }
    }
}