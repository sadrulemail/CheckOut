<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Test Page
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    Test Page1
    <br />
    <asp:Button ID="Button1" runat="server" Text="Button" /><asp:TextBox ID="TextBox1"
        runat="server"></asp:TextBox><asp:DropDownList ID="DropDownList1" runat="server">
        <asp:ListItem>Apple</asp:ListItem>
        <asp:ListItem>Boy</asp:ListItem>
        <asp:ListItem>Girl</asp:ListItem>
        </asp:DropDownList>
    <asp:RadioButtonList CssClass="css-label"  ID="BulletedList1" runat="server">
    <asp:ListItem Text="Test" Selected="True"></asp:ListItem>    
    <asp:ListItem Text="Test1"></asp:ListItem>
    </asp:RadioButtonList>
    <asp:CheckBox ID="CheckBox1"
        runat="server" Text="Test" />
</asp:Content>
