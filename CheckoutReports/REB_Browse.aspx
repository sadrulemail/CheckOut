<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="REB_Browse.aspx.cs" Inherits="REB_Browse" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    REB Browse Data
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:TrustControl ID="AKControl" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Button ID="btnDownload" runat="server" Text="Download as CSV" Visible="false"
                OnClick="btnDownload_Click" CausesValidation="false" />
            <asp:Literal ID="litDownlaod" runat="server"></asp:Literal>
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                CellPadding="4" DataKeyNames="SL" CssClass="Grid" DataSourceID="SqlDataSource1"
                Style="font-size: small" AllowPaging="True" ForeColor="Black" GridLines="Vertical">
                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="Serial" HeaderText="SL" ReadOnly="True" SortExpression="Serial"
                        ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SMSBillNo" HeaderText="SMS Bill No" ReadOnly="True" SortExpression="SMSBillNo" />
                    <asp:BoundField DataField="Book" HeaderText="Book" SortExpression="Book" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="SMSAccountNo" HeaderText="SMS Account No" SortExpression="SMSAccountNo" />
                    <asp:BoundField DataField="BillMonth" HeaderText="Bill<br/>Month" SortExpression="BillMonth"
                        HtmlEncode="false" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BillYear" HeaderText="Bill<br/>Year" SortExpression="BillYear"
                        HtmlEncode="false" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="BilledDate" HeaderText="Bill Date" SortExpression="BilledDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PayDate" HeaderText="Payment Date" SortExpression="PayDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="PayDateWithLPC" HeaderText="Payment Date<br/>(with LPC)"
                        SortExpression="PayDateWithLPC" DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" />
                    <asp:BoundField DataField="AmountWithLPC" HeaderText="Amount<br/>(with LPC)" SortExpression="AmountWithLPC"
                        HtmlEncode="false" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <%--<asp:BoundField DataField="CollectionCode" HeaderText="Collection<br/>Code" 
                        SortExpression="CollectionCode" HtmlEncode="false" 
                        ItemStyle-HorizontalAlign="Right">
                    <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>--%>
                    <%-- <asp:BoundField DataField="CollectionDT" HeaderText="CollectionDT" SortExpression="CollectionDT" DataFormatString="{0:dd/MM/yyyy}" />--%>
                    <asp:BoundField DataField="PaymentAmount" HeaderText="Payment<br/>Amount" SortExpression="PaymentAmount"
                        HtmlEncode="false" ItemStyle-HorizontalAlign="Right">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <AlternatingRowStyle BackColor="White" />
                <EmptyDataTemplate>
                    No Record(s) Found
                </EmptyDataTemplate>
                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_REB_Browse" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="EmpID" SessionField="USERNAME" Type="String" />
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
