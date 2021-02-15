<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Simple.Master" AutoEventWireup="true"
    CodeFile="REB_Download_Batch.aspx.cs" Inherits="REB_Download_Batch" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    <asp:Literal ID="lilTitle" Text="Show Payment Data of REB" runat="server"></asp:Literal>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:TrustControl ID="AKControl" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                Visible="false" AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" DataKeyNames="SL" CssClass="Grid" DataSourceID="SqlDataSource1"
                Style="font-size: small" AllowPaging="True" ForeColor="Black" 
                GridLines="Vertical" ondatabound="GridView1_DataBound">
                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="SL" HeaderText="SL" ReadOnly="True" SortExpression="SL" />
                    <asp:BoundField DataField="SMSBillNo" HeaderText="SMS Bill No" ReadOnly="True" SortExpression="SMSBillNo" />
                    <asp:BoundField DataField="Book" HeaderText="Book" SortExpression="Book" />
                    <asp:BoundField DataField="SMSAccountNo" HeaderText="SMS A/C Number" SortExpression="SMSAccountNo" />
                    <asp:BoundField DataField="BillMonth" HeaderText="Bill Month" SortExpression="BillMonth" />
                    <asp:BoundField DataField="BillYear" HeaderText="Bill Year" SortExpression="BillYear" />
                    <asp:BoundField DataField="BilledDate" HeaderText="Bill Date" SortExpression="BilledDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PayDate" HeaderText="Payment Date" SortExpression="PayDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right">
                    </asp:BoundField>
                    <asp:BoundField DataField="PayDateWithLPC" HeaderText="Pay Date <br>(with LPC)" SortExpression="PayDateWithLPC"
                        DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" />
                    <asp:BoundField DataField="AmountWithLPC" HeaderText="Amount <br>(with LPC)" HtmlEncode="false"
                        SortExpression="AmountWithLPC" ItemStyle-HorizontalAlign="Right" />
                    <asp:BoundField DataField="PaymentDate" HeaderText="Payment Date" HtmlEncode="false"
                        SortExpression="PaymentDate" DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PaymentAmount" HeaderText="Payment <br>Amount" HtmlEncode="false"
                        SortExpression="PaymentAmount" DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    No Record Found
                </EmptyDataTemplate>
                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />
            </asp:GridView>
            <br />
            <asp:Literal ID="litDownlaod" runat="server" Visible="true"></asp:Literal>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_REB_Download_Batch_Show" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="DownloadBatch" DbType="Int16" Direction="Input" QueryStringField="batch"
                        DefaultValue="-1" />
                    <asp:QueryStringParameter Name="keycode" QueryStringField="keycode" DefaultValue="" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <%--<div class="TransparentGrayBackground">
            </div>--%>
            <asp:Image ID="WaitImage1" runat="server" alt="" ImageUrl="~/Images/processing.gif"
                CssClass="LoadingImage" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="WaitImage1"
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
