using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Xml;

namespace Reporting
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //string RefNo = "313350BB0002EA";
            //string Amount = "1,200.00 BDT";
            //string ApplicantName = "Muhammad Ashik Iqbal Muhammad Ashik Iqbal Muhammad Ashik Iqbal";
            ////ApplicantName = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";


            //Passport_Receipt.Receipt r = new Passport_Receipt.Receipt();
            //byte[] bytes = r.getReceiptBytes(RefNo, Amount, ApplicantName, "Paid by: Trust Bank Mobile Money #8801730320272");

            //string FileName = Path.Combine(Path.GetTempPath(), RefNo + ".pdf");

            //using (FileStream file = new FileStream(FileName, FileMode.Create, FileAccess.Write))
            //{
            //    file.Write(bytes, 0, bytes.Length);
            //}

            //System.Diagnostics.Process.Start(FileName);                
                
        }

        private void button2_Click(object sender, EventArgs e)
        {

            this.Cursor = Cursors.WaitCursor;
            string RefNo = textBox1.Text;
            double Amount = double.Parse(textBox3.Text);
            string ApplicantName = textBox2.Text.ToUpper();
            //ApplicantName = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";

           
            Passport_Receipt.Receipt r = new Passport_Receipt.Receipt();
            byte[] bytes = r.getReceiptBytesFromCrystalReport(RefNo, Amount, ApplicantName, "Paid by: Trust Bank Mobile Money");

            string FileName = Path.Combine(Path.GetTempPath(), RefNo + ".pdf");

            using (FileStream file = new FileStream(FileName, FileMode.Create, FileAccess.Write))
            {
                file.Write(bytes, 0, bytes.Length);
            }

            System.Diagnostics.Process.Start(FileName);
            this.Cursor = Cursors.Default;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            textBox4.Text = "PE1lc3NhZ2UgZGF0ZT0iMjMvMTAvMjAxNCAwODoyMzozOSI+PFZlcnNpb24+MS4wPC9WZXJzaW9uPjxPcmRlcklEPjM2MTM8L09yZGVySUQ+PFRyYW5zYWN0aW9uVHlwZT5wdXJjaGFzZTwvVHJhbnNhY3Rpb25UeXBlPjxQQU4+NzEyMzAwWFhYWDEyNzc8L1BBTj48UHVyY2hhc2VBbW91bnQ+MTAwPC9QdXJjaGFzZUFtb3VudD48Q3VycmVuY3k+MDUwPC9DdXJyZW5jeT48VHJhbkRhdGVUaW1lPjIzLzEwLzIwMTQgMDg6MjM6Mzk8L1RyYW5EYXRlVGltZT48UmVzcG9uc2VDb2RlPjAwMDwvUmVzcG9uc2VDb2RlPjxSZXNwb25zZURlc2NyaXB0aW9uPkFwcHJvdmVkLCBiYWxhbmNlcyBhdmFpbGFibGU8L1Jlc3BvbnNlRGVzY3JpcHRpb24+PEJyYW5kPlZJU0E8L0JyYW5kPjxPcmRlclN0YXR1cz5BUFBST1ZFRDwvT3JkZXJTdGF0dXM+PEFwcHJvdmFsQ29kZT4xODEyMTcgQTwvQXBwcm92YWxDb2RlPjxBY3FGZWU+MDwvQWNxRmVlPjxNZXJjaGFudFRyYW5JRD4zMTM0MzEzNDMwMzUzMjM2MzAzOTMyMzgzNzMwMzAzMDMwMzAzMDMwPC9NZXJjaGFudFRyYW5JRD48T3JkZXJEZXNjcmlwdGlvbj5SRUIgMTMzNTNERjAwMDBFNUE8L09yZGVyRGVzY3JpcHRpb24+PEFwcHJvdmFsQ29kZVNjcj4xODEyMTc8L0FwcHJvdmFsQ29kZVNjcj48UHVyY2hhc2VBbW91bnRTY3I+MS4wMDwvUHVyY2hhc2VBbW91bnRTY3I+PEN1cnJlbmN5U2NyPjA1MDwvQ3VycmVuY3lTY3I+PE9yZGVyU3RhdHVzU2NyPkFQUFJPVkVEPC9PcmRlclN0YXR1c1Njcj48TmFtZT5BU0hJSyBJUUJBTDwvTmFtZT48VGhyZWVEU1ZlcmlmaWNhaW9uPjwvVGhyZWVEU1ZlcmlmaWNhaW9uPjxUaHJlZURTU3RhdHVzPkRlY2xpbmVkPC9UaHJlZURTU3RhdHVzPjwvTWVzc2FnZT4=";

            textBox4.Text = DecryptConnectionString(textBox4.Text);
            string xmlStr = textBox4.Text;
            XmlDocument x = new XmlDocument();
            x.LoadXml(xmlStr);

            string PAN = x.GetElementsByTagName("PAN")[0].InnerText;
            string MerchantTranID = x.GetElementsByTagName("MerchantTranID")[0].InnerText;
            string AcqFee = x.GetElementsByTagName("AcqFee")[0].InnerText;
            string Name = x.GetElementsByTagName("Name")[0].InnerText;
            string Brand = x.GetElementsByTagName("Brand")[0].InnerText;
            string ThreeDSStatus = x.GetElementsByTagName("ThreeDSStatus")[0].InnerText;
            string ThreeDSVerificaion = x.GetElementsByTagName("ThreeDSVerificaion")[0].InnerText;

            
        }

        public string DecryptConnectionString(string connectionString)
        {
            string result = "";

            bool app = true;

            if (app == true)
            {
                Byte[] b = Convert.FromBase64String(connectionString);
                string decryptedConnectionString = System.Text.ASCIIEncoding.ASCII.GetString(b);
                result = decryptedConnectionString;
            }
            else if (app == false)
            {
                result = connectionString;
            }

            return result;
        }
    }
}
