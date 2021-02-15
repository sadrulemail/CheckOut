<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Simple.Master" AutoEventWireup="true"
    CodeFile="REB_ShowBatch.aspx.cs" Inherits="REB_ShowBatch" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    <asp:Literal ID="lilTitle" Text="Show Data of REB" runat="server"></asp:Literal>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:TrustControl ID="AKControl" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <%--<table>
                <tr>
                    <td>
                        <table class="SmallFont ui-corner-all Panel1">
                            <tr>
                                <td style="padding-left: 5px">
                                    Batch No:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtBatch" runat="server" onfocus="this.select()" Width="80px" Style="text-align: center"></asp:TextBox>
                                </td>
                                <td style="padding: 0px 5px 0px 5px">
                                    <asp:Button ID="cmdShow" runat="server" Text="Show" OnClick="cmdShow_Click" />
                                </td>
                        </table>
                    </td>
                </tr>
            </table>
            <br />--%>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                CellPadding="4" DataKeyNames="SL" CssClass="Grid" DataSourceID="SqlDataSource1"
                Style="font-size: small" AllowPaging="True" ForeColor="Black" GridLines="Vertical">
                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="SL" HeaderText="SL" ReadOnly="True" SortExpression="SL" />
                    <asp:BoundField DataField="SMSBillNo" HeaderText="SMS Bill No" ReadOnly="True" SortExpression="SMSBillNo" />
                    <asp:BoundField DataField="Book" HeaderText="Book" SortExpression="Book" />
                    <asp:BoundField DataField="SMSAccountNo" HeaderText="SMS A/C Number" SortExpression="SMSAccountNo" />
                    <asp:BoundField DataField="BillMonth" HeaderText="Bill Month" SortExpression="BillMonth" />
                    <asp:BoundField DataField="BillYear" HeaderText="Bill Year" SortExpression="BillYear" />
                    <asp:BoundField DataField="BilledDate" HeaderText="Billed Date" SortExpression="BilledDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="PayDate" HeaderText="Payment Date" SortExpression="PayDate"
                        DataFormatString="{0:dd/MM/yyyy}" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right">
                    </asp:BoundField>
                    <asp:BoundField DataField="PayDateWithLPC" HeaderText="Pay Date<br>(with LPC)" SortExpression="PayDateWithLPC"
                        DataFormatString="{0:dd/MM/yyyy}" HtmlEncode="false" />
                    <asp:BoundField DataField="AmountWithLPC" HeaderText="Amount<br>(with LPC)" SortExpression="AmountWithLPC"
                        ItemStyle-HorizontalAlign="Right" HtmlEncode="false" />
                    <%--<asp:BoundField DataField="Paid" HeaderText="Status" SortExpression="Paid" />--%>
                    <asp:CheckBoxField DataField="Paid" HeaderText="Status" SortExpression="Paid" />
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
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_REB_Upload_Batch" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:QueryStringParameter Name="Batch" DbType="Int16" Direction="Input" QueryStringField="batch"
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
