<%@ WebService Language="C#" Class="PassportReceipt" %>


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
//using iTextSharp.text;
//using iTextSharp.text.pdf;
using System.IO;
using CrystalDecisions.Shared;
using System.Data;
using System.Drawing;
using CrystalDecisions.CrystalReports.Engine;

/// <summary>
/// Summary description for PassportReceipt
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class PassportReceipt : System.Web.Services.WebService
{
    [WebMethod]
    public string ReceiptPDF(string RefID, Double Amount, string ApplicantName, string _Keywords)
    {
        //string MRP_Fee = "";
        //string Renewal_Fee = ""; 
        byte[] arr;

        //CrystalReport1 cr = new CrystalReport1();
        CrystalReport5_QRcode cr = new CrystalReport5_QRcode();
        cr.Load();
        string QRCodeTest = RefID.ToUpper()
                + Environment.NewLine + ApplicantName
                + Environment.NewLine + string.Format("{0:N2}", Amount);

        ReportDataSet ds = new ReportDataSet();
        ReportDataSet.DataTable1DataTable dt = new ReportDataSet.DataTable1DataTable();
        ReportDataSet.DataTable1Row oRow1 = dt.NewDataTable1Row();
        oRow1.QRCode = getQRImage(QRCodeTest, 300);
        dt.AddDataTable1Row(oRow1);

        ds.Tables.Add(dt);
        ds.AcceptChanges();
        cr.SetDataSource(dt.DefaultView);

        cr.SetParameterValue("Barcode", Convert_128A(RefID.ToUpper()));
        cr.SetParameterValue("RefID", RefID.ToUpper());
        cr.SetParameterValue("ApplicantName", ApplicantName);

        //int tot_amt = Convert.ToString(Amount);
        Double RenewalFee;
        Double MRPFee;
        Double Vat;
        Double AmountExceptVat;

        Vat = 15 * Amount / 115;
        AmountExceptVat = Amount - Vat;

        if (AmountExceptVat >= 6000)
        {
            //int RenewalFee;
            MRPFee = 6000;
            RenewalFee = AmountExceptVat - MRPFee;

        }
        else if (AmountExceptVat >= 3000)
        {
            //int RenewalFee;
            MRPFee = 3000;
            RenewalFee = AmountExceptVat - MRPFee;

        }
        else
        {
            //int RenewalFee;
            MRPFee = 0;
            RenewalFee = AmountExceptVat;
        }
        cr.SetParameterValue("Total_Fee", string.Format("{0:N2}", Amount));
        cr.SetParameterValue("MRP_Fee", string.Format("{0:N2}", MRPFee));
        cr.SetParameterValue("Renewal_Fee", string.Format("{0:N2}", RenewalFee));
        cr.SetParameterValue("Vat", string.Format("{0:N2}", Vat));

        cr.SummaryInfo.ReportTitle = "Reference No # " + RefID.ToUpper().Trim();
        cr.SummaryInfo.ReportAuthor = "Trust Bank In-House Software Development Team";
        cr.SummaryInfo.ReportSubject = "Passport Payment Receipt";
        cr.SummaryInfo.KeywordsInReport = _Keywords;



        using (Stream st = cr.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat))
        {
            arr = new byte[st.Length];
            st.Read(arr, 0, (int)st.Length);
            File.WriteAllBytes("C:\\A\\Passport.pdf", arr);
        }
        cr.Close();
        cr.Dispose();




        //DiskFileDestinationOptions objDiskOpt = new DiskFileDestinationOptions();
        //objDiskOpt.DiskFileName = "C:\\1.pdf";

        //ExportOptions eo = new ExportOptions();
        ////eo.ExportDestinationType = ExportDestinationType.DiskFile;
        //eo.ExportDestinationType = ExportDestinationType.NoDestination;
        //eo.ExportFormatType = ExportFormatType.PortableDocFormat;
        //eo.ExportDestinationOptions = objDiskOpt;

        //cr.Export(eo);
        return "Hello World";
    }

    private byte[] getQRImage(string value, int _Width)
    {
        byte[] QRImage = null;

        var writer = new ZXing.BarcodeWriter
        {
            Format = ZXing.BarcodeFormat.QR_CODE,
            Options = new ZXing.QrCode.QrCodeEncodingOptions
            {
                Width = _Width,
                Height = _Width,
                ErrorCorrection = ZXing.QrCode.Internal.ErrorCorrectionLevel.L
            }
        };

        System.Drawing.Bitmap bitmap = writer.Write(value);
        ImageConverter converter = new ImageConverter();
        QRImage = (byte[])converter.ConvertTo(bitmap, typeof(byte[]));

        //using (System.IO.MemoryStream ms = new System.IO.MemoryStream())
        //{
        //    bitmap.Save(ms, System.Drawing.Imaging.ImageFormat.Jpeg);
        //    bitmap.Save("C:\\A\\A.jpg");
        //    QRImage = ms.ToArray();
        //    //using (FileStream file = new FileStream("C:\\A\\A.jpg", FileMode.Create, System.IO.FileAccess.Write))
        //    //    ms.CopyTo(file);
        //}
        File.WriteAllBytes("C:\\A\\A1.jpg", QRImage);

        return QRImage;
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
