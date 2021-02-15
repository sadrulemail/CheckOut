<%@ Page Language="C#" AutoEventWireup="true" ValidateRequest="false" CodeFile="PostXMLData.aspx.cs" Inherits="PostXMLData" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        <asp:TextBox ID="txtXML" runat="server" Height="64px" Width="461px">Camera</asp:TextBox>
        <br />
        <asp:Button ID="btnPost" runat="server" OnClick="btnPost_Click" Text="POST" />
        <br />
    
    </div>
    </form>
</body>
</html>
