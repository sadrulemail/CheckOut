<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TestPayment.aspx.cs" Inherits="TestPayment" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Trust Bank Checkout Test Payment</title>
    <link rel="shortcut icon" href="Images/checkout.png" />
    <link href="CSS/multiple-select.css" rel="stylesheet" />
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
    <script src="script/jquery-1.12.0.min.js"></script>
    <script src="script/jquery.multiple.select.js"></script>
    <script>
        $(document).ready(function () {
            $('select').multipleSelect({
                placeholder: 'please select',
                filter: true,
                single: true
            });
        });
    </script>
</head>
<body style="overflow-y:scroll">
    <form id="form1" runat="server">
        <div style="margin: 50px auto" align="center">
            <asp:ScriptManager ID="ScriptManager1" runat="server">
            </asp:ScriptManager>
            <div class="group" style="display: inline-block;" align="left">
                <h4>Trust Bank Checkout Test Payment</h4>
                <div style="margin: 20px">
                    <b>Marchent Name *</b>
                <br />
                    <asp:DropDownList ID="ddlMarchentType" runat="server" Width="400px"
                        AppendDataBoundItems="True" DataTextField="MarchentName"
                        DataValueField="MarchentID" DataSourceID="SqlDataSource1">
                        <asp:ListItem Value="" Text=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                        ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                        SelectCommand="SELECT [MarchentID], [MarchentName] FROM [Checkout_Marchent] order by MarchentName"></asp:SqlDataSource>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtAmount"
                        ErrorMessage="*" SetFocusOnError="true" ForeColor="Red">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="txtAmount"
                        SetFocusOnError="True" ErrorMessage="Invalid Amount" ForeColor="Red" ValidationExpression="\d*"
                        Display="Dynamic"></asp:RegularExpressionValidator>
                    <br />
                    <br />
                    <b>Customer Name</b><br />
                    <asp:TextBox runat="server" ID="txtName" Text="" placeholder="customer name"
                        Width="400px" MaxLength="255"></asp:TextBox>

                    <br />
                    <br />
                    <b>Customer Email Address</b><br />
                    <asp:TextBox runat="server" ID="txtEmail" Text="" placeholder="email address" Width="400px"
                        MaxLength="255"></asp:TextBox>
                    <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtEmail"
                    ErrorMessage="*" SetFocusOnError="true" ForeColor="Red">
                </asp:RequiredFieldValidator>--%>
                    <asp:RegularExpressionValidator runat="server" ID="regEmail" ControlToValidate="txtEmail"
                        SetFocusOnError="True" ErrorMessage="Invalid Email" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        Display="Dynamic"></asp:RegularExpressionValidator>
                    <br />
                    <br />
                    <b>Amount *</b><br />
                    <asp:TextBox runat="server" ID="txtAmount" Text="" Width="80px" placeholder="0" CssClass="right"></asp:TextBox>
                    <br />
                    <br />
                    
                    <b>Payment Success Url *</b><br />
                    <asp:TextBox runat="server" ID="txtPaymentSuccessUrl" Text="https://ibanking.tblbd.com/TestCheckout/MerchantPaymentConfirmation.aspx" MaxLength="255" Width="400px" placeholder="payment success url"></asp:TextBox>
                    <br />
                    <br />
                    <b>Method</b>
                <br />
                    <asp:DropDownList ID="ddlMethod" runat="server">                        
                        <asp:ListItem Text="POST" Value="POST"></asp:ListItem>
                        <asp:ListItem Text="GET" Value="GET"></asp:ListItem>
                         <asp:ListItem Text="Service" Value="Service"></asp:ListItem>
                    </asp:DropDownList>
                    <br />
                    <br />
                    <asp:Button runat="server" ID="cmdSubmit2" Text="Pay Now" OnClick="cmdSubmit2_Click" Width="120px" Height="35px" />
                    <br />
                    <asp:Label runat="server" ID="lblLabel"></asp:Label>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
