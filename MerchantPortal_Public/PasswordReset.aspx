<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="PasswordReset.aspx.cs" Inherits="PasswordReset" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="server">
    Reset User Password
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div align="left" style="padding: 30px;">
                <div style="display: inline-block" class="Panel1">
                    <table>
                        <tr>
                            <td>
                                Username:
                            </td>
                            <td>
                                <asp:TextBox ID="txtUserName" Text="" Width="200px" MaxLength="20" runat="server"
                                    onfocus="this.select()"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtUserName"
                                    ErrorMessage="*"></asp:RequiredFieldValidator>
                            </td>
                            <td>
                                <asp:Button ID="cmdReset" runat="server" Text="Reset Password" OnClick="cmdReset_Click"
                                    Width="150px" />
                                <asp:ConfirmButtonExtender ID="cmdReset_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Rest Password?"
                                    Enabled="True" TargetControlID="cmdReset">
                                </asp:ConfirmButtonExtender>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </ContentTemplate>
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
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
        ProviderName="<%$ ConnectionStrings:MainConnectionString.ProviderName %>" SelectCommand="s_password_reset"
        SelectCommandType="StoredProcedure" OnSelected="SqlDataSource1_Selected" OnSelecting="SqlDataSource1_Selecting">
        <SelectParameters>
            <asp:ControlParameter ControlID="txtUserName" Name="UserName" PropertyName="Text"
                DefaultValue="" Type="String" />
            <asp:SessionParameter Name="ModifyBy" SessionField="USERNAME" Type="String" DefaultValue="" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
