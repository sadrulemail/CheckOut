<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CheckoutSuccess.aspx.cs" Inherits="CheckoutSuccess" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
  
    <div style="background-color:Green" align="center">
    Global Payment Check out success page
    </div>
      <div style="" align="center">
     Please Click to the Payment button to complete the transaction.
    </div>
    <div style="" align="center">
      <asp:Button ID="btnSubmit" runat="server" Text="Payment" 
            onclick="btnSubmit_Click" />
    </div>
    </form>
</body>
</html>
