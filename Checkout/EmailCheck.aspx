<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmailCheck.aspx.cs" Inherits="EmailCheck" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="txtEmail" runat="server" Width="400px"></asp:TextBox>
        <asp:Button ID="cmdCheck" runat="server" Text="Check" OnClick="cmdCheck_Click" />
        <br />
        <asp:Label ID="lblStatus" runat="server" Text="Label"></asp:Label>
    </div>
    </form>
</body>
</html>
