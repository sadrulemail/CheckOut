<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Checkout Reports Home
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="margin: 50px">
                <a href="Passport.aspx">
                    <img src="Images/checkout.png" width="256" height="256" border="0" /></a>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanelAnimationExtender ID="UpdatePanelAnimationExtender2" runat="server"
        TargetControlID="UpdatePanel1">
        <Animations>
    <OnUpdating>
        <Sequence>                       
            <Parallel duration="0">                            
                <EnableAction AnimationTarget="UpdatePanel1" Enabled="false" />                            
            </Parallel>
        </Sequence>
    </OnUpdating>
    <OnUpdated>
        <Sequence>
            <Parallel duration="0">
                <EnableAction AnimationTarget="UpdatePanel1" Enabled="true" />
            </Parallel>                            
        </Sequence>
    </OnUpdated> 
        </Animations>
    </asp:UpdatePanelAnimationExtender>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="200">
        <ProgressTemplate>
            <img alt="" src="Images/processing.gif" style="width: 214px; height: 138px" class="LoadingImage" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="UpdateProgress1"
        UseAnimation="True" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
