<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Simple.Master" AutoEventWireup="true"
    CodeFile="Login.aspx.cs" Inherits="AK_Login" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Login
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin-bottom: 20px">
                <img src="Images/checkout.png" width="100" height="100" />
            </div>
            <table class="Panel1">
                <tr>
                    <td colspan="2" align="center">
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td align="left" style="padding: 0 15px 0 30px; font-size: small; font-weight: bolder;">
                        Username
                    </td>
                    <td align="left" style="padding-right: 30px">
                        <asp:TextBox ID="txtUserName" runat="server" Width="170px" onfocus="select()" CssClass="TextBox"
                            Font-Size="100%"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUserName"
                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td align="left" style="padding-left: 30px; font-size: small; font-weight: bolder">
                        Password
                    </td>
                    <td align="left">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="170px" onfocus="select()"
                            CssClass="TextBox" Font-Size="100%"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtPassword"
                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                    </td>
                </tr>
                <!--
                    <tr>
                        <td align="left">
                            &nbsp;</td>
                        <td align="left" class="style1">
                            <asp:CheckBox ID="chkRemember" runat="server" style="font-size: small" 
                                Text="Remember my password" ForeColor="#333333"  />
                        </td>
                    </tr>
                    -->
                <tr>
                    <td align="left" colspan="2" style="text-align: center">
                        &nbsp;
                        <asp:Panel ID="Panel1" runat="server" Style="padding-bottom: 20px" Visible="false">
                            <asp:Label ID="Label1" runat="server" ForeColor="Red" Text=""></asp:Label>
                        </asp:Panel>
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left" class="style1">
                        <asp:Button ID="cmdLogin" runat="server" OnClick="cmdLogin_Click" Text="Login" Width="100px" />
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        &nbsp;
                    </td>
                    <td align="left" class="style1">
                        &nbsp;
                    </td>
                </tr>
            </table>
            <br />
            <br />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="cmdLogin" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground">
            </div>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
