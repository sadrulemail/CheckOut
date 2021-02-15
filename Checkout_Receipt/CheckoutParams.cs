using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Checkout_Receipt
{
 public   class CheckoutParams
    {
        public string RefID { get; set; }
        public Double Amount { get; set; }
        public Double Fees { get; set; }
        public Double Vat { get; set; }
        public string FullName { get; set; }
        public string Email { get; set; }
        public string MerchantName { get; set; }
        public string MerchantCompanyURL { get; set; }
        public string OrderNo { get; set; }
        public string TakaInWord_Eng { get; set; }
        public string _Keywords { get; set; }
        public string Meta1_label { get; set; }
        public string Meta1 { get; set; }
        public string Meta2_label { get; set; }
        public string Meta2 { get; set; }
        public string Meta3_label { get; set; }
        public string Meta3 { get; set; }

        public string Meta4_label { get; set; }
        public string Meta4 { get; set; }

        public string Meta5_label { get; set; }
        public string Meta5{ get; set; }

        public Double ServiceCharge { get; set; }
        public Double InterestAmount { get; set; }
        public Boolean Meta1_Printable { get; set; }
        public Boolean Meta2_Printable { get; set; }
        public Boolean Meta3_Printable { get; set; }
        public Boolean Meta4_Printable { get; set; }
        public Boolean Meta5_Printable { get; set; }
        public DateTime PaymentDT { get; set; }


    }
}
