var PaidAmount = 0;
var SourceTax = 0;
var RevAmount = 0;
var TotalBill = 0;
var CashReceived = 0;
var InvoiceAmount = 0;

function LoadVars() {
    PaidAmount = $('#ctl00_ContentPlaceHolder2_txtPaidAmount').val();
    SourceTax = $('#ctl00_ContentPlaceHolder2_txtSourceTax').val();
    RevAmount = $('#ctl00_ContentPlaceHolder2_txtRevAmount').val();
    TotalBill = $('#ctl00_ContentPlaceHolder2_txtTotalBill').val();
    InvoiceAmount = $('#ctl00_ContentPlaceHolder2_txtInvoiceAmount').val();

    if (SourceTax == "") SourceTax = 0;
    if (PaidAmount == "") PaidAmount = 0;
    if (RevAmount == "") RevAmount = 0;
    if (TotalBill == "") TotalBill = 0;
    if (InvoiceAmount == "") InvoiceAmount = 0;
}
function RefreshUI() {    
    if (SourceTax > 0)
        $('.chalan-tr').show();
    else {        
        $('#ctl00_ContentPlaceHolder2_txtChalanNo').val('');
        $('#ctl00_ContentPlaceHolder2_txtChalanDate').val('');
        $('.chalan-tr').hide();
    }

    TotalBill = (parseFloat(InvoiceAmount).toFixed(2) * 1);
    $('#ctl00_ContentPlaceHolder2_txtTotalBill').val(TotalBill.toFixed(2));

    PaidAmount = (parseFloat(InvoiceAmount).toFixed(2) * 1)
        - (parseFloat(RevAmount).toFixed(2) * 1)
        - (parseFloat(SourceTax).toFixed(2) * 1);
    $('#ctl00_ContentPlaceHolder2_txtPaidAmount').val(PaidAmount.toFixed(2));

    CashReceived = (parseFloat(RevAmount).toFixed(2) * 1)
        + (parseFloat(PaidAmount).toFixed(2) * 1);
    $('#ctl00_ContentPlaceHolder2_txtCashReceived').val(CashReceived.toFixed(2));
}
function pageReady() {
    LoadVars();
    RefreshUI();

    $('#ctl00_ContentPlaceHolder2_txtSourceTax')
        .on('propertychange keyup paste input', function () {            
            LoadVars();
            RefreshUI();
        });
};