<%@ Page Title="" Language="C#" MasterPageFile="~/TrustBank.Master" AutoEventWireup="true" CodeBehind="Logout.aspx.cs" Inherits="ServiceCube.Logout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    Logged Out 
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="server">
    <asp:Panel ID="PanelStatus" runat="server" CssClass="alert alert-success col-sm-8 col-sm-offset-2 col-md-6 col-md-offset-3" Visible="true">
        <div class="row">
            <div class="col-sm-4">
                <img src="Images/checkout.png" class="img-responsive center-block" width="96" height="96" border="0" />
            </div>
            <div class="col-sm-8">
                You have successfully logged out from <%= ConfigurationManager.AppSettings["AppName"] %>.
                Thank you for being with us.
            </div>
        </div>
        <div class="row">
            <div class="center">
                <a href="Default.aspx" class="btn btn-success">Login Again</a>
            </div>
        </div>
    </asp:Panel>
    <asp:Panel ID="PanelFacebook" runat="server" CssClass="center" Style="margin: 50px 0"
        Visible="true">
        <asp:Literal ID="FB_iFrame" runat="server"></asp:Literal>
        <%--<div class="form-group" style="margin-top:10px;">
                    
                        <button id="cmdCloseWindow" class="btn btn-success" style="width:120px;" formnovalidate >Close</button>
                    

                    <input type="button" value="Close" onclick="window.close()" class="btn btn-success" style="width:120px;" formnovalidate />
                    
                </div>--%>
    </asp:Panel>
</asp:Content>
