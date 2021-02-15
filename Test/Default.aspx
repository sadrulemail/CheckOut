<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
     <form action="http://mobile.trustbanklimited.com/checkout/Passport_Payment_Success.aspx" method="post">
            <input type="hidden" name="ApprovalCode" value="1244" />
            <input type="hidden" name="OrderID" value="1244" />
            <input type="hidden" name="PAN" value="12442343242342" />
                 <input type="submit" value="Submit" />
            </form>
            <br />
    <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
</body>
</html>
