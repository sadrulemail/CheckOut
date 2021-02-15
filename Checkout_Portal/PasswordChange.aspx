<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="PasswordChange.aspx.cs" Inherits="Default2" Title="Password Change" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<%@ Register src="TrustControl.ascx" tagname="TrustControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <uc1:TrustControl ID="TrustControl1" runat="server" />
        Password Change
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <div align="left" style="padding:20px">
    <asp:Panel ID="Panel2" runat="server" Visible="true">
        <table style="width:400px;" class="ui-corner-all Panel1">
            <tr>
                <td colspan="2" align="center">
                    <div style="padding-bottom:20px;padding-top:20px" id="ErrorDiv" runat="server">
                        <asp:Label ID="lblErrorMsg" runat="server" ForeColor="Red" Text="Error Message"></asp:Label>
                    </div>&nbsp;
                </td>
            </tr>
            <tr>
                <td align="left" style="padding-left:50px">
                    Current Password</td>
                <td align="left">
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                        ControlToValidate="txtPassword" ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="left" style="padding-left:50px">
                    New
                    Password</td>
                <td align="left">
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                    <cc1:PasswordStrength ID="txtNewPassword_PasswordStrength" runat="server" 
                        MinimumSymbolCharacters="1" MinimumUpperCaseCharacters="1"  
                        PreferredPasswordLength="6" TargetControlID="txtNewPassword" 
                        TextCssClass="Panel1" HelpHandlePosition="BelowRight">
                    </cc1:PasswordStrength>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                        ControlToValidate="txtNewPassword" ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="left" style="padding-left:50px">
                    Re-type New Password</td>
                <td align="left">
                    <asp:TextBox ID="txtRePassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
                        ControlToValidate="txtRePassword" ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="left">
                    &nbsp;</td>
                <td align="left">
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="left" style="padding-left:50px;">
                    <input type="button" value="Cancel" style="width:80px" onclick="location='Default.aspx'" />
                </td>
                <td align="left">
                    <asp:Button ID="cmdChangePassword" runat="server" onclick="cmdChangePassword_Click" 
                        Text="Change Password" Width="150px" />
                </td>
            </tr>
            <tr>
                <td align="left">
                    &nbsp;</td>
                <td align="left">
                    &nbsp;</td>
            </tr>
        </table>
        </asp:Panel>
        <br />
        <asp:Panel ID="Panel1" runat="server" Visible="False">
            <table style="width:400px;" class="ui-corner-all Panel1">
                <tr>
                    <td colspan="3">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3" align="center" >
                        <b>Password Changed Successfully</b></td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td class="centertext">
                        <asp:Button runat="server" ID="cmdLogingAgain" style="width:130px" 
                            Text="OK" CausesValidation="false" onclick="cmdLogingAgain_Click" />
                    </td>
                    <td>
                        &nbsp;</td>
                </tr>
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>
            </table>
        </asp:Panel>
    </div>
</asp:Content>

