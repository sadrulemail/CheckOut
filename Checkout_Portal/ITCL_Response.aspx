<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="ITCL_Response.aspx.cs" Inherits="ITCL_Response" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Literal ID="litTitle" runat="server"></asp:Literal>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <asp:GridView ID="GridView1" runat="server" AllowPaging="True" AllowSorting="True"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None"
                BorderWidth="1px" CellPadding="4" DataKeyNames="ID" DataSourceID="SqlDataSource1"
                ForeColor="Black" GridLines="Vertical" CssClass="Grid">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:BoundField DataField="TransactionType" HeaderText="Trn Type" SortExpression="TransactionType" />
                    <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"
                        DataFormatString="{0:N2}" />
                    <asp:BoundField DataField="ResponseCode" HeaderText="Response" SortExpression="ResponseCode"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="ResponseDescription" HeaderText="Description" SortExpression="ResponseDescription" />
                    <asp:BoundField DataField="OrderStatus" HeaderText="Order Status" SortExpression="OrderStatus" />
                    <asp:BoundField DataField="ApprovalCode" HeaderText="Approval Code" SortExpression="ApprovalCode"
                        ItemStyle-HorizontalAlign="Center" />
                    <asp:BoundField DataField="PAN" HeaderText="PAN" SortExpression="PAN" />
                    <asp:TemplateField HeaderText="DT" SortExpression="DT">
                        <ItemTemplate>
                            <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("DT"))%>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# Eval("DT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                    <asp:BoundField DataField="OrderDescription" HeaderText="Description" SortExpression="OrderDescription" />
                    <asp:BoundField DataField="AcqFee" HeaderText="Acq Fee" SortExpression="AcqFee" ItemStyle-HorizontalAlign="Right"
                        DataFormatString="{0:N2}" />
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="SELECT * FROM [ITCL_Response] WHERE ([OrderID] = @OrderID) ORDER BY [DT] DESC">
                <SelectParameters>
                    <asp:QueryStringParameter Name="OrderID" QueryStringField="orderid" Type="String" />
                </SelectParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
