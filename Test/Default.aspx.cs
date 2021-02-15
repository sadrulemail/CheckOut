using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //string s="ashik.email@gmail.com,tzzoha@gmail.com;mrmetun@gmail.com easin15@gmail.com";
        //string[] ss = null;
        //ss = s.Split(new char[] { ',', ';', ' ' });

        //foreach (string _s in ss)
        //{
        //    Label1.Text += _s + "<br>";
        //}
        string innerXml = @"<detail><WCFFaultExcepcion><ErrorId>b7e9d385-9118-4297-baca-db9ab00f3856</ErrorId><Message>Índice fuera de los límites de la matriz.</Message></WCFFaultExcepcion></detail>";
        XmlDocument doc = new XmlDocument();
        doc.LoadXml(innerXml);

        XmlNodeList xnList = doc.SelectNodes("/detail/WCFFaultExcepcion");
        foreach (XmlNode xn in xnList)
        {
            string firstName = xn["ErrorId"].InnerText;
            string lastName = xn["Message"].InnerText;
          //  Console.WriteLine("Name: {0} {1}", firstName, lastName);
        }

        string xml = @" < responseData >   < statusCode > 0000 </ statusCode >   < statusText > Success </ statusText >   </ responseData > ";
    }
}