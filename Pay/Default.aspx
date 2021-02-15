<%@ Page Title="" Language="C#" MasterPageFile="MasterPay.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="Pay_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Trust Bank Checkout
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <div class="row text-center" style="min-height: 150px">
        <p>Welcome to Trust Bank Checkout Payment Portal.</p>
        <p>Please select payment type you want to pay.</p>
        <div style="padding:50px" align="center">
            <img src="../Images/checkout.png" width="150" height="150" alt="Checkout" class="img-responsive" />
        </div>
    </div>
</asp:Content>

