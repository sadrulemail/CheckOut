using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CheckoutSuccess : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        //Checkout_Payment_Verify.CheckMerchantTransactionSoapClient service = new CheckMerchantTransactionService.CheckMerchantTransactionSoapClient();
        //string amount = service.GetTransactionInfo("DIPQ718TOJQWK6663000", "8800000000001");

        Server.Transfer("Default.aspx", true);
    }
}