<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="WebApplication_socket.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        IP:<asp:TextBox ID="txtIP" runat="server" Text="172.20.1.45"></asp:TextBox>
        <br />
          Port:<asp:TextBox ID="txtPort" runat="server" Text="444"></asp:TextBox>
        <br /> <br />
         Merchant:<asp:TextBox ID="txtMerchant" runat="server" Text="ADAMJEECANTTSCH"></asp:TextBox>
        <br />
         <br />
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
    </div>
    </form>
</body>
</html>
