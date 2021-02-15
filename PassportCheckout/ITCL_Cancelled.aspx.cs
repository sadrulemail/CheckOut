using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

public partial class ITCL_Cancelled : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string OrderID = "";
        string TransactionType = "";
        string PAN = "";
        decimal Amount = 0;
        string Currency = "";
        string Responsecode = "";
        string Responsedescription = "";
        string OrderStatus = "";
        string ApprovalCode = "";
        string Name = "";
        string OrderDescription = "";
        string AcqFee = "";


        try
        {
            int startPoint;
            int endPoint;

            string xmlmsg = (string.Format("{0}",
                Request.Form["xmlmsg"])).ToLower();

            try
            {
                startPoint = xmlmsg.IndexOf("<orderid>") + 9;
                endPoint = xmlmsg.IndexOf("</orderid>");
                OrderID = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<transactiontype>") + 17;
                endPoint = xmlmsg.IndexOf("</transactiontype>");
                TransactionType = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<pan>") + 5;
                endPoint = xmlmsg.IndexOf("</pan>");
                PAN = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<purchaseamount>") + 16;
                endPoint = xmlmsg.IndexOf("</purchaseamount>");
                Amount = decimal.Parse(xmlmsg.Substring(startPoint, (endPoint - startPoint))) / 100;
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<currency>") + 10;
                endPoint = xmlmsg.IndexOf("</currency>");
                Currency = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<responsecode>") + 14;
                endPoint = xmlmsg.IndexOf("</responsecode>");
                Responsecode = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<responsedescription>") + 21;
                endPoint = xmlmsg.IndexOf("</responsedescription>");
                Responsedescription = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<orderstatus>") + 13;
                endPoint = xmlmsg.IndexOf("</orderstatus>");
                OrderStatus = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<approvalcode>") + 14;
                endPoint = xmlmsg.IndexOf("</approvalcode>");
                ApprovalCode = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<orderdescription>") + 18;
                endPoint = xmlmsg.IndexOf("</orderdescription>");
                OrderDescription = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<name>") + 6;
                endPoint = xmlmsg.IndexOf("</name>");
                Name = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }

            try
            {
                startPoint = xmlmsg.IndexOf("<acqfee>") + 8;
                endPoint = xmlmsg.IndexOf("</acqfee>");
                AcqFee = xmlmsg.Substring(startPoint, (endPoint - startPoint));
            }
            catch (Exception) { }


            //Label1.Text = "Order ID: " + OrderID;
            //Label1.Text += "<br>" + "Transaction Type: " + TransactionType;
            Label1.Text += string.Format("Amount: {0:N2}", Amount);
            Label1.Text += "<br>" + "Card: " + PAN;
            Label1.Text += "<br>" + "Name: " + Name;
            //Label1.Text += "<br>" + "Currency: " + Currency;
            //Label1.Text += "<br>" + "Responsecode: " + Responsecode;
            Label1.Text += "<br>" + "Status: " + OrderStatus;
            Label1.Text += "<br>" + "Description: " + Responsedescription;
            Label1.Text += "<br>" + "Order Description: " + OrderDescription;

            
        }
        catch (Exception ex) 
        { 
            Label1.Text = "Error: " + ex.Message; 
        }

        SqlConnection.ClearAllPools();

        try
        {
            using (SqlConnection conn = new SqlConnection())
            {
                string Query = "s_ITCL_Response_Insert";
                conn.ConnectionString = ConfigurationManager.ConnectionStrings["PaymentsDBConnectionString"].ConnectionString;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = Query;
                    cmd.CommandType = System.Data.CommandType.StoredProcedure;

                    cmd.Parameters.Add("@OrderID", System.Data.SqlDbType.VarChar).Value = OrderID;
                    cmd.Parameters.Add("@TransactionType", System.Data.SqlDbType.VarChar).Value = TransactionType;
                    cmd.Parameters.Add("@Currency", System.Data.SqlDbType.VarChar).Value = Currency;
                    cmd.Parameters.Add("@Amount", System.Data.SqlDbType.Decimal).Value = Amount;
                    cmd.Parameters.Add("@ResponseCode", System.Data.SqlDbType.VarChar).Value = Responsecode;
                    cmd.Parameters.Add("@ResponseDescription", System.Data.SqlDbType.VarChar).Value = Responsedescription;
                    cmd.Parameters.Add("@OrderStatus", System.Data.SqlDbType.VarChar).Value = OrderStatus;
                    cmd.Parameters.Add("@ApprovalCode", System.Data.SqlDbType.VarChar).Value = ApprovalCode;
                    cmd.Parameters.Add("@PAN", System.Data.SqlDbType.VarChar).Value = PAN;
                    cmd.Parameters.Add("@AcqFee", System.Data.SqlDbType.VarChar).Value = AcqFee;
                    cmd.Parameters.Add("@OrderDescription", System.Data.SqlDbType.VarChar).Value = OrderDescription;
                    cmd.Parameters.Add("@Name", System.Data.SqlDbType.VarChar).Value = Name;

                    cmd.Connection = conn;
                    conn.Open();

                    if (conn.State == System.Data.ConnectionState.Closed) conn.Open();

                    cmd.ExecuteNonQuery();
                }
            }
        }
        catch (Exception) { }
    }
}