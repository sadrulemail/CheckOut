<%@ Page Language="C#" AutoEventWireup="true" CodeFile="BVRSCardStatus.aspx.cs" Inherits="BVRSCardStatus" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:Button ID="Button1" runat="server" Text="Login" onclick="Button1_Click" />
        <asp:Label ID="Label2" runat="server" Text="Label"></asp:Label>
        <br />
        <br />
        <br />
       
        Code:<asp:TextBox ID="TextBox1" runat="server" Text="1" Width="100px"></asp:TextBox>
         <br />
        <br />
        Delivery Type: <asp:DropDownList ID="ddlType" runat="server" AppendDataBoundItems="true" DataTextField="BranchName"
                                                    DataValueField="BranchID"  
                                                    AutoPostBack="false">
                                                    <asp:ListItem Text="Select Type" Value=""></asp:ListItem>
                                                    <asp:ListItem Value="REGULAR" Text="REGULAR"></asp:ListItem>
                                                    <asp:ListItem Value="URGENT" Text="URGENT"></asp:ListItem>
                                                   
                                                </asp:DropDownList>
         <br />
         
        <br />
        NID No:<asp:TextBox ID="txtNID" runat="server" Text="19908718694000254" Width="200px"></asp:TextBox>
        <asp:Button ID="Button2" runat="server" Text="Check" onclick="Button2_Click" />
        
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
        <br />
        <br />
          <asp:Button ID="btnBulkTransaction" runat="server" Text="Transaction" 
            onclick="btnBulkTransaction_Click" />
         <br />
        <br />
        <asp:Button ID="Button3" runat="server" Text="Log Out" 
            onclick="Button3_Click" />

          <br />
        <br />
        <asp:Button ID="btnPassChange" runat="server" Text="Pass Change" Enabled="False" OnClick="btnPassChange_Click" 
             />
        <asp:Label ID="Label3" runat="server" Text="Label"></asp:Label>
        <br />
        <br />
        <asp:Label ID="lblTransactionStatus" runat="server" Text="Label"></asp:Label>
    </div>
    </form>
</body>
</html>
