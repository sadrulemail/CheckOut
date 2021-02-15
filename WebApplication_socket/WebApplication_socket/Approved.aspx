<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Approved.aspx.cs" validateRequest="false" Inherits="EcommerceAPI.Approved" %>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
       <p>order ID : <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label> </p>
        <br />
       <p>Session ID : <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label> </p>
    
    </div>
    <p>Final value Get From PG :<asp:TextBox ID="TextBox1" runat="server" Height="332px" TextMode="MultiLine" Width="885px"></asp:TextBox></p>
    </form>
    </body>
</html>
