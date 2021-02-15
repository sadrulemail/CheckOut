using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace WebApplication_socket
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            //const String hostip = "192.168.10.210";
            //const String hostip = "172.22.1.147";
            //const int port = 645;
            //TcpClient client = new TcpClient(hostip, port);
            //NetworkStream stream = client.GetStream();
            //String msg = "";
            //msg = "<?xml version='1.0' encoding='UTF-8'?>";
            //msg += "<TKKPG>";
            //msg += "<Request>";
            //msg += "<Operation>CreateOrder</Operation>";
            //msg += "<Language>EN</Language>";
            //msg += "<Order>";
            //msg += "<OrderType>Purchase</OrderType>";
            //msg += "<Merchant>POS_999</Merchant>";
            //msg += "<Amount>100</Amount>";
            //msg += "<Currency>050</Currency>";
            //msg += "<Description>2</Description>";
            //msg += "<ApproveURL>http://localhost:52547/Approved.aspx</ApproveURL>";
            //msg += "<CancelURL>http://localhost:52547/Cancelled.aspx</CancelURL>";
            //msg += "<DeclineURL>http://localhost:52547/Declined.aspx</DeclineURL>";
            //msg += "</Order></Request></TKKPG>";
            //List<string> header = new List<string>();

            //header.Add("POST " + "/Exec" + " HTTP/1.0\r\n");
            //header.Add("Host: " + hostip + "\r\n");
            //header.Add("Content-type: application/x-www-form-urlencoded\r\n");
            //header.Add("Content-Length: " + msg.Length + "\r\n\r\n");
            //String dataval = header[0] + header[1] + header[2] + header[3] + msg;
            //byte[] send = Encoding.ASCII.GetBytes(dataval);
            //stream.Write(send, 0, send.Length);
            //stream.Flush();
            //byte[] data = new Byte[2048];
            //Int32 bytes_read = stream.Read(data, 0, data.Length);
            //MyFunction objFunction=new MyFunction();
            //String response=objFunction.msg_get(Encoding.ASCII.GetString(data, 0, bytes_read));
            //List<string> objList= objFunction.xml_to_list(response);
            //Response.Redirect(objList[2]+"?ORDERID=" + objList[0] + "&SESSIONID=" + objList[1]);
            //stream.Close();
            //client.Close();
            String path = "/Exec";
            String msg = "";
            msg = "<?xml version='1.0' encoding='UTF-8'?>";
            msg += "<TKKPG>";
            msg += "<Request>";
            msg += "<Operation>CreateOrder</Operation>";
            msg += "<Language>EN</Language>";
            msg += "<Order>";
            msg += "<OrderType>Purchase</OrderType>";
            msg += "<Merchant>" + txtMerchant.Text + "</Merchant>";
            msg += "<Amount>100</Amount>";
            msg += "<Currency>050</Currency>";
            msg += "<Description>Invoice No 8925752</Description>";

            //msg += "<ApproveURL>http://localhost:52547/Approved.aspx</ApproveURL>";
            //msg += "<CancelURL>http://localhost:52547/Cancelled.aspx</CancelURL>";
            //msg += "<DeclineURL>http://localhost:52547/Declined.aspx</DeclineURL>";

            msg += "<ApproveURL>https://ibanking.tblbd.com/TestITCL/Approved.aspx</ApproveURL>";
            msg += "<CancelURL>https://ibanking.tblbd.com/TestITCL/Cancelled.aspx</CancelURL>";
            msg += "<DeclineURL>https://ibanking.tblbd.com/TestITCL/Declined.aspx</DeclineURL>";

            msg += "</Order></Request></TKKPG>";

            string hostName = txtIP.Text;
            int hostPort = int.Parse(txtPort.Text);

            //string hostName = "172.22.1.147";
            //int hostPort = 644;

            //string hostName = "172.20.1.45";
            //int hostPort = 443;

            string headers;
            string response = "";

            Socket sk = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
            System.Net.IPAddress remoteIPAddress = System.Net.IPAddress.Parse(hostName);
            System.Net.IPEndPoint remoteEndPoint = new System.Net.IPEndPoint(remoteIPAddress, hostPort);
            headers = "POST " + path + " HTTP/1.0\r\n";
            headers += "Host: " + hostName + "\r\n";
            headers += "Content-type: application/x-www-form-urlencoded\r\n";
            headers += "Content-Length: " + msg.Length + "\r\n\r\n";
            headers += msg;

            TcpClient tcpClient;
            NetworkStream networkStream;
            StreamWriter streamWriter;
            StreamReader streamReader;

            tcpClient = new TcpClient(hostName, hostPort);
            networkStream = tcpClient.GetStream();

            streamWriter = new StreamWriter(networkStream);
            streamReader = new StreamReader(networkStream);

            streamWriter.WriteLine(headers);
            streamWriter.Flush();

            response = streamReader.ReadToEnd();
            MyFunction objFunction = new MyFunction();
            List<string> objList = objFunction.xml_to_list(objFunction.msg_get(response));
            Response.Redirect(objList[2] + "?ORDERID=" + objList[0] + "&SESSIONID=" + objList[1]);
            tcpClient.Close();
        }

       
    }
}