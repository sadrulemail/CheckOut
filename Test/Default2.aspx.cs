using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;

public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //HttpWebRequest req = (HttpWebRequest)WebRequest.Create("http://www.ashik.info");

        //using (HttpWebResponse response = (HttpWebResponse)req.GetResponse())
        //{
        //    using (Stream resStream = response.GetResponseStream())
        //    {
        //        string requestUrlQuery = string.Join(string.Empty, response.ResponseUri.AbsoluteUri.Split('?').Skip(1));
                
        //            var sr = new StreamReader(response.GetResponseStream());
        //            string responseText = sr.ReadToEnd();
        //            Label1.Text = responseText;
        //            return;
                
        //    }
        //}
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        Label1.Text = DecodeFrom64(txt1.Text);
    }

    static public string DecodeFrom64(string encodedData)
    {
        byte[] encodedDataAsBytes
            = System.Convert.FromBase64String(encodedData);
        string returnValue =
           System.Text.ASCIIEncoding.ASCII.GetString(encodedDataAsBytes);
        return returnValue;
    }
}