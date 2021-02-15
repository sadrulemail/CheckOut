<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestPayment.aspx.cs" Inherits="TestPayment" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trust Bank Passport Checkout Test Payment</title>
    <link rel="shortcut icon" href="favicon.ico" />
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
     <meta http-equiv="X-Frame-Options" content="deny" />
</head>
<body>
    <form id="form1" runat="server">
    <div style="margin: 50px auto" align="center">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <div class="group" style="display: inline-block;" align="left">
            <h4>
                Trust Bank Passport Checkout Test Payment</h4>
            <div style="margin: 20px">
                Customer Name<br />
                <asp:TextBox runat="server" ID="txtName" Text="" placeholder="customer name"
                    Width="300px" MaxLength="255"></asp:TextBox>
           
                <br />
                <br />
                Email Address<br />
                <asp:TextBox runat="server" ID="txtEmail" Text="" placeholder="email address" Width="300px"
                    MaxLength="255"></asp:TextBox>
              <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="*" SetFocusOnError="true" ForeColor="Red">
                </asp:RequiredFieldValidator>--%>
                <asp:RegularExpressionValidator runat="server" ID="regEmail" ControlToValidate="txtEmail"
                    SetFocusOnError="True" ErrorMessage="Invalid Email" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                    Display="Dynamic"></asp:RegularExpressionValidator>
                <br />
                <br />
                Amount<br />
                <asp:TextBox runat="server" ID="txtAmount" Text="" Width="80px" placeholder="0" CssClass="right"></asp:TextBox>
                <br />
                <br />
                Marchent Type
                <br />
                Passport Office
               <%-- <asp:DropDownList ID="ddlMarchentType" runat="server" 
                    AppendDataBoundItems="True" DataTextField="MarchentName"
                    DataValueField="MarchentID" DataSourceID="SqlDataSource1">
                    <asp:ListItem Value="" Text=""></asp:ListItem>
                </asp:DropDownList>--%>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" 
                    SelectCommand="SELECT [MarchentID], [MarchentName] FROM [Checkout_Marchent] order by MarchentName">
                </asp:SqlDataSource>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAmount"
                    ErrorMessage="*" SetFocusOnError="true" ForeColor="Red">
                </asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="txtAmount"
                    SetFocusOnError="True" ErrorMessage="Invalid Amount" ForeColor="Red" ValidationExpression="\d*"
                    Display="Dynamic"></asp:RegularExpressionValidator>
                <br />
                <br />
                <asp:Button runat="server" ID="cmdSubmit2" Text="Pay Now" OnClick="cmdSubmit2_Click" />
                <asp:Label runat="server" ID="lblLabel"></asp:Label>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
