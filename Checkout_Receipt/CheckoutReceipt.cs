using System;
using System.IO;
using CrystalDecisions.Shared;
using System.Text;

namespace Checkout_Receipt
{
    public class CheckoutReceipt
    {
        public byte[] getNIDReceiptBytesFromCrystalReport(string RefID, Double Amount, Double Fees, Double Vat, string FullName, string NID, string IssueType, string ServiceType, string TakaInWord_Eng, string _Keywords)
        {
            //string MRP_Fee = "";
            //string Renewal_Fee = ""; 

            byte[] arr;

            //CrystalReport1 cr = new CrystalReport1();
            rptNIDReceipt cr = new rptNIDReceipt();
            cr.SetParameterValue("Barcode", Convert_128A(RefID.ToUpper()));
            cr.SetParameterValue("RefID", RefID.ToUpper());
            cr.SetParameterValue("FullName", FullName);
            cr.SetParameterValue("NID", NID);
         
            cr.SetParameterValue("Total_Fee", string.Format("{0:N2}", Amount));
            cr.SetParameterValue("Fee", string.Format("{0:N2}", Fees));
            //cr.SetParameterValue("Renewal_Fee", string.Format("{0:N2}", RenewalFee));
            cr.SetParameterValue("Vat", string.Format("{0:N2}", Vat));
            cr.SetParameterValue("IssueType", IssueType);
            cr.SetParameterValue("ServiceType", ServiceType);
            cr.SetParameterValue("TakaInWord_Eng", TakaInWord_Eng);

            cr.SummaryInfo.ReportTitle = "Reference No # " + RefID.ToUpper().Trim();
            cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
            cr.SummaryInfo.ReportSubject = "Passport Payment Receipt";
            cr.SummaryInfo.KeywordsInReport = _Keywords;


            using (Stream oStream = cr.ExportToStream(ExportFormatType.PortableDocFormat))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    oStream.CopyTo(ms);
                    //byte[] arr = new byte[st.Length];
                    //oStream.Read(arr, 0, (int)st.Length);
                    arr = ms.ToArray();
                    cr.Dispose();
                }
            }

            return arr;           
        }


        // for Common Checkout Merchant Common print receipt

        public byte[] getCheckoutReceiptBytesFromCrystalReport(CheckoutParams c_pram)
        {
            //string MRP_Fee = "";
            //string Renewal_Fee = ""; 

            byte[] arr;

            rptMerchantReceipt cr = new rptMerchantReceipt();
            cr.SetParameterValue("Barcode", Convert_128A(c_pram.RefID.ToUpper()));
            cr.SetParameterValue("RefID", c_pram.RefID.ToUpper());
            cr.SetParameterValue("PaymentDT", c_pram.PaymentDT);
            cr.SetParameterValue("MerchantName", c_pram.MerchantName);


            cr.SetParameterValue("Total_Fee", string.Format("{0:N2}", c_pram.Amount));
            cr.SetParameterValue("Fee", string.Format("{0:N2}", c_pram.Fees));
            cr.SetParameterValue("Vat", string.Format("{0:N2}", c_pram.Vat));
            cr.SetParameterValue("ServiceCharge", string.Format("{0:N2}", c_pram.ServiceCharge));
            cr.SetParameterValue("InterestAmount", string.Format("{0:N2}", c_pram.InterestAmount)); // EMI interest Amount

            //cr.SetParameterValue("OrderNo", c_pram.OrderNo);
            cr.SetParameterValue("TakaInWord_Eng", c_pram.TakaInWord_Eng);
            cr.SetParameterValue("MarchentCompanyURL", string.Format("{0}", c_pram.MerchantCompanyURL));

            StringBuilder sb = new StringBuilder();
            sb.Append("<table>");
            if (c_pram.FullName != "") // full name
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append("Name");
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" :  ");
                sb.Append(c_pram.FullName);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.Email != "")
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append("Email");
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" :  ");
                sb.Append(c_pram.Email);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.OrderNo != "")
            {
                sb.Append("<tr>");
                    sb.Append("<td><b>");
                    sb.Append("Order No.");
                    sb.Append("</b></td>");
                    sb.Append("<td>");
                    sb.Append(" :  ");
                    sb.Append(c_pram.OrderNo);
                    sb.Append("</td>");
                sb.Append("</tr>");
            }
          
            if (c_pram.Meta1_label != "")
            {
                sb.Append("<tr>");
                    sb.Append("<td><b>");
                    sb.Append(c_pram.Meta1_label);
                    sb.Append("</b></td>");
                    sb.Append("<td>");
                    sb.Append(" :  ");
                    sb.Append(c_pram.Meta1);
                    sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.Meta2_label != "")
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append(c_pram.Meta2_label);
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" : ");
                sb.Append(c_pram.Meta2);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.Meta3_label != "")
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append(c_pram.Meta3_label);
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" :  ");
                sb.Append(c_pram.Meta3);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.Meta4_label != "")
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append(c_pram.Meta4_label);
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" : ");
                sb.Append(c_pram.Meta4);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            if (c_pram.Meta5_label != "")
            {
                sb.Append("<tr>");
                sb.Append("<td><b>");
                sb.Append(c_pram.Meta5_label);
                sb.Append("</b></td>");
                sb.Append("<td>");
                sb.Append(" :  ");
                sb.Append(c_pram.Meta5);
                sb.Append("</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            cr.SetParameterValue("Meta1_label", sb.ToString());
            //cr.SetParameterValue("Meta1", c_pram.Meta1);
            //cr.SetParameterValue("Meta2_label", c_pram.Meta2_label);
            //cr.SetParameterValue("Meta2", c_pram.Meta2);
            //cr.SetParameterValue("Meta3_label", c_pram.Meta3_label);
            //cr.SetParameterValue("Meta3", c_pram.Meta3);
            //cr.SetParameterValue("Meta4_label", c_pram.Meta4_label);
            //cr.SetParameterValue("Meta4", c_pram.Meta4);
            //cr.SetParameterValue("Meta5_label", c_pram.Meta5_label);
            //cr.SetParameterValue("Meta5", c_pram.Meta5);

            cr.SummaryInfo.ReportTitle = "Reference No # " + c_pram.RefID.ToUpper().Trim();
            cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
            cr.SummaryInfo.ReportSubject = "Passport Payment Receipt";
            cr.SummaryInfo.KeywordsInReport = c_pram._Keywords;



            using (Stream oStream = cr.ExportToStream(ExportFormatType.PortableDocFormat))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    oStream.CopyTo(ms);
                    //byte[] arr = new byte[st.Length];
                    //oStream.Read(arr, 0, (int)st.Length);
                    arr = ms.ToArray();
                    cr.Dispose();
                }
            }

            return arr;


        }

        public byte[] getCheckoutReceiptBytesFromCrystalReport(string RefID, Double Amount, Double Fees, Double Vat, string FullName, string MerchantName, string MarchentCompanyURL, string OrderNo, string TakaInWord_Eng, string _Keywords)
        {
            //string MRP_Fee = "";
            //string Renewal_Fee = ""; 

            byte[] arr;

            rptMerchantReceipt cr = new rptMerchantReceipt();
            cr.SetParameterValue("Barcode", Convert_128A(RefID.ToUpper()));
            cr.SetParameterValue("RefID", RefID.ToUpper());
            cr.SetParameterValue("FullName", FullName);
            cr.SetParameterValue("MerchantName", MerchantName);


            cr.SetParameterValue("Total_Fee", string.Format("{0:N2}", Amount));
            cr.SetParameterValue("Fee", string.Format("{0:N2}", Fees));
            cr.SetParameterValue("Vat", string.Format("{0:N2}", Vat));
            cr.SetParameterValue("OrderNo", OrderNo);
            cr.SetParameterValue("TakaInWord_Eng", TakaInWord_Eng);
            cr.SetParameterValue("MarchentCompanyURL", string.Format("{0}", MarchentCompanyURL));
     
            cr.SummaryInfo.ReportTitle = "Reference No # " + RefID.ToUpper().Trim();
            cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
            cr.SummaryInfo.ReportSubject = "Passport Payment Receipt";
            cr.SummaryInfo.KeywordsInReport = _Keywords;



            using (Stream oStream = cr.ExportToStream(ExportFormatType.PortableDocFormat))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    oStream.CopyTo(ms);
                    //byte[] arr = new byte[st.Length];
                    //oStream.Read(arr, 0, (int)st.Length);
                    arr = ms.ToArray();
                    cr.Dispose();
                }
            }

            return arr;


        }

        // BTCL Report

        public byte[] getBTCLBytesFromCrystalReport(string ExchangeCode, string PhoneNumber, string BillMonth, string BillYear, Double BTCLAmount, Double VatAmount,  Double TotalAmount,string TxnNumber, string BtclCode, string BranchName,DateTime FromDate,DateTime ToDate)
        {
          
            byte[] arr;

            rptBtclDetails cr = new rptBtclDetails();
            cr.SetParameterValue("ExchangeCode", ExchangeCode);
            cr.SetParameterValue("PhoneNumber", PhoneNumber);
            cr.SetParameterValue("BillMonth", BillMonth);

            cr.SetParameterValue("TotalAmount", string.Format("{0:N2}", TotalAmount));
            cr.SetParameterValue("BTCLAmount", string.Format("{0:N2}", BTCLAmount));
            //cr.SetParameterValue("Renewal_Fee", string.Format("{0:N2}", RenewalFee));
            cr.SetParameterValue("VatAmount", string.Format("{0:N2}", VatAmount));
            cr.SetParameterValue("BillYear", BillYear);
            cr.SetParameterValue("TxnNumber", TxnNumber);
            cr.SetParameterValue("BtclCode", BtclCode);
            cr.SetParameterValue("BranchName", BranchName);
            cr.SetParameterValue("FromDate", FromDate);
            cr.SetParameterValue("ToDate", ToDate);

            cr.SummaryInfo.ReportTitle = "BTCL Telephone Bill Payment";
            cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
            cr.SummaryInfo.ReportSubject = "Branch wise BTCL Payment Bill";
        

            using (Stream oStream = cr.ExportToStream(ExportFormatType.PortableDocFormat))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    oStream.CopyTo(ms);
                    //byte[] arr = new byte[st.Length];
                    //oStream.Read(arr, 0, (int)st.Length);
                    arr = ms.ToArray();
                    cr.Dispose();
                }
            }

            return arr;
        }


        public string Convert_128A(string value)
        {
            value = value.ToUpper().Trim();
            char[] a = value.ToCharArray();
            long sum = 103;

            for (int i = 0; i < a.Length; i++)
            {
                sum += (i + 1) * ((int)a[i] - ((int)a[i] < 95 ? 32 : 100));
            }
            return ((char)203 + value + (char)((sum % 103) + ((sum % 103) < 95 ? 32 : 100)) + (char)206).Replace(" ", "Â");
        }
    }
}
