using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

public partial class SMS : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        //SMS_Webservice.SmsClient sms = new SMS_Webservice.SmsClient();
        //Label1.Text = sms.PushSMS(txtMobileNo.Text, txtMessage.Text, 5, 2, "E561AE5E-8D1F-44CF-896E-438A99F83E2D");
        var PostUrl = "http://172.20.1.27:100/Sms/Email.asmx/Send";
        string content = "";
        //using (WebClient client = new WebClient())
        //{
        //    byte[] response =
        //    client.UploadValues(PostUrl, new System.Collections.Specialized.NameValueCollection()
        //    {
        //                                               { "TOs", "mrmetun@gmail.com" },
        //                                               { "CCs", "" },
        //                                               { "BCCs", "" },
        //                                               { "Subject", "Test mail" },
        //                                               { "BodyHtml", "Test mail....Body" },
        //                                               { "TypeID", "16" },
        //                                               { "Retry", "5" },
        //                                               { "Priority", "5" },
        //                                               { "Confidential", "" },
        //                                               { "KeyCode", "24bb1e46-6570-4861-b833-f96afa8d3886" },
        //                                               { "TraceNo", "1" }
        //    });


        //    content = System.Text.Encoding.UTF8.GetString(response);

        //    //eventLog.WriteEntry(content);
        //}

        // service with the method name added to the end
        //  HttpWebRequest httpReq = (HttpWebRequest)WebRequest.Create(
        //    "http://172.20.1.27:100/Sms/Email.asmx?op=Send");

        //  // add the parameters as key valued pairs making
        //  // sure they are URL encoded where needed
        //  ASCIIEncoding encoding = new ASCIIEncoding();
        //  byte[] postData = encoding.GetBytes("TOs=" + "mrmetun@gmail.com" +
        //     "&CCs=" + ""
        //     + "&BCCs=" + ""
        //     + "&Subject=" + "Test mail"
        //       + "&BodyHtml=" + "Test mail body"
        //         + "&TypeID=" + "16"
        //           + "&Retry=" + "5"
        //            + "&Priority=" + "2"
        //             + "&Confidential=" + ""
        //               + "&KeyCode=" + "24bb1e46-6570-4861-b833-f96afa8d3886"
        //                  + "&TraceNo=" + "12222"

        //     );
        //  httpReq.ContentType = "application/x-www-form-urlencoded";
        //  httpReq.Method = "POST";
        //  httpReq.ContentLength = postData.Length;

        //  // convert the request to a steeam object and send it on its way
        //  Stream ReqStrm = httpReq.GetRequestStream();
        //  ReqStrm.Write(postData, 0, postData.Length);
        //  ReqStrm.Close();

        //  // get the response from the web server and
        //  // read it all back into a string variable
        //  HttpWebResponse httpResp = (HttpWebResponse)httpReq.GetResponse();
        //  StreamReader respStrm = new StreamReader(
        //     httpResp.GetResponseStream(), Encoding.ASCII);
        //string  result = respStrm.ReadToEnd();
        //  httpResp.Close();
        //  respStrm.Close();
        //string xmlPayload = "";

        //string url = "http://172.20.1.27:100/Sms/Email.asmx?op=Send&TOs=" + "mrmetun@gmail.com" + "&CCs=" + "" + "&BCCs=" + "" + "&Subject=" + "Test Mail subject" + "&BodyHtml=" + "Test Mail Body" + "&TypeID=" + 16 + "&Retry=" + 5 + "&Priority=" + 2 + "&Confidential=" + "" + "&KeyCode=" + "24bb1e46-6570-4861-b833-f96afa8d3886" + "&TraceNo=222";

        //// Create the web request
        //HttpWebRequest request = WebRequest.Create(new Uri(url)) as HttpWebRequest;

        //// Set type to POST
        //request.Method = "POST";
        //request.ContentType = "application/xml";

        //// Create the data we want to send
        //StringBuilder data = new StringBuilder();
        //data.Append(xmlPayload);
        //byte[] byteData = Encoding.UTF8.GetBytes(data.ToString());      // Create a byte array of the data we want to send
        //request.ContentLength = byteData.Length;                        // Set the content length in the request headers

        //// Write data to request
        //using (Stream postStream = request.GetRequestStream())
        //{
        //    postStream.Write(byteData, 0, byteData.Length);
        //}

        //// Get response and return it

        ////try
        ////{
        //using (HttpWebResponse response = request.GetResponse() as HttpWebResponse)
        //{
        //    StreamReader reader = new StreamReader(response.GetResponseStream());
        //  string  json_result = reader.ReadToEnd();
        //    reader.Close();
        //}

        InvokeService();


    }

    public HttpWebRequest CreateSOAPWebRequest()
    {
        //Making Web Request    
        HttpWebRequest Req = (HttpWebRequest)WebRequest.Create(@"http://172.20.1.27:100/Sms/Email.asmx");
        //SOAPAction    
        Req.Headers.Add(@"SOAPAction:http://172.20.1.27:100/Send");
        //Content_type    
        Req.ContentType = "text/xml;charset=\"utf-8\"";
        Req.Accept = "text/xml";
        //HTTP method    
        Req.Method = "POST";
        //return HttpWebRequest    
        return Req;
    }

    public void InvokeService()
    {
        //Calling CreateSOAPWebRequest method  
        HttpWebRequest request = CreateSOAPWebRequest();

        XmlDocument SOAPReqBody = new XmlDocument();
        //SOAP Body Request  
        //       SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""utf-8""?>  
        //           <soap:Envelope xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"">  
        //            < soap:Body>  


        //<Send xmlns=""http://172.20.1.45/"">
        //     < TOs > " +"mrmetun@gmail.com"+@"</ TOs >
        //     < CCs >"+ ""+@" </ CCs >
        //     < BCCs >"+ "" +@"</ BCCs >
        //     < Subject >"+" Test"+@" </ Subject >
        //     < BodyHtml >"+" Test body"+@" </ BodyHtml >
        //     < TypeID >"+ 16+@" </ TypeID >
        //     < Retry >"+ 5 +@"</ Retry >
        //     < Priority >"+ 10+@" </ Priority >
        //     < Confidential >"+ ""+@" </ Confidential >
        //     < KeyCode >"+" 24bb1e46-6570-4861-b833-f96afa8d3886"+@" </ KeyCode >
        //     < TraceNo >"+ "Test123"+@" </ TraceNo >
        //   </ Send >
        //             </soap:Body>  
        //           </soap:Envelope>");

        SOAPReqBody.LoadXml(@"<?xml version=""1.0"" encoding=""utf-8""?>
<soap:Envelope xmlns:soap=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"">
 <soap:Body>
    <Send xmlns=""http://172.20.1.27:100/"">
     
    <TOs>" + "mrmetun@gmail.com" + @"</TOs>
    <CCs>" + "" + @"</CCs>
       <BCCs>" + "" + @"</BCCs>
             <Subject>" + "Test" + @"</Subject>
             <BodyHtml>" + " Test body" + @"</BodyHtml>
             <TypeID>" + 16 + @"</TypeID>
             <Retry>" + 5 + @"</Retry>
             <Priority>" + 10 + @"</Priority>
             <Confidential >" + "" + @"</Confidential>
             <KeyCode>" + " 24bb1e46-6570-4861-b833-f96afa8d3886" + @"</KeyCode>
             <TraceNo>" + "Test123" + @"</TraceNo>
    </Send>
  </soap:Body>
</soap:Envelope>");

        using (Stream stream = request.GetRequestStream())
        {
            SOAPReqBody.Save(stream);
        }
        //Geting response from request  
        using (WebResponse Serviceres = request.GetResponse())
        {
            using (StreamReader rd = new StreamReader(Serviceres.GetResponseStream()))
            {
                //reading stream  
                var ServiceResult = rd.ReadToEnd();
                //writting stream result on console  
                Console.WriteLine(ServiceResult);
                Console.ReadLine();
            }
        }
    }


}