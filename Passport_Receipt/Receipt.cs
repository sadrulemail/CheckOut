using System;
//using iTextSharp.text;
//using iTextSharp.text.pdf;
using System.IO;
using CrystalDecisions.Shared;
using System.Data;
using System.Drawing;

namespace Passport_Receipt
{
    public class Receipt
    {
        public byte[] getReceiptBytesFromCrystalReport(string RefID, Double Amount, string ApplicantName, string _Keywords)
        {
            //string MRP_Fee = "";
            //string Renewal_Fee = ""; 
            byte[] arr;

            //CrystalReport1 cr = new CrystalReport1();
            using (CrystalReport5_QRcode cr = new CrystalReport5_QRcode())
            {
                cr.Load();
                //  cr.Refresh();
                //ReportDataSet.DataTable1DataTable DT = new ReportDataSet.DataTable1DataTable();
                //ReportDataSet.DataTable1Row oRow = DT.NewDataTable1Row();
                //oRow.QRImage = getQRImage("This is a test", 400);     
                string QRCodeTest = RefID.ToUpper();
                //oRow.QRCode = getQRImage(QRCodeTest, 300);
                //DT.Rows.Add(oRow);                
                ReportDataSet ds = new ReportDataSet();
                ReportDataSet.DataTable1DataTable dt = new ReportDataSet.DataTable1DataTable();
                ReportDataSet.DataTable1Row oRow1 = dt.NewDataTable1Row();
                oRow1.QRCode = getQRImage(QRCodeTest, 300);
                dt.AddDataTable1Row(oRow1);
                dt.TableName = "DataTable1";
                //ds.DataTable1.datatable1 = dt;
                //DataTable DT1 = (DataTable)DT;
                //DT.TableName = "DataTable1";
                //DataSet ds = new DataSet();
                //ds.Tables.Add(DT);
                //ds.Tables.Add(DT);
                //cr.VerifyDatabase();
                ds.Tables.Add(dt);
                ds.AcceptChanges();
                //cr.VerifyDatabase();
                cr.SetDataSource(ds);


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
                }
                cr.Close();
                cr.Dispose();            
            }

            return arr;

            //DiskFileDestinationOptions objDiskOpt = new DiskFileDestinationOptions();
            //objDiskOpt.DiskFileName = "C:\\1.pdf";

            //ExportOptions eo = new ExportOptions();
            ////eo.ExportDestinationType = ExportDestinationType.DiskFile;
            //eo.ExportDestinationType = ExportDestinationType.NoDestination;
            //eo.ExportFormatType = ExportFormatType.PortableDocFormat;
            //eo.ExportDestinationOptions = objDiskOpt;

            //cr.Export(eo);
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
            //File.WriteAllBytes("C:\\A\\A1.jpg", QRImage);

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

        //public byte[] getReceiptBytes(string RefNo, string Amount, string ApplicantName, string _Keywords)
        //{
        //    byte[] Retval = null;
        //    using (MemoryStream ms = getReceiptStream(RefNo, Amount, ApplicantName, _Keywords))
        //    {
        //        Retval = ms.ToArray();
        //    }

        //    return Retval;
        //}

        //private MemoryStream getReceiptStream(string RefNo, string Amount, string ApplicantName, string _Keywords)
        //{
        //    string RefNo_Text = "Reference Number:";
        //    string Amount_Text = "Amount:";
        //    string ApplicantName_Text = "Applicant Name:";
        //    string App_copy = "Applicant's Copy";
        //    string App_copy_pp = "PP Office Copy";
        //    string Passport_Title = "PASSPORT PAYMENT RECEIPT";

        //    Document doc = new Document(new iTextSharp.text.Rectangle(595, 281), 5, 5, 3, 3);
        //    doc.SetPageSize(iTextSharp.text.PageSize.A4);
            
        //    //Document doc = new Document();
        //    //doc.SetPageSize(iTextSharp.text.PageSize.A4);

        //    MemoryStream RetVal = null;

        //    using (var output = new MemoryStream())
        //    {
        //        try
        //        {
        //            PdfWriter writer = PdfWriter.GetInstance(doc, output);
        //            writer.SetEncryption(PdfWriter.STRENGTH128BITS, null, RandomNumer(), PdfWriter.ALLOW_PRINTING);
        //            doc.Open();
                    
        //            BaseFont bf = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.EMBEDDED);


        //            //TBL Logo
        //            System.Drawing.Image TblLogo = (System.Drawing.Image)Passport_Receipt.Properties.Resources.logo1;
        //            iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(TblLogo, System.Drawing.Imaging.ImageFormat.Png);
        //            logo.ScalePercent(40f);

        //            //Left
        //            logo.SetAbsolutePosition(30, doc.PageSize.Height - 60);
        //            doc.Add(logo);

        //            //Right
        //            logo.SetAbsolutePosition(350, doc.PageSize.Height - 60);
        //            doc.Add(logo);

        //            //Bottom Wave
        //            System.Drawing.Image BottomLogo = (System.Drawing.Image)Passport_Receipt.Properties.Resources.bottom3;
        //            iTextSharp.text.Image logo1 = iTextSharp.text.Image.GetInstance(BottomLogo, System.Drawing.Imaging.ImageFormat.Png);
        //            logo1.ScalePercent(30f);

        //            //Left
        //            logo1.SetAbsolutePosition(15, doc.PageSize.Height - 265);
        //            doc.Add(logo1);

        //            //Right
        //            logo1.ScaleAbsolute(195f, 15f);
        //            logo1.SetAbsolutePosition(330, doc.PageSize.Height - 265);
        //            doc.Add(logo1);

        //            //Bottom Logo
        //            System.Drawing.Image BottomLogo1 = (System.Drawing.Image)Passport_Receipt.Properties.Resources.bottom4;
        //            iTextSharp.text.Image logo2 = iTextSharp.text.Image.GetInstance(BottomLogo1, System.Drawing.Imaging.ImageFormat.Png);
        //            logo2.ScalePercent(30f);

        //            //Left
        //            logo2.SetAbsolutePosition(268, doc.PageSize.Height - 265);
        //            doc.Add(logo2);

        //            //Right
        //            //logo2.ScaleAbsolute(300f, 15f);
        //            logo2.SetAbsolutePosition(530, doc.PageSize.Height - 265);
        //            doc.Add(logo2);

        //            //Receipt Title Left
        //            PdfContentByte ReceiptTitle = writer.DirectContent;
        //            BaseFont bf_Title = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);
                                       
        //            ReceiptTitle.SetFontAndSize(bf_Title, 9f);
        //            ReceiptTitle.BeginText();                    
        //            ReceiptTitle.SetTextMatrix(45f, doc.PageSize.Height - 80);
        //            ReceiptTitle.ShowText(Passport_Title);
        //            ReceiptTitle.EndText();


        //            //Receipt Title Left
        //            PdfContentByte ReceiptTitleRight = writer.DirectContent;
        //            //BaseFont bf_Title = BaseFont.CreateFont(BaseFont.HELVETICA_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);

        //            ReceiptTitleRight.SetFontAndSize(bf_Title, 9f);
        //            ReceiptTitleRight.BeginText();                    
        //            ReceiptTitleRight.SetTextMatrix(360, doc.PageSize.Height - 80);
        //            ReceiptTitleRight.ShowText(Passport_Title);
        //            ReceiptTitleRight.EndText();



        //            PdfContentByte appcopy = writer.DirectContent;
        //            BaseFont bf_copy = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.EMBEDDED);

        //            //Applicant's Copy
        //            appcopy.SetFontAndSize(bf_copy, 7f);
        //            appcopy.BeginText();
        //            appcopy.SetTextMatrix(250, doc.PageSize.Height - 40);
        //            appcopy.ShowText(App_copy);
        //            appcopy.EndText();

        //            //Barcode
        //            iTextSharp.text.pdf.PdfContentByte cb = writer.DirectContent;
        //            iTextSharp.text.pdf.Barcode128 bc_left = new Barcode128();
        //            bc_left.TextAlignment = Element.ALIGN_CENTER;
        //            bc_left.Code = RefNo;
        //            bc_left.StartStopText = false;
        //            bc_left.CodeType = iTextSharp.text.pdf.Barcode128.EAN13;
        //            bc_left.Extended = true;
        //            iTextSharp.text.Image img_barcode = bc_left.CreateImageWithBarcode(cb, iTextSharp.text.BaseColor.BLACK, iTextSharp.text.BaseColor.BLACK);

        //            //Left
        //            //cb.SetTextMatrix(4f, 5.0f);
        //            img_barcode.ScaleAbsolute(140, 30);
        //            img_barcode.SetAbsolutePosition(160, doc.PageSize.Height - 120);
        //            cb.AddImage(img_barcode);

        //            //Right
        //            //cb.SetTextMatrix(4f, 5.0f);
        //            img_barcode.SetAbsolutePosition(430, doc.PageSize.Height - 120);
        //            cb.AddImage(img_barcode);
                    

        //            //iTextSharp.text.pdf.PdfContentByte cb = writer.DirectContent;
        //            //iTextSharp.text.pdf.Barcode128 bc = new Barcode128();
        //            //bc.TextAlignment = Element.ALIGN_CENTER;

        //            //bc.Code = RefNo;
        //            //bc.StartStopText = false;
        //            //bc.CodeType = iTextSharp.text.pdf.Barcode128.EAN13;
        //            //bc.Extended = true;

        //            //iTextSharp.text.Image img = bc.CreateImageWithBarcode(cb, iTextSharp.text.BaseColor.BLACK, iTextSharp.text.BaseColor.BLACK);

                    


        //            //Left Reference No. Text
        //            PdfContentByte RefID_app = writer.DirectContent;
        //            BaseFont bf_ID = BaseFont.CreateFont(BaseFont.HELVETICA, BaseFont.CP1252, BaseFont.EMBEDDED);
        //            RefID_app.SetFontAndSize(bf_ID, 9f);
        //            RefID_app.BeginText();
        //            RefID_app.SetTextMatrix(45f, doc.PageSize.Height - 140);
        //            RefID_app.ShowText(RefNo_Text);
        //            RefID_app.EndText();

        //            //Left Reference No.
        //            BaseFont bf_ID_refNo = BaseFont.CreateFont(BaseFont.COURIER_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);
        //            PdfContentByte Refno_app = writer.DirectContent;
        //            Refno_app.SetFontAndSize(bf_ID_refNo, 10f);
        //            Refno_app.BeginText();
        //            Refno_app.SetTextMatrix(70f, doc.PageSize.Height - 150);
        //            Refno_app.ShowText(RefNo);
        //            Refno_app.EndText();

        //            //Left Amount Text
        //            PdfContentByte AmountText_app = writer.DirectContent;
        //            AmountText_app.SetFontAndSize(bf_ID, 9);
        //            AmountText_app.BeginText();
        //            AmountText_app.SetTextMatrix(45f, doc.PageSize.Height - 170);
        //            AmountText_app.ShowText(Amount_Text);
        //            AmountText_app.EndText();

        //            //Left Amount
        //            PdfContentByte Amount_app = writer.DirectContent;
        //            BaseFont bf_ID_amount = BaseFont.CreateFont(BaseFont.COURIER_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);
        //            Amount_app.SetFontAndSize(bf_ID_amount, 10f);
        //            Amount_app.BeginText();
        //            Amount_app.SetTextMatrix(70f, doc.PageSize.Height - 180);
        //            Amount_app.ShowText(Amount);
        //            Amount_app.EndText();

        //            //Left Application Text
        //            PdfContentByte AppNameText_app = writer.DirectContent;
        //            AppNameText_app.SetFontAndSize(bf_ID, 9f);
        //            AppNameText_app.BeginText();
        //            AppNameText_app.SetTextMatrix(45f, doc.PageSize.Height - 200);
        //            AppNameText_app.ShowText(ApplicantName_Text);
        //            AppNameText_app.EndText();

        //            ////Left Application Name
        //            //PdfContentByte AppName_app = writer.DirectContent;
        //            BaseFont bf_ID_appName = BaseFont.CreateFont(BaseFont.COURIER_BOLD, BaseFont.CP1252, BaseFont.EMBEDDED);
        //            //AppName_app.SetFontAndSize(bf_ID_appName, 10f);
        //            //AppName_app.BeginText();
        //            ////AppName_app.SetTextMatrix(70f, doc.PageSize.Height - 210);
        //            //AppName_app.ShowText(ApplicantName);
        //            //AppName_app.Clip();
        //            //AppName_app.SetTextMatrix(70f, doc.PageSize.Height - 210, 300, 300,);
        //            //AppName_app.EndText();

        //            ColumnText ct = new ColumnText(cb);
        //            ct.SetSimpleColumn(new Phrase(new Chunk(ApplicantName, FontFactory.GetFont(FontFactory.COURIER_BOLD, 10, Font.NORMAL))),
        //                               70, doc.PageSize.Height - 200, 310, 0, 10, Element.ALIGN_LEFT | Element.ALIGN_TOP);
        //            ct.Go();

        //            ct.SetSimpleColumn(new Phrase(new Chunk(ApplicantName, FontFactory.GetFont(FontFactory.COURIER_BOLD, 10, Font.NORMAL))),
        //                               385, doc.PageSize.Height - 200, 575, 0, 10, Element.ALIGN_LEFT | Element.ALIGN_TOP);
        //            ct.Go(); 

        //            //Phrase p = new Phrase(ApplicantName, FontFactory.GetFont(BaseFont.COURIER_BOLD, BaseFont.CP1250, true, 10f));
        //            //ColumnText ct = new ColumnText(cb);
        //            //ct.SetSimpleColumn(p, 50, 50, 45, 50, 10, Element.ALIGN_LEFT);
        //            //ct.Go();

        //            //Right Side
        //            //PdfContentByte cb_app = writer.DirectContent;
        //            //cb_app.SetFontAndSize(bf, 12f);
        //            //cb_app.BeginText();
        //            //cb_app.SetTextMatrix(350, 270);
        //            //cb_app.ShowText("Trust Bank Limited");
        //            //cb_app.EndText();

        //            PdfContentByte appcopy_pp = writer.DirectContent;
        //            appcopy_pp.SetFontAndSize(bf_copy, 7f);
        //            appcopy_pp.BeginText();
        //            appcopy_pp.SetTextMatrix(520, doc.PageSize.Height - 40);
        //            appcopy_pp.ShowText(App_copy_pp);
        //            appcopy_pp.EndText();


        //            //Right Ref. Text
        //            PdfContentByte RefID_app_pp = writer.DirectContent;
        //            RefID_app_pp.SetFontAndSize(bf_ID, 9f);
        //            RefID_app_pp.BeginText();
        //            RefID_app_pp.SetTextMatrix(360f, doc.PageSize.Height - 140);
        //            RefID_app_pp.ShowText(RefNo_Text);
        //            RefID_app_pp.EndText();

        //            //Right Ref. No.
        //            PdfContentByte Refno_app_pp = writer.DirectContent;
        //            Refno_app_pp.SetFontAndSize(bf_ID_refNo, 9f);
        //            Refno_app_pp.BeginText();
        //            Refno_app_pp.SetTextMatrix(385f, doc.PageSize.Height - 150);
        //            Refno_app_pp.ShowText(RefNo);
        //            Refno_app_pp.EndText();

        //            //Right Amount Text
        //            PdfContentByte AmountText_app_pp = writer.DirectContent;
        //            AmountText_app_pp.SetFontAndSize(bf_ID, 9f);
        //            AmountText_app_pp.BeginText();
        //            AmountText_app_pp.SetTextMatrix(360f, doc.PageSize.Height - 170);
        //            AmountText_app_pp.ShowText(Amount_Text);
        //            AmountText_app_pp.EndText();

        //            //Right Amount
        //            PdfContentByte Amount_app_pp = writer.DirectContent;
        //            Amount_app_pp.SetFontAndSize(bf_ID_amount, 10f);
        //            Amount_app_pp.BeginText();
        //            Amount_app_pp.SetTextMatrix(385f, doc.PageSize.Height - 180);
        //            Amount_app_pp.ShowText(Amount);
        //            Amount_app_pp.EndText();

        //            //Right Application Text
        //            PdfContentByte AppNameText_app_pp = writer.DirectContent;
        //            AppNameText_app_pp.SetFontAndSize(bf_ID, 9f);
        //            AppNameText_app_pp.BeginText();
        //            AppNameText_app_pp.SetTextMatrix(360f, doc.PageSize.Height - 200);
        //            AppNameText_app_pp.ShowText(ApplicantName_Text);
        //            AppNameText_app_pp.EndText();

        //            //Left Print Text
        //            PdfContentByte Print_text_app_pp = writer.DirectContent;
        //            Print_text_app_pp.SetFontAndSize(bf_ID, 5f);
        //            Print_text_app_pp.BeginText();
        //            Print_text_app_pp.SetTextMatrix(45f, doc.PageSize.Height - 245);
        //            Print_text_app_pp.ShowText(string.Format("Receipt generated on {0:dd MMM, yyyy} at {0:hh:mm:ss tt}", DateTime.Now));
        //            Print_text_app_pp.EndText(); 

        //            //Right Print Text
        //            PdfContentByte Print_text_app_pp_right = writer.DirectContent;
        //            Print_text_app_pp_right.SetFontAndSize(bf_ID, 5f);
        //            Print_text_app_pp_right.BeginText();
        //            Print_text_app_pp_right.SetTextMatrix(360f, doc.PageSize.Height - 245);
        //            Print_text_app_pp_right.ShowText(string.Format("Generated on {0:dd MMM, yyyy} at {0:hh:mm:ss tt}", DateTime.Now));
        //            Print_text_app_pp_right.EndText();                    


        //            ////Right Application Name
        //            //PdfContentByte AppName_app_pp = writer.DirectContent;
        //            //AppName_app_pp.SetFontAndSize(bf_ID_appName, 10f);
        //            //AppName_app_pp.BeginText();
        //            //AppName_app_pp.SetTextMatrix(385f, doc.PageSize.Height - 210);
        //            //AppName_app_pp.ShowText(ApplicantName);
        //            //AppName_app_pp.EndText();
                    


        //            //Line Vertical
        //            cb.SetLineWidth(0.1f);
        //            cb.SetLineDash(5f, 5f);
        //            cb.MoveTo(330f, doc.PageSize.Height - 270f);
        //            cb.LineTo(330f, doc.PageSize.Height - 20f);
        //            cb.Stroke();


        //            //Line Bottom (Right part)
        //            cb.SetLineWidth(0.1f);
        //            cb.SetLineDash(3f, 3f);
        //            cb.MoveTo(30f, doc.PageSize.Width - 25f);
        //            cb.LineTo(doc.PageSize.Width, doc.PageSize.Width - 25f);
        //            cb.Stroke();

        //            //Line Bottom (Left part)
        //            cb.SetLineWidth(0.1f);
        //            cb.SetLineDash(3f, 3f);
        //            cb.MoveTo(0, doc.PageSize.Width - 25f);
        //            cb.LineTo(20f, doc.PageSize.Width - 25f);
        //            cb.Stroke();


        //            //Scissor
        //            System.Drawing.Image ScissorLogo = (System.Drawing.Image)Passport_Receipt.Properties.Resources.scissor1;
        //            iTextSharp.text.Image Scissor = iTextSharp.text.Image.GetInstance(ScissorLogo, System.Drawing.Imaging.ImageFormat.Png);
        //            Scissor.ScalePercent(30f);
        //            Scissor.SetAbsolutePosition(15, doc.PageSize.Height - 283f);
        //            doc.Add(Scissor);
                    


        //            ////////////////////***********************************//////////////////////
                    
        //            doc.AddCreator("Trust Bank Checkout");
        //            doc.AddAuthor("Trust Bank Limited");
        //            doc.AddTitle("Reference No # " + RefNo);
        //            doc.AddSubject("Passport Payment Receipt");
        //            doc.AddAuthor("Trust Bank In-House Software Development Team");
        //            doc.AddKeywords(_Keywords);
        //            doc.Close();

        //            //doc.Close();
        //            //System.Diagnostics.Process.Start(Environment.GetFolderPath(Environment.SpecialFolder.Desktop) + "/codes.pdf");

        //            //MessageBox.Show("Bar codes generated on desktop fileName=codes.pdf");
        //            RetVal = output;                    
        //        }
        //        catch (Exception)
        //        {
        //        }
                
        //    }
        //    return RetVal;
        //}

        protected string RandomNumber()
        {
            return string.Format("{0}{1}{2}", new Random().Next(), new Random().Next(), new Random().Next());
        }
    }
}
