using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Security.Cryptography.X509Certificates;
using System.Xml.Serialization;
using System.IO;
using System.Runtime.Serialization;
using System.Text;
using System.Runtime.Serialization.Formatters;
public partial class BVRSCardStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.Net.ServicePointManager.CertificatePolicy = new MyPolicy();

        
    }

     public void GetNIDCardStatus(string uid)
      {
         WebReferenceNID.getCardIssueCountServiceRequest sRequest= new WebReferenceNID.getCardIssueCountServiceRequest();
      //   sRequest.criteria.cardIssueTypeCode="1";
        //  sRequest.criteria.nid="5017116615981";
         sRequest.requestHeader.sessionUuid=uid;

          WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
          WebReferenceNID.getCardIssueCountServiceResponse sResponse= ps.getPartnerCardIssueCount(sRequest);
         

      }


     protected void Button1_Click(object sender, EventArgs e)
     {
         // for log in
         WebReferenceNID.loginServiceRequest lsr = new WebReferenceNID.loginServiceRequest();
         lsr.username = "tbl";
         lsr.password = "tbl069";//17.11.2015,02/12/2015
        
         //  loginRequest

         string sessionUuid = "";

         WebReferenceNID.loginServiceResponse lsResponse = new WebReferenceNID.loginServiceResponse();

         WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
         lsResponse = ps.login(lsr);

       //  ps.changePassword()

         if (lsResponse.operationResult.success)
         {
             sessionUuid = lsResponse.sessionUuid;
             Label2.Text = sessionUuid;
         }
         else
         {
             Label2.Text = lsResponse.operationResult.error.errorMessage + "Error code:" + lsResponse.operationResult.error.errorCode;
             //Error Log for save in DB
             //Label1.Text += lRes.@return.

             if(lsResponse.operationResult.error.errorCode==1019 && lsResponse.operationResult.error.errorMessage.Contains("Password has been expired"))
             {
                 ChangePasswordForExpired();
             }

         }

        
     }

     protected void Button2_Click(object sender, EventArgs e)
     {
         // to get card status

         string sessionUuid = Label2.Text;

         //GetNIDCardStatus(sessionUuid);
         WebReferenceNID.getCardIssueCountServiceRequest sRequest = new WebReferenceNID.getCardIssueCountServiceRequest();

         WebReferenceNID.cardIssueCountSearchCriteria sc = new WebReferenceNID.cardIssueCountSearchCriteria();
         sc.cardIssueTypeCode = TextBox1.Text.Trim();
         sc.nid = txtNID.Text.Trim();
         sc.deliveryType = ddlType.Text.Trim();

         if (TextBox1.Text.Trim() == "1" || TextBox1.Text.Trim() == "4")
         {

             WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
             rh.sessionUuid = sessionUuid;
             //rh.clientIP = "172.22.1.26";
             //rh.clientName = "mmmm";
             //rh.interfaceVersion = "v1.1";


             sRequest.requestHeader = rh;
             sRequest.criteria = sc;


             WebReferenceNID.PartnerService cps = new WebReferenceNID.PartnerService();
             WebReferenceNID.getCardIssueCountServiceResponse
              sResponse = cps.getPartnerCardIssueCount(sRequest);

             // WebReferenceNID.bulkBankTransactionServiceRequest bbReq = new WebReferenceNID.bulkBankTransactionServiceRequest();
             // bbReq.requestHeader = rh;
             // bbReq.bankCode = "3000";

             // WebReferenceNID.bankPaymentTransaction bpt = new WebReferenceNID.bankPaymentTransaction();
             // bpt.amount = 345;
             // bpt.paymentMode = "mobile";
             // bpt.txnId = "123456Test";
             // bpt.voterId = "1990123459875";
             // WebReferenceNID.bankPaymentTransaction[] bptList = { new WebReferenceNID.bankPaymentTransaction() };
             // bptList[0] = bpt;

             // bbReq.transactionList = bptList;


             //WebReferenceNID.bulkBankTransactionServiceResponse bbResponse= cps.addBulkBankTransaction(bbReq);

             //if (bbResponse.operationResult.success)
             //{
             //    string serviceID = bbResponse.serviceId.ToString();
             //}
             //else
             //{
             //    Label1.Text += bbResponse.operationResult.error.errorCode.ToString() + " (" + bbResponse.operationResult.error.errorMessage + ")<BR>";
             //}



             if (sResponse.operationResult.success)
             {
                 Label1.Text = "Fee:" + sResponse.cardIssueInfo.fee.ToString() + "Count:" + sResponse.cardIssueInfo.sum.ToString();
             }
             else
             {
                 Label1.Text += sResponse.operationResult.error.errorCode.ToString() + " (" + sResponse.operationResult.error.errorMessage + ")<BR>";
             }
         }
         else
         {
             Label1.Text = "Fee:" + "0" + "Count:" + "-1";
         }
     }
     protected void Button3_Click(object sender, EventArgs e)
     {
         // for log out
         WebReferenceNID.logoutServiceRequest lsr = new WebReferenceNID.logoutServiceRequest();

         WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
         rh.sessionUuid = Label2.Text;

         lsr.requestHeader = rh;

         //  loginRequest
         WebReferenceNID.logoutServiceResponse lsResponse = new WebReferenceNID.logoutServiceResponse();

         WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
         lsResponse = ps.logout(lsr);
         
         if (lsResponse.operationResult.success)
         {
             Label3.Text = "Logged Out";
         }
         else
         {
             Label3.Text = lsResponse.operationResult.error.errorMessage;
         }
     }
     protected void btnBulkTransaction_Click(object sender, EventArgs e)
     {
         // get Transaction Status
         WebReferenceNID.PartnerService cps = new WebReferenceNID.PartnerService();
         string sessionUuid = Label2.Text;
         WebReferenceNID.requestHeader rh = new WebReferenceNID.requestHeader();
         rh.sessionUuid = sessionUuid;

         WebReferenceNID.bulkBankTransactionServiceRequest bbReq = new WebReferenceNID.bulkBankTransactionServiceRequest();
         bbReq.requestHeader = rh;
         bbReq.bankCode = "3000";

         WebReferenceNID.bankPaymentTransaction bpt = new WebReferenceNID.bankPaymentTransaction();
         bpt.amount = 1;
         bpt.amountSpecified = true;
         bpt.paymentMode = "mobile";
         
         Random rnd = new Random();
         int month = rnd.Next(1, 13);

         bpt.txnId = "123456Test0" + month;
         bpt.voterId = "1990123459875";
         WebReferenceNID.bankPaymentTransaction[] bptList = { new WebReferenceNID.bankPaymentTransaction() };
         bptList[0] = bpt;
         //  bpt.
         // bpt=bbReq.transactionList.p
         bbReq.transactionList = bptList;
         string rest = ToSoap(bbReq);
         WebReferenceNID.bulkBankTransactionServiceResponse bbResponse = cps.addBulkBankTransaction(bbReq);
         
         ///
       
         //XmlTypeMapping myTypeMapping = (new SoapReflectionImporter().ImportTypeMapping(typeof(WebReferenceNID.bulkBankTransactionServiceRequest)));
         //XmlSerializer mySerializer = new XmlSerializer(bbReq.GetType());

         //FileStream stream = new FileStream("C:\\T\\T.xml", FileMode.Append);
         //mySerializer.Deserialize(stream);

         //Envelope envelope = null;
         //using (var reader = System.IO.File.OpenText("C:\\T\\Test.xml"))
         //{
         //    envelope = (Envelope)s1.Deserialize(reader);
         //}
         ////

         if (bbResponse.operationResult.success)
         {
             lblTransactionStatus.Text = bbResponse.serviceId.ToString();
         }
         else
         {
             lblTransactionStatus.Text += bbResponse.operationResult.error.errorCode.ToString() + " (" + bbResponse.operationResult.error.errorMessage + ")<BR>";
         }

     }
     protected void btnPassChange_Click(object sender, EventArgs e)
     {
         // for live password change 
         // expired code: 1019
         ChangePasswordForExpired();
     }

    private void ChangePasswordForExpired()
     {
         WebReferenceNID.changeExpiredPasswordServiceResponse expRes = new WebReferenceNID.changeExpiredPasswordServiceResponse();
         WebReferenceNID.changeExpiredPasswordServiceRequest expreq = new WebReferenceNID.changeExpiredPasswordServiceRequest();
         expreq.loginName = "tbl";
         expreq.oldPassword = "tbl069";
         expreq.newPassword = "tbl069";
         expreq.confirmNewPassword = "tbl069";
         WebReferenceNID.PartnerService ps = new WebReferenceNID.PartnerService();
         expRes = ps.changeExpiredPassword(expreq);

         if (expRes.operationResult.success)
         {
             lblTransactionStatus.Text = "new pass:" + expreq.newPassword + "Service ID:" + expRes.serviceId.ToString();
         }
         else
         {
             lblTransactionStatus.Text += expRes.operationResult.error.errorCode.ToString() + " (" + expRes.operationResult.error.errorMessage + ")<BR>";
         }
     }

    public  string ToSoap(Object objToSoap)
    {
        IFormatter formatter;
       // SoapFormatter formatter;
        MemoryStream memStream = null;
        string strObject = "";
        try
        {
          
            memStream = new MemoryStream();
            formatter = new System.Runtime.Serialization.Formatters.Soap.SoapFormatter();
           // formatter = new IFormatter();
            formatter.Serialize(memStream, objToSoap);
            strObject = Encoding.ASCII.GetString(memStream.GetBuffer());
            int index = strObject.IndexOf("\0");//Check for the null terminator character
            if (index > 0)
            {
                strObject = strObject.Substring(0, index);
            }
        }
        catch (Exception exception)
        {
            throw exception;
        }
        finally
        {
            if (memStream != null) memStream.Close();
        }
        return strObject;
    }
}