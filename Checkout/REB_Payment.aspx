<%@ Page Language="C#" AutoEventWireup="true" CodeFile="REB_Payment.aspx.cs" Inherits="TestPayment" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trust Bank Checkout REB Payment</title>
    <link rel="shortcut icon" href="favicon.ico" />
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin: 50px auto" align="center">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="group" style="display: inline-block;" align="left">
            <h4>
                Trust Bank Checkout REB Payment</h4>
            <div style="margin: 20px">
                REB Bill Number<br />
                <asp:TextBox runat="server" ID="txtName" Text="" placeholder="reb bill number" Width="300px"
                    MaxLength="255"></asp:TextBox>
                <asp:RequiredFieldValidator ID="reqName" runat="server" ControlToValidate="txtName"
                    ErrorMessage="*" SetFocusOnError="true" ForeColor="Red">
                </asp:RequiredFieldValidator>
                <br />
                <br />
                <asp:Button runat="server" ID="cmdSubmit2" Text="Get Bill Details" OnClick="cmdSubmit2_Click" />
                <asp:Label runat="server" ID="lblLabel"></asp:Label>
                <br />
                <asp:Button ID="cmdPay" runat="server" Text="Mark as Paid (Demo)" 
                    onclick="cmdPay_Click" Visible ="false" />
                  <asp:Label runat="server" ID="lblLabel2"></asp:Label>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
