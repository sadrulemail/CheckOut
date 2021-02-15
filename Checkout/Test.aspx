<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="Test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:TextBox ID="TextBox1" runat="server" Width="800px"></asp:TextBox><br />
        <asp:TextBox ID="TextBox2" runat="server" Text="1234567890abcdefABCDEF" Width="800px"></asp:TextBox><br />
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
        <br /><br /><br />
        <asp:TextBox ID="TextBox3" runat="server" Width="800px"></asp:TextBox><br />
    </div>
    </form>
</body>
</html>
