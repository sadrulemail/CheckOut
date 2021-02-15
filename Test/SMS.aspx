<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SMS.aspx.cs" Inherits="SMS" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>SMS Send</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        To: <asp:TextBox ID="txtMobileNo" runat="server" Text="8801730320272"></asp:TextBox><br /><br />
        Message: <asp:TextBox ID="txtMessage" runat="server" Width="1000px" MaxLength="160" Text="This is a test SMS sent from http://172.20.1.27:100/SMS/Sms.svc">
        </asp:TextBox><br /><br />
        <asp:Label ID="Label1" runat="server" Text="" Font-Bold="true" Font-Size="Large"></asp:Label><br /><br />
        <asp:Button ID="Button1" runat="server" Text="Send" OnClick="Button1_Click" Width="100px" />
    </div>
    </form>
</body>
</html>
