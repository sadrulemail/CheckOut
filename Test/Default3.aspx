<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default3.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Web Service Test</title>
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin:20px;border:1px solid silver;display:inline-block;border-radius:4px;padding:20px;box-shadow:0 0 7px gray;vertical-align:top">
    <b>Passport_Payment.asmx/getPassportRefID</b><br /><br />
    Customer Name<br /><asp:TextBox runat="server" ID="txtName" Text="Ashik Iqbal" Width="300px"></asp:TextBox><br /><br />
    Transanction No<br /><asp:TextBox runat="server" ID="txtT" Width="300px"></asp:TextBox><br /><br />
    Amount No<br /><asp:TextBox runat="server" ID="txtAmount" Text="1"></asp:TextBox><br /><br />
    Sender A/C Type<br /><asp:TextBox runat="server" ID="txtType" Text="3"></asp:TextBox><br /><br />
    Notify Mobile<br /><asp:TextBox runat="server" ID="txtNotifyMobile" Text="8801730320272"></asp:TextBox><br /><br />
    Sender Mobile<br /><asp:TextBox runat="server" ID="txtSenderMobile" Text="8801730320272"></asp:TextBox><br /><br />
    Email<br /><asp:TextBox runat="server" ID="txtEmail" Text="ashik.email@gmail.com" Width="300px"></asp:TextBox><br /><br />
    Key Code<br /><asp:TextBox runat="server" ID="txtKeyCode" Text="7497A1F0-47B3-4A89-BAA0-35C3862855CB" Width="300px"></asp:TextBox><br /><br />
    <asp:Button runat="server" ID="cmdSubmit" Text="Submit" onclick="cmdSubmit_Click" />
    <asp:Label runat="server" ID="lblLabel"></asp:Label>
    </div>
    <div style="margin:20px;border:1px solid silver;display:inline-block;border-radius:4px;padding:20px;box-shadow:0 0 7px gray;vertical-align:top">
    <b>Passport_Verify.asmx/CheckPayment</b><br /><br />
    Customer Name<br /><asp:TextBox runat="server" ID="txtName2" Text="Ashik Iqbal" Width="300px"></asp:TextBox><br /><br />
    Payment Reference Number<br /><asp:TextBox runat="server" ID="txtRefID2" Width="300px"></asp:TextBox><br /><br />
    Amount No<br /><asp:TextBox runat="server" ID="txtAmount2" Text=""></asp:TextBox><br /><br />
    EID<br /><asp:TextBox runat="server" ID="txtEID" Text=""></asp:TextBox><br /><br />    
    
    Key Code<br /><asp:TextBox runat="server" ID="txtKeyCode2" Text="502A7BF8-5CA7-4F4C-B614-9CD91BF95F10" Width="300px"></asp:TextBox><br /><br />
    <asp:Button runat="server" ID="cmdSubmit2" Text="Submit" 
            onclick="cmdSubmit2_Click"  />
    <asp:Label runat="server" ID="lblLabel2"></asp:Label>
    </div>
    </form>
</body>
</html>