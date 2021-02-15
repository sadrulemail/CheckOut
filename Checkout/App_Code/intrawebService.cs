using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

/// <summary>
/// Web Services for Trust intaweb Applications
/// 
/// Developed By:
/// Muhammad Ashik Iqbal
/// Software Development Team
/// 
/// Created on: 25 May 2009
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class intrawebService : WebService
{
    public intrawebService ()
    {
    }

    [WebMethod]
    public string[] GetRosterEmpList(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildItemsFromDatabase(prefixText, count, items);
        return items.ToArray();
    }

    [WebMethod]
    public string[] GetRoutingNumberList(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildRoutingNumbersDatabase(prefixText, count, items);
        return items.ToArray();
    }

    private static void BuildRoutingNumbersDatabase(string prefixText, int count, List<string> items)
    {
        SqlConnection.ClearAllPools();
        string Query = "EXEC sp_BEFTN_Codes_Search_Service '" + prefixText + "'";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read() && count-- > 0)
        {
            items.Add(oR["INFO"].ToString());
        }
        oR.Close();
    }
        
    private static void BuildItemsFromDatabase(string prefixText, int count, List<string> items)
    {
        SqlConnection.ClearAllPools();
        string Query = "EXEC usp_UserRole_Show " + getApplicationID() + ", '" + prefixText + "'";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read() && count-- > 0)
        {
            items.Add(oR["EMPINFO"].ToString());
        }
        oR.Close();
    }

    [WebMethod]
    public string[] GetAuthorityEmp(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildAuthorityEmpItemsFromDatabase(prefixText, count, items, getApplicationID());
        return items.ToArray();
    }
    private static void BuildAuthorityEmpItemsFromDatabase(string prefixText, int count, List<string> items, int AppID)
    {
        SqlConnection.ClearAllPools();
        string Query = "SELECT TOP " + count + " EMPID, EMPINFO FROM ViewAuthoEMP WHERE EMPINFO LIKE '%" + prefixText + "%' AND ApplicationID = '" + AppID + "' ORDER BY EMPNAME";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read())
        {
            items.Add(oR["EMPINFO"].ToString());
        }
        oR.Close();
    }
    private static int getApplicationID()
    {
        int ApplicationID = -1;
        try
        {
            ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());
        }
        catch (Exception)
        {
            return 0;
        }
        return ApplicationID;
    }

    [WebMethod(EnableSession = true)]
    public string Meetings_Add_Edit(int? ID, string Ref, string Date, string Subject, string Body, string KeyCode)
    {
        //System.Threading.Thread.Sleep(3000);
        string EMPID = "";
        string msg = "";
        string done = "0";
        string _ID = string.Format("{0}", ID);
        DateTime? MeetingDate = null;

        try
        {

            try
            {
                EMPID = Session["EMPID"].ToString();
            }
            catch (Exception)
            {
                msg = "Session Expired. Unable to Save.";
                goto retunLabel;
            }

            string Query = "s_Meetings_Add_Edit";
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TaskConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand(Query, oConn);
            oCommand.CommandType = CommandType.StoredProcedure;
            oCommand.Parameters.Add("@Ref", SqlDbType.VarChar).Value = HttpUtility.HtmlDecode(Ref);
            try
            {
                MeetingDate = DateTime.ParseExact(Date, "dd/MM/yyyy", null);
            }
            catch (Exception)
            { }
            oCommand.Parameters.Add("@Date", SqlDbType.Date).Value = MeetingDate;
            oCommand.Parameters.Add("@BranchID", SqlDbType.Int).Value = Session["BRANCHID"].ToString();
            oCommand.Parameters.Add("@DeptID", SqlDbType.Int).Value = Session["DEPTID"].ToString();
            oCommand.Parameters.Add("@Subject", SqlDbType.NVarChar).Value = HttpUtility.HtmlDecode(Subject);
            oCommand.Parameters.Add("@Body", SqlDbType.NVarChar).Value = HttpUtility.HtmlDecode(Body);
            oCommand.Parameters.Add("@EmpID", SqlDbType.VarChar).Value = EMPID;

            SqlParameter Param_ID = new SqlParameter("@ID", SqlDbType.Int);
            Param_ID.Direction = ParameterDirection.InputOutput;
            Param_ID.Value = (_ID == "" ? "0" : _ID);

            SqlParameter Done = new SqlParameter("@Done", SqlDbType.Bit);
            Done.Direction = ParameterDirection.InputOutput;
            Done.Value = 0;

            SqlParameter Msg = new SqlParameter("@Msg", SqlDbType.VarChar, 255);
            Msg.Direction = ParameterDirection.InputOutput;
            Msg.Value = " ";

            SqlParameter Param_KeyCode = new SqlParameter("@KeyCode", SqlDbType.VarChar, 32);
            Param_KeyCode.Direction = ParameterDirection.InputOutput;
            Param_KeyCode.Value = KeyCode;

            oCommand.Parameters.Add(Param_ID);
            oCommand.Parameters.Add(Done);
            oCommand.Parameters.Add(Msg);
            oCommand.Parameters.Add(Param_KeyCode);

            if (oConn.State == ConnectionState.Closed) oConn.Open();

            oCommand.ExecuteNonQuery();
            oConn.Close();

            _ID = string.Format("{0}", Param_ID.Value);

            if ((bool)(Done.Value))
                done = "1";
            else
                done = "0";

            msg = string.Format("{0}", Msg.Value);
            KeyCode = string.Format("{0}", Param_KeyCode.Value);
        }
        catch (Exception EX)
        {
            msg = "Error: " + EX.Message;
        }

        retunLabel:
        return (string.Format("{0},{1},{2},{3}", _ID, done, toJS(KeyCode), toJS(msg)));     //Do not change the text, using at client side.
    }

    protected string toJS(object value)
    {
        try
        {
            return HttpUtility.JavaScriptStringEncode(value.ToString().Replace("\n", ""));
        }
        catch (Exception)
        {
            return "";
        }
    }
}
