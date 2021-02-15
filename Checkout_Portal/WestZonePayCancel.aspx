<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="WestZonePayCancel.aspx.cs" Inherits="WestZonePayCancel" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="West Zone Payment Cancel"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="Panel1">
                             <tr>
                                <td>Ref ID: </td>
                                <td>
                                    <asp:Label ID="lblRefId" runat="server" Text="Label"></asp:Label>
                                </td>
                                </tr>
                            <tr>
                                <td>Transaction ID: </td>
                                <td>
                                    <asp:Label ID="labelTransId" runat="server" Text="Label"></asp:Label>
                                </td>
                                </tr>
                            <tr>
                                <td>Cancel Reason: </td>
                                 <td>
                                     <asp:TextBox ID="txtReason" ToolTip="Cancel reason" Width="400px" runat="server"></asp:TextBox>
                                    
                                   
                                </td>
                                </tr>
                            <tr>
                                <td>
                                    <asp:Button ID="cmdOK" runat="server" OnClick="cmdOK_Click" Text="Payment Cancel" />
                                       <asp:RequiredFieldValidator ID="rfvCancelReason" ControlToValidate="txtReason"
                                        runat="server" SetFocusOnError="true"  Display="Dynamic"
                                        ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                                     <asp:ConfirmButtonExtender ID="cmdOK_ConfirmButtonExtender" runat="server"
                                    ConfirmText="Do you want to Cancel the Payment?" Enabled="True"
                                    TargetControlID="cmdOK"></asp:ConfirmButtonExtender>
                                </td>
                               
                            </tr>
                        </table>
                    </td>
                   

                </tr>
            </table>
         
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
</asp:Content>
