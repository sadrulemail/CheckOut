<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="PasswordChange.aspx.cs" Inherits="PasswordChange" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="server">
    Password Change
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div align="left" style="padding: 30px">
                <table>
                    <tr>
                        <td>
                            <img src="Images/password.png" width="200" height="200" border="0" /></imb>
                        </td>
                        <td>
                            <asp:Panel ID="Panel2" runat="server" Visible="true">
                                <table class="Panel1">
                                    <tr>
                                        <td colspan="2" align="center">
                                            <div style="padding-bottom: 20px; padding-top: 20px" id="ErrorDiv" runat="server">
                                                <asp:Label ID="lblErrorMsg" runat="server" ForeColor="Red" Text="Error Message"></asp:Label>
                                            </div>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="padding-left: 50px">
                                            Current Password
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" Width="150px" onfocus="this.select()"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword"
                                                ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="padding-left: 50px">
                                            New Password
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" Width="150px"
                                                onfocus="this.select()"></asp:TextBox>
                                            <asp:PasswordStrength ID="txtNewPassword_PasswordStrength" runat="server" MinimumSymbolCharacters="1"
                                                MinimumUpperCaseCharacters="1" PreferredPasswordLength="6" TargetControlID="txtNewPassword"
                                                TextCssClass="Panel1" HelpHandlePosition="BelowRight">
                                            </asp:PasswordStrength>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNewPassword"
                                                ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="padding-left: 50px">
                                            Re-type New Password
                                        </td>
                                        <td align="left">
                                            <asp:TextBox ID="txtRePassword" runat="server" TextMode="Password" Width="150px"
                                                onfocus="this.select()"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtRePassword"
                                                ErrorMessage="RequiredFieldValidator">*</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            &nbsp;
                                        </td>
                                        <td align="left">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" style="padding-left: 50px;">
                                            <input type="button" value="Cancel" style="width: 80px" onclick="location='Default.aspx'" />
                                        </td>
                                        <td align="left">
                                            <asp:Button ID="cmdChangePassword" runat="server" OnClick="cmdChangePassword_Click"
                                                Width="150px" Text="Change Password" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left">
                                            &nbsp;
                                        </td>
                                        <td align="left">
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="Panel1" runat="server" Visible="False">
                                <table class="Panel1">
                                    <tr>
                                        <td colspan="3">
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="3" style="text-align: center">
                                            <b>Your Password Changed Successfully</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td style="text-align: center">
                                            <input type="button" value="Login Again" style="width: 100px" onclick="location='Default.aspx'" />
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            </div>
            <asp:HiddenField ID="HiddenField1" runat="server" Value="A" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
        SelectCommand="s_password_change" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected">
        <SelectParameters>
            <asp:SessionParameter Name="UserName" SessionField="USERNAME" Type="String" />
            <asp:ControlParameter ControlID="txtPassword" Name="PasswordOld" PropertyName="Text"
                Type="String" />
            <asp:ControlParameter ControlID="txtNewPassword" Name="PasswordNew" PropertyName="Text"
                Type="String" />
            <asp:Parameter Size="255" Direction="InputOutput" Name="Msg" Type="String" DefaultValue="                       " />
        </SelectParameters>
    </asp:SqlDataSource>
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
