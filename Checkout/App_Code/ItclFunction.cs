using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml;

/// <summary>
/// Summary description for ItclFunction
/// </summary>
public class ItclFunction
{
    public ItclFunction()
    {
        //
        // TODO: Add constructor logic here
        //
    }
    public String msg_get(String response)
    {
        int startIndex = response.IndexOf("<TKKPG>", StringComparison.Ordinal);
        int endIndex = response.IndexOf("</TKKPG>", StringComparison.Ordinal);
        String substring = response.Substring(startIndex);
        return substring;
    }

    public List<string> xml_to_list(String msg)
    {
      

        List<string> _objList = new List<string>();
        try
        {
            XmlDocument xmlDocument = new XmlDocument();
            xmlDocument.LoadXml(msg);
            XmlNodeReader xmlNodeReader = new XmlNodeReader(xmlDocument);
            DataSet ds = new DataSet();
            ds.ReadXml(xmlNodeReader);
            DataTable dt = new DataTable();
            dt = ds.Tables[1];
            foreach (DataRow dr in dt.Rows)
            {
                _objList.Add(dr["OrderID"].ToString());
                _objList.Add(dr["SessionID"].ToString());
                _objList.Add(dr["URL"].ToString());

            }

        }
        catch(Exception ex)
        {
            Common.WriteLog("", msg);
            //return "Error Accessing ITCL Card Server, please try later.";
        }
        return _objList;
    }
}