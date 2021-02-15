<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Login_Log.aspx.cs" Inherits="Login_Log" %>

<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="server">
    Login Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Timer ID="Timer1" runat="server" OnTick="Timer1_Tick">
            </asp:Timer>
            <asp:GridView ID="GridView1" runat="server" AllowSorting="true" AutoGenerateColumns="False" BorderStyle="None"
                CssClass="Grid" DataKeyNames="ID" DataSourceID="SqlDataSource1" AllowPaging="True"
                BackColor="White" CellPadding="4" PagerSettings-PageButtonCount="30" PagerSettings-Mode="NumericFirstLast"
                PagerSettings-Position="TopAndBottom" PagerStyle-HorizontalAlign="Left" PageSize="20">
                <RowStyle BackColor="#F7F7DE" />
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                        SortExpression="ID" />
                    <asp:BoundField DataField="Username" HeaderText="Username" SortExpression="Username" />
                    <asp:BoundField DataField="LogInDT" HeaderText="LogInDT" SortExpression="LogInDT" />
                    <asp:BoundField DataField="IP" HeaderText="IP" SortExpression="IP" />
                    <asp:BoundField DataField="Browser" HeaderText="Browser" SortExpression="Browser" />
                </Columns>
                <PagerStyle CssClass="PagerStyle" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                SelectCommand="SELECT * FROM [Login_Log] ORDER BY [ID] DESC"></asp:SqlDataSource>
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
