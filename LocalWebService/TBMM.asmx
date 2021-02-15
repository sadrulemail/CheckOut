<%@ WebService Language="C#" Class="TBMM_Info" %>

using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;

/// <summary>
/// Summary description for TBMM
/// </summary>
[WebService(Namespace = "https://ibanking.tblbd.com/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class TBMM_Info : System.Web.Services.WebService
{
    public TBMM_Info()
    {
        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }


    [WebMethod]
    public List<TBMMUserInfo> UserInfo(string UserNumbers, string KeyCode)
    {
        List<TBMMUserInfo> obj = new List<TBMMUserInfo>();

        if (KeyCode != getValueOfKey("TBMM_KeyCode"))
        {
            TBMMUserInfo t = new TBMMUserInfo();
            t.Status = "401";   //Unauthorised"            
            obj.Add(t);
            return obj;
        }


        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMMUserInfo";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TBMM_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserNo", System.Data.SqlDbType.VarChar, -1).Value = UserNumbers;

                    cmd.Connection = conn;
                    conn.Open();

                    SqlDataReader oReader = cmd.ExecuteReader();

                    while (oReader.Read())
                    {
                        TBMMUserInfo t = new TBMMUserInfo();

                        t.UserNumber = string.Format("{0}", oReader["UserNumber"]);
                        t.UserName = string.Format("{0}", oReader["UserName"]);
                        t.Balance = double.Parse(oReader["UserCurrentBalance"].ToString());
                        t.UserRegistrationDate = DateTime.Parse(oReader["CreatedDate"].ToString());
                        t.AccountStatus = string.Format("{0}", oReader["UserAccountStatus"]);
                        t.AccountStatusCode = int.Parse(oReader["UserAccountStatusKey"].ToString());
                        t.AccountType = string.Format("{0}", oReader["AccountType"]);
                        t.AccountTypeCode = int.Parse(oReader["AccountTypeKey"].ToString());
                        t.Status = "0";

                        obj.Add(t);
                    }
                }
            }

            if (obj.Count == 0)
            {
                TBMMUserInfo t = new TBMMUserInfo();
                t.Status = "404";   //"Not Found"
                obj.Add(t);
            }
        }
        catch(Exception)
        {
            TBMMUserInfo t = new TBMMUserInfo();
            t.Status = "408";   //Request Timeout
            obj.Add(t);
        }

        return obj;
    }

    private string getValueOfKey(string KeyName)
    {
        try
        {
            return System.Configuration.ConfigurationSettings.AppSettings[KeyName].ToString();
        }
        catch (Exception) { return string.Empty; }
    }

    [WebMethod]
    public List<Agent> AgentInfo(string KeyCode)
    {
        List<Agent> obj = new List<Agent>();

        if (KeyCode != getValueOfKey("TBMM_KeyCode"))
        {
            Agent t = new Agent();
            t.Status = "401";   //Unauthorised"
            obj.Add(t);
            return obj;
        }


        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "SELECT * FROM [dbo].[Agent_Master] WITH (NOLOCK)";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TBMM_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;

                    cmd.Connection = conn;
                    conn.Open();

                    SqlDataReader oReader = cmd.ExecuteReader();

                    while (oReader.Read())
                    {
                        Agent t = new Agent();

                        t.AgentNumber = string.Format("{0}", oReader["AGENT_NUMBER"]);
                        t.ShopName = string.Format("{0}", oReader["SHOP_NAME"]);
                        t.BusinessOwner = string.Format("{0}", oReader["BUSINESSOWNERNAME"]);
                        t.AgentDivision = string.Format("{0}", oReader["AGENT_DIVISION"]);
                        t.AgentDistrict = string.Format("{0}", oReader["AGENT_DISTRICT"]);
                        t.AgentThana =string.Format("{0}", oReader["AGENT_THANA"]);
                        t.Dsr = string.Format("{0}", oReader["DSR"]);
                        //t.DsrDivision =string.Format("{0}", oReader["DSR_DIVISION"]);
                        //t.DsrDistrict =string.Format("{0}", oReader["DSR_DISTRICT"]);
                        //t.DsrThana =string.Format("{0}", oReader["DSR_THANA"]);
                        //t.Distributor =string.Format("{0}", oReader["DISTRIBUTOR"]);
                        //t.DistributorDivision =string.Format("{0}", oReader["DISTRIBUTOR_DIVISION"]);
                        //t.DistributorDistrict =string.Format("{0}", oReader["DISTRIBUTOR_District"]);
                        //t.DistributorThana = string.Format("{0}", oReader["DISTRIBUTOR_THANA"]);
                        t.AgentAddress = string.Format("{0}", oReader["Agent_Address"]);
                        t.Status = "0";

                        obj.Add(t);
                    }
                }
            }

            if (obj.Count == 0)
            {
                Agent t = new Agent();
                t.Status = "404";   //"Not Found"
                obj.Add(t);
            }
        }
        catch(Exception)
        {
            Agent t = new Agent();
            t.Status = "408";   //Request Timeout
            obj.Add(t);
        }

        return obj;
    }

    [WebMethod]
    public List<TBMMTransactionSummary> TransactionDetails(string UserNumbers, DateTime TransactionDate, string KeyCode)
    {
        List<TBMMTransactionSummary> obj = new List<TBMMTransactionSummary>();
        DataTable DT = new DataTable();

        if (KeyCode != getValueOfKey("TBMM_KeyCode"))
        {
            TBMMTransactionSummary t = new TBMMTransactionSummary();
            t.Status = "401";   //Unauthorised"
            obj.Add(t);
            return obj;
        }


        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMMTransactionDetaisForAListOfAccounts";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TBMM_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserNumber", System.Data.SqlDbType.VarChar, -1).Value = UserNumbers;
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.Date).Value = TransactionDate;

                    cmd.Connection = conn;
                    conn.Open();

                    //SqlDataReader oReader = cmd.ExecuteReader();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        DT.Load(dr);
                    }

                    //while (oReader.Read())
                    //{
                    //    TrnDetails t = new TrnDetails();

                    //    t.TransactionType = string.Format("{0}", oReader["TransactionType"]);
                    //    t.TotalNoOfDebitTransection = int.Parse(oReader["TotalNoOfDebitTransection"].ToString());
                    //    t.TotalDebitAmount = double.Parse(oReader["TotalDebitAmount"].ToString());
                    //    t.TotalNoOfCreditTransection = int.Parse(oReader["TotalNoOfCreditTransection"].ToString());
                    //    t.TotalCreditAmount = double.Parse(oReader["TotalCreditAmount"].ToString());
                    //    t.TotalCommissionAmount = double.Parse(oReader["TotalCommissionAmount"].ToString());

                    //    obj.Add(t);
                    //}
                }
            }


            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMMTransactionSummaryForAListOfAccounts";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TBMM_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserNumber", System.Data.SqlDbType.VarChar, -1).Value = UserNumbers;
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.Date).Value = TransactionDate;

                    cmd.Connection = conn;
                    conn.Open();

                    SqlDataReader oReader = cmd.ExecuteReader();

                    while (oReader.Read())
                    {
                        TBMMTransactionSummary t = new TBMMTransactionSummary();

                        t.UserNumber = string.Format("{0}", oReader["UserNumber"]);
                        t.UserName = string.Format("{0}", oReader["UserName"]);
                        t.CurrentBalance = double.Parse(oReader["UserCurrentBalance"].ToString());
                        t.TotalNoOfDebitTransaction = int.Parse(oReader["TotalNoOfDebitTransection"].ToString());
                        t.TotalDebitAmount = double.Parse(oReader["TotalDebitAmount"].ToString());
                        t.TotalNoOfCreditTransaction = int.Parse(oReader["TotalNoOfCreditTransection"].ToString());
                        t.TotalCreditAmount = double.Parse(oReader["TotalCreditAmount"].ToString());
                        t.TotalCommissionAmount = double.Parse(oReader["TotalCommissionAmount"].ToString());
                        t.Status = "0";
                        try
                        {
                            DataRow[] oRows = DT.Select("UserNumber='" + t.UserNumber + "'");
                            if (oRows.Length > 0)
                            {
                                TrnDetails tt = new TrnDetails();
                                List<TrnDetails> TrnDetails1 = new List<TrnDetails>();
                                foreach (DataRow oRow in oRows)
                                {
                                    tt.TransactionType = string.Format("{0}", oRow["TransactionType"]);
                                    tt.TotalNoOfDebitTransection = int.Parse(oRow["TotalNoOfDebitTransection"].ToString());
                                    tt.TotalDebitAmount = double.Parse(oRow["TotalDebitAmount"].ToString());
                                    tt.TotalNoOfCreditTransection = int.Parse(oRow["TotalNoOfCreditTransection"].ToString());
                                    tt.TotalCreditAmount = double.Parse(oRow["TotalCreditAmount"].ToString());
                                    tt.TotalCommissionAmount = double.Parse(oRow["TotalCommissionAmount"].ToString());
                                    TrnDetails1.Add(tt);
                                }
                                t.ListOfTrnDetails = TrnDetails1;
                            }
                        }
                        catch (Exception) { }
                        obj.Add(t);
                    }
                }
            }

            if (obj.Count == 0)
            {
                TBMMTransactionSummary t = new TBMMTransactionSummary();
                t.Status = "404";   //"Not Found"
                obj.Add(t);
            }
        }
        catch(Exception ex)
        {
            TBMMTransactionSummary t = new TBMMTransactionSummary();
            t.Status = "408";   //Request Timeout
            obj.Add(t);
        }

        return obj;
    }


    [WebMethod]
    public List<TBMMTransactionSummary> TransactionSummary(string UserNumbers, DateTime TransactionDate, string KeyCode)
    {
        List<TBMMTransactionSummary> obj = new List<TBMMTransactionSummary>();

        if (KeyCode != getValueOfKey("TBMM_KeyCode"))
        {
            TBMMTransactionSummary t = new TBMMTransactionSummary();
            t.Status = "401";   //Unauthorised"
            obj.Add(t);
            return obj;
        }


        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_TBMMTransactionSummaryForAListOfAccounts";
                conn.ConnectionString = System.Configuration.ConfigurationManager.ConnectionStrings["TBMM_ReportDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;
                    cmd.Parameters.Add("@UserNumber", System.Data.SqlDbType.VarChar, -1).Value = UserNumbers;
                    cmd.Parameters.Add("@Date", System.Data.SqlDbType.Date).Value = TransactionDate;

                    cmd.Connection = conn;
                    conn.Open();

                    SqlDataReader oReader = cmd.ExecuteReader();

                    while (oReader.Read())
                    {
                        TBMMTransactionSummary t = new TBMMTransactionSummary();

                        t.UserNumber = string.Format("{0}", oReader["UserNumber"]);
                        t.UserName = string.Format("{0}", oReader["UserName"]);
                        t.CurrentBalance = double.Parse(oReader["UserCurrentBalance"].ToString());
                        t.TotalNoOfDebitTransaction = int.Parse(oReader["TotalNoOfDebitTransection"].ToString());
                        t.TotalDebitAmount = double.Parse(oReader["TotalDebitAmount"].ToString());
                        t.TotalNoOfCreditTransaction = int.Parse(oReader["TotalNoOfCreditTransection"].ToString());
                        t.TotalCreditAmount = double.Parse(oReader["TotalCreditAmount"].ToString());
                        t.TotalCommissionAmount = double.Parse(oReader["TotalCommissionAmount"].ToString());
                        t.Status = "0";

                        obj.Add(t);
                    }
                }
            }

            if (obj.Count == 0)
            {
                TBMMTransactionSummary t = new TBMMTransactionSummary();
                t.Status = "404";   //"Not Found"
                obj.Add(t);
            }
        }
        catch(Exception)
        {
            TBMMTransactionSummary t = new TBMMTransactionSummary();
            t.Status = "408";   //Request Timeout
            obj.Add(t);
        }

        return obj;
    }
}


public struct TBMMUserInfo
{
    public string Status { set; get; }
    public string UserNumber { set; get; }
    public string UserName { set; get; }
    public double Balance { set; get; }
    public DateTime UserRegistrationDate { set; get; }
    public string AccountStatus { set; get; }
    public int AccountStatusCode { set; get; }
    public string AccountType { set; get; }
    public int AccountTypeCode { set; get; }
}

public struct TBMMTransactionSummary
{
    public string Status { set; get; }
    public string UserNumber { set; get; }
    public string UserName { set; get; }
    public double CurrentBalance { set; get; }
    public int TotalNoOfDebitTransaction { set; get; }
    public double TotalDebitAmount { set; get; }
    public int TotalNoOfCreditTransaction { set; get; }
    public double TotalCreditAmount { set; get; }
    public double TotalCommissionAmount { set; get; }
    public List<TrnDetails> ListOfTrnDetails { set; get; }
}

public struct TrnDetails
{
    public string TransactionType { set; get; }
    public int TotalNoOfDebitTransection { set; get; }
    public double TotalDebitAmount { set; get; }
    public int TotalNoOfCreditTransection { set; get; }
    public double TotalCreditAmount { set; get; }
    public double TotalCommissionAmount { set; get; }
}

public struct Agent
{
    public string Status { set; get; }
    public string AgentNumber { set; get; }
    public string ShopName { set; get; }
    public string BusinessOwner { set; get; }
    public string AgentDivision { set; get; }
    public string AgentDistrict { set; get; }
    public string AgentThana { set; get; }
    public string Dsr { set; get; }
    //public string DsrDivision { set; get; }
    //public string DsrDistrict { set; get; }
    //public string DsrThana { set; get; }
    //public string Distributor { set; get; }
    //public string DistributorDivision { set; get; }
    //public string DistributorDistrict { set; get; }
    //public string DistributorThana { set; get; }
    public string AgentAddress { set; get; }
}