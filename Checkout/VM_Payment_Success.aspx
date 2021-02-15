<%@ Page Language="C#" AutoEventWireup="true" CodeFile="VM_Payment_Success.aspx.cs"
    Inherits="VM_Payment_Success" MasterPageFile="~/MasterBootstrap.master" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="head" runat="server" ID="content1">
    <title>Trust Bank Checkout</title>

</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="content2">
    Trust Bank Checkout
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder2" runat="server" ID="content3">
    <div class="row text-center text-warning bold" style="min-height:200px">
        <asp:Label ID="llbStatus" runat="server" Text=""></asp:Label>
    </div>
    
</asp:Content>
