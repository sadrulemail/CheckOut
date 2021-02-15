<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Titas_Reconciliation.aspx.cs" Inherits="Titas_Reconciliation" Title="Untitled Page" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%--<%@ Register Src="MyControl.ascx" TagName="MyControl" TagPrefix="uc3" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .Grid {
            font-size: 90%;
            font-stretch: Condensed;
        }

        .ajax__tab_body {
            min-height: 400px;
            font-family: Arial;
        }

        .ajax__tab_tab {
            min-width: 150px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Titas Reconciliation
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <%-- <uc3:MyControl ID="MyControl1" runat="server" />--%>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:HiddenField ID="hidPageID" runat="server" />

            <asp:TabContainer runat="server" ID="TabCon1" OnDemand="true">
                <asp:TabPanel runat="server" ID="tab1">
                    <HeaderTemplate>Non-Metered</HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <table class="Panel1">
                                        <tr>
                                            <td class="bold">Date:
                                            </td>
                                            <td style="padding-left: 5px;">
                                                <asp:TextBox ID="txtDateFrom" runat="server" Width="80px"
                                                    CssClass="Date bold" Enabled="false" ReadOnly="true"></asp:TextBox>
                                            </td>
                                            <td class="bold">Branch:</td>
                                            <td>
                                                <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="True" AutoPostBack="false"
                                                    DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BEFTN_Code"
                                                    OnDataBound="cboBranch_DataBound">
                                                    <asp:ListItem Text="" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                                    SelectCommand="SELECT BEFTN_Code, BranchName FROM [ViewBranch] with (nolock) ORDER BY [BranchName]"></asp:SqlDataSource>
                                            </td>
                                            <td class="bold">Type:</td>
                                            <td>
                                                <asp:DropDownList ID="cboType" runat="server" AutoPostBack="false">
                                                    <asp:ListItem Text="Payment Entry" Value="1"></asp:ListItem>
                                                    <asp:ListItem Text="Installment" Value="4" Enabled="false"></asp:ListItem>
                                                    <asp:ListItem Text="Demand Note" Value="7"></asp:ListItem>
                                                </asp:DropDownList>

                                            </td>
                                            <td>
                                                <asp:Button ID="cmdReconciliation_M" runat="server"
                                                    Text="Generate"
                                                    OnClick="cmdReconciliation_NM_Click"
                                                    Visible="true" /></td>

                                        </tr>
                                    </table>
                                </td>
                                <td class="bold">
                                    <div style="color: gray; padding: 5px; font-family: 'Courier New'">
                                        <asp:Literal ID="lblMsg" runat="server" Text=""></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel runat="server" ID="Panel_NM">

                            <%--<asp:ObjectDataSource ID="ObjectDataSourceWasaReconciliation" runat="server" DeleteMethod="Delete"
                                InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData"
                                TypeName="BillsDataSetTableAdapters.Wasa_ReconciliationTableAdapter" UpdateMethod="Update">
                                <DeleteParameters>
                                    <asp:Parameter Name="Original_ID" Type="Int64" />
                                </DeleteParameters>
                                <UpdateParameters>
                                    <asp:Parameter Name="TRANS_DT" Type="DateTime" />
                                    <asp:Parameter Name="BILL_NO" Type="String" />
                                    <asp:Parameter Name="ACCOUNT_NO" Type="String" />
                                    <asp:Parameter Name="WATER_BILL" Type="Decimal" />
                                    <asp:Parameter Name="SEWER_BILL" Type="Decimal" />
                                    <asp:Parameter Name="VAT" Type="Decimal" />
                                    <asp:Parameter Name="FIXED_CHARGE" Type="Decimal" />
                                    <asp:Parameter Name="SUR_CHARGE" Type="Decimal" />
                                    <asp:Parameter Name="TOTAL_BILL" Type="Decimal" />
                                    <asp:Parameter Name="COLLECTED_AMT" Type="Decimal" />
                                    <asp:Parameter Name="EmpID" Type="String" />
                                    <asp:Parameter Name="InsertDT" Type="DateTime" />
                                    <asp:Parameter Name="SessionID" Type="String" />
                                    <asp:Parameter Name="BR_ID" Type="String" />
                                    <asp:Parameter Name="Original_ID" Type="Int64" />
                                </UpdateParameters>
                                <SelectParameters>
                                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                    <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                        Type="String" />
                                </SelectParameters>
                                <InsertParameters>
                                    <asp:Parameter Name="TRANS_DT" Type="DateTime" />
                                    <asp:Parameter Name="BILL_NO" Type="String" />
                                    <asp:Parameter Name="ACCOUNT_NO" Type="String" />
                                    <asp:Parameter Name="WATER_BILL" Type="Decimal" />
                                    <asp:Parameter Name="SEWER_BILL" Type="Decimal" />
                                    <asp:Parameter Name="VAT" Type="Decimal" />
                                    <asp:Parameter Name="FIXED_CHARGE" Type="Decimal" />
                                    <asp:Parameter Name="SUR_CHARGE" Type="Decimal" />
                                    <asp:Parameter Name="TOTAL_BILL" Type="Decimal" />
                                    <asp:Parameter Name="COLLECTED_AMT" Type="Decimal" />
                                    <asp:Parameter Name="EmpID" Type="String" />
                                    <asp:Parameter Name="InsertDT" Type="DateTime" />
                                    <asp:Parameter Name="SessionID" Type="String" />
                                    <asp:Parameter Name="BR_ID" Type="String" />
                                </InsertParameters>
                            </asp:ObjectDataSource>--%>
                            <br />
                            <asp:Panel ID="PanelReconciliationReport" runat="server" Visible="false">
                                <div class="group">
                                    <h4>Extra Paid Marked at TBL End</h4>
                                    <div class="group-body">
                                        <asp:GridView ID="GridView1" runat="server" BackColor="White" AutoGenerateColumns="false"
                                            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" AllowPaging="true"
                                            AllowSorting="true" ForeColor="Black" DataSourceID="SqlDataSource1_Reconciliation_TBL"
                                            PageSize="50" GridLines="Vertical" CssClass="Grid" PagerSettings-PageButtonCount="30">
                                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                            <Columns>
                                                <asp:TemplateField HeaderText="RefID" SortExpression="RefID" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <a href='Checkout_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank"><%# Eval("RefID") %></a>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Transaction ID" SortExpression="BankTransactionID">
                                                    <ItemTemplate>
                                                        <%# Eval("BankTransactionID") %>
                                                    </ItemTemplate>
                                                    <ItemStyle Wrap="false" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Emp ID" SortExpression="InsertBy">

                                                    <ItemTemplate>
                                                        <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="BranchCode" HeaderText="Branch ID" SortExpression="BranchCode"
                                                    ItemStyle-HorizontalAlign="Center">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:TemplateField HeaderText="Paid DT" SortExpression="PaidDT">
                                                    <ItemTemplate>
                                                        <span title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime(Eval("PaidDT")) %></span>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                                </asp:TemplateField>
                                                <asp:BoundField DataField="CustomerName" HeaderText="CustomerName" SortExpression="CustomerName" />
                                                <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" SortExpression="CustomerCode" />
                                                <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" SortExpression="InvoiceNo" />
                                                <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" SortExpression="PaymentID" />
                                                <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" HtmlEncode="false"
                                                    SortExpression="TotalAmount"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle Font-Bold="true" HorizontalAlign="Right" />
                                                </asp:BoundField>

                                                <asp:BoundField DataField="Amount" HeaderText="Amount" HtmlEncode="false"
                                                    SortExpression="Amount"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="SurCharge" HeaderText="Surcharge" HtmlEncode="false"
                                                    SortExpression="SurCharge"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>


                                                <asp:BoundField DataField="RevStamp" HeaderText="Rev. Stamp" SortExpression="RevStamp"
                                                    DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right"></asp:BoundField>


                                                <asp:BoundField DataField="ZoneName" HeaderText="Zone Name" SortExpression="ZoneName"
                                                    ItemStyle-HorizontalAlign="Center">
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="CustomerMobile" HeaderText="Mobile" SortExpression="CustomerMobile" />

                                            </Columns>
                                            <EmptyDataTemplate>
                                                Data is OK, No Reconciliation Needed.
                                            </EmptyDataTemplate>
                                            <FooterStyle BackColor="#CCCC99" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <AlternatingRowStyle BackColor="White" />
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="SqlDataSource1_Reconciliation_TBL" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                            SelectCommand="s_Titas_Reconciliation_TBL" SelectCommandType="StoredProcedure"
                                            OnSelected="SqlDataSource1_Reconciliation_Selected">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />

                                                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                                <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="cboBranch" Name="BranchIDIN" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="cboType" Name="Type" PropertyName="SelectedValue"
                                                    Type="String" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <div>
                                            <asp:Label ID="lblStatusTBL" runat="server" Text=""></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="group">
                                    <h4>Extra Paid Marked at TITAS End</h4>
                                    <div class="group-body">
                                        <asp:GridView ID="GridView2" runat="server" BackColor="White" AutoGenerateColumns="false"
                                            BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" AllowPaging="true"
                                            AllowSorting="true" ForeColor="Black" DataSourceID="SqlDataSource2_Reconciliation"
                                            PageSize="50" GridLines="Vertical" CssClass="Grid" PagerSettings-PageButtonCount="30">
                                            <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                            <Columns>
                                                <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" SortExpression="PaymentID" />
                                                <asp:BoundField DataField="BatchNo" HeaderText="Batch No" SortExpression="BatchNo" />
                                                <asp:TemplateField HeaderText="Transaction ID" SortExpression="BankTransactionID">
                                                    <ItemTemplate>
                                                        <%# Eval("BankTransactionID") %>
                                                    </ItemTemplate>
                                                    <ItemStyle Wrap="false" />
                                                </asp:TemplateField>

                                                <asp:TemplateField HeaderText="VoucherDate" SortExpression="VoucherDate">
                                                    <ItemTemplate>
                                                        <%# Eval("VoucherDate","{0:dd/MM/yyyy}") %>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                                </asp:TemplateField>

                                                <asp:BoundField DataField="Particulars" HeaderText="Particulars" SortExpression="Particulars" />
                                                <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" HtmlEncode="false"
                                                    SortExpression="TotalAmount"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle Font-Bold="true" HorizontalAlign="Right" />
                                                </asp:BoundField>

                                                <asp:BoundField DataField="Amount" HeaderText="Amount" HtmlEncode="false"
                                                    SortExpression="Amount"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="SurCharge" HeaderText="Surcharge" HtmlEncode="false"
                                                    SortExpression="SurCharge"
                                                    DataFormatString="{0:N2}">
                                                    <ItemStyle HorizontalAlign="Right" />
                                                </asp:BoundField>




                                            </Columns>
                                            <EmptyDataTemplate>
                                                Data is OK, No Reconciliation Needed.
                                            </EmptyDataTemplate>
                                            <FooterStyle BackColor="#CCCC99" />
                                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                            <AlternatingRowStyle BackColor="White" />
                                        </asp:GridView>
                                        <asp:SqlDataSource ID="SqlDataSource2_Reconciliation" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                            SelectCommand="s_Titas_Reconciliation_Titas" SelectCommandType="StoredProcedure"
                                            OnSelected="SqlDataSource2_Reconciliation_Selected">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />
                                                <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                                <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="cboBranch" Name="BranchIDIN" PropertyName="SelectedValue"
                                                    Type="String" />
                                                <asp:ControlParameter ControlID="cboType" Name="Type" PropertyName="SelectedValue"
                                                    Type="String" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                        <div>
                                            <asp:Label ID="lblStatusTitas" runat="server" Text=""></asp:Label>
                                        </div>
                                    </div>
                                </div>
                                <div class="group hidden">
                                    <h4>Reconciliation Compare (Summary)</h4>
                                    <asp:GridView ID="GridViewCompare" runat="server" BackColor="White" AutoGenerateColumns="false"
                                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" AllowPaging="true"
                                        AllowSorting="true" ForeColor="Black" DataSourceID="SqlDataSource4_Reconciliation_Compare"
                                        PageSize="10" GridLines="Vertical" CssClass="Grid" PagerSettings-PageButtonCount="30" Visible="false">
                                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" HorizontalAlign="Right" />
                                        <Columns>
                                            <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Left" />
                                            <asp:BoundField DataField="Total" HeaderText="Total" SortExpression="Total" DataFormatString="{0:N0}" />
                                            <asp:BoundField DataField="WATER_BILL" HeaderText="Water Bill" SortExpression="WATER_BILL"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Sewer_Charge" HeaderText="Sewer Charge" SortExpression="Sewer_Charge"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Water_Sewer" HeaderText="Revenue_Amount (Water+Sewer)"
                                                SortExpression="Water_Sewer" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="SUR_CHARGE" HeaderText="Sur Charge" SortExpression="SUR_CHARGE"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Vat" HeaderText="Vat Amount" SortExpression="Vat" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="FIXED_CHARGE" HeaderText="Fixed Charge" SortExpression="FIXED_CHARGE"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="TOTAL_BILL" HeaderText="Total Bill" SortExpression="TOTAL_BILL"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="COLLECTED_AMT" HeaderText="Collected Amount" SortExpression="COLLECTED_AMT"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="RevStamp" HeaderText="Rev Stamp" SortExpression="RevStamp"
                                                DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="AmountExceptStamp" HeaderText="Amount_Except_Stamp" SortExpression="AmountExceptStamp"
                                                DataFormatString="{0:N2}" />
                                        </Columns>
                                        <EmptyDataTemplate>
                                            No Data Found
                                        </EmptyDataTemplate>
                                        <FooterStyle BackColor="#CCCC99" />
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                        <AlternatingRowStyle BackColor="White" />
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource4_Reconciliation_Compare" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Titas_Reconciliation_Compare" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />

                                            <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                            <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                Type="String" />
                                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                            <asp:ControlParameter ControlID="cboBranch" Name="BranchIDIN" PropertyName="SelectedValue"
                                                Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <div>
                                        <asp:Label ID="lblReconciliationDetails" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                                <div class="group hidden">
                                    <h4>Reconciliation Compare (Mismatch Items)</h4>
                                    <asp:GridView ID="GridViewReconDetails" runat="server" AllowPaging="false" AllowSorting="True"
                                        CssClass="Grid" PagerSettings-Mode="NumericFirstLast" PagerSettings-Position="TopAndBottom"
                                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                                        BorderWidth="1px" CellPadding="4" DataSourceID="SqlDataSource1" ForeColor="Black"
                                        Style="font-size: small" OnDataBound="GridView1_DataBound" Visible="false">
                                        <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" />
                                        <RowStyle BackColor="#F7F7DE" HorizontalAlign="Right" VerticalAlign="Top" />
                                        <Columns>
                                            <asp:BoundField DataField="Bill_No" HeaderText="Bill_No" SortExpression="Bill_No"
                                                ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="TRANS_DT" HeaderText="Trans_DT" SortExpression="TRANS_DT" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="BranchID" HeaderText="BranchID" SortExpression="BranchID" ItemStyle-Wrap="false" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="BR_ID" HeaderText="BR_ID" SortExpression="BR_ID" />
                                            <asp:BoundField DataField="TransactionID" HeaderText="TransactionID" SortExpression="TransactionID" ItemStyle-Wrap="false" />
                                            <asp:BoundField DataField="Bills_Revenue_Amount" HeaderText="Bills_Revenue_Amount" SortExpression="Bills_Revenue_Amount" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Bills_Vat_Amount" HeaderText="Bills_Vat_Amount" SortExpression="Bills_Vat_Amount" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Bills_Sur_Charge" HeaderText="Bills_Sur_Charge" SortExpression="Bills_Sur_Charge" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Bills_Fixed_Charge" HeaderText="Bills_Fixed_Charge" SortExpression="Bills_Fixed_Charge" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Wasa_Revenue_Amount" HeaderText="Wasa_Revenue_Amount" SortExpression="Wasa_Revenue_Amount" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Wasa_Vat_Amount" HeaderText="Wasa_Vat_Amount" SortExpression="Wasa_Vat_Amount" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Wasa_Sur_Charge" HeaderText="Wasa_Sur_Charge" SortExpression="Wasa_Sur_Charge" DataFormatString="{0:N2}" />
                                            <asp:BoundField DataField="Wasa_Fixed_Charge" HeaderText="Wasa_Fixed_Charge" SortExpression="Wasa_Fixed_Charge" DataFormatString="{0:N2}" />


                                        </Columns>
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                        <AlternatingRowStyle BackColor="White" />
                                        <EmptyDataTemplate>No Mismatch Found</EmptyDataTemplate>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Titas_Reconciliation_Compare_Details" SelectCommandType="StoredProcedure"
                                        OnSelected="SqlDataSource1_Selected">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />

                                            <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                            <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                Type="String" />
                                            <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                            <asp:ControlParameter ControlID="cboBranch" Name="BranchIDIN" PropertyName="SelectedValue"
                                                Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <div>
                                        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                            </asp:Panel>

                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>
                <asp:TabPanel runat="server" ID="Tab2">
                    <HeaderTemplate>Metered</HeaderTemplate>
                    <ContentTemplate>

                        <table>
                            <tr>
                                <td>
                                    <table class="Panel3">
                                        <tr>
                                            <td class="bold">Date:
                                            </td>
                                            <td style="padding-left: 5px;">
                                                <asp:TextBox ID="txtDateFrom2" runat="server" Width="80px"
                                                    CssClass="Date bold"></asp:TextBox>
                                            </td>
                                            <td class="bold">Branch:</td>
                                            <td>
                                                <asp:DropDownList ID="cboBranch2" runat="server" AppendDataBoundItems="True" AutoPostBack="false"
                                                    DataSourceID="SqlDataSourceBranch2" DataTextField="BranchName" DataValueField="BEFTN_Code"
                                                    OnDataBound="cboBranch2_DataBound">
                                                    <asp:ListItem Text="" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceBranch2" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                                    SelectCommand="SELECT BEFTN_Code, BranchName FROM [ViewBranch] with (nolock) ORDER BY [BranchName]"></asp:SqlDataSource>
                                            </td>

                                            <td>
                                                <asp:Button ID="cmdReconciliation" runat="server"
                                                    Text="Generate"
                                                    OnClick="cmdReconciliation_M_Click"
                                                    Visible="true" />
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="bold">
                                    <div style="color: gray; padding: 5px; font-family: 'Courier New'">
                                        <asp:Literal ID="lblMsg2" runat="server" Text=""></asp:Literal>
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <asp:Panel runat="server" ID="PanelReconciliationReport_M" Visible="false">
                            <div class="group">
                                <h4>Extra Paid Marked at TBL End</h4>
                                <div class="group-body">
                                    <asp:GridView ID="GridView1_M" runat="server" BackColor="White" AutoGenerateColumns="false"
                                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" AllowPaging="true"
                                        AllowSorting="true" ForeColor="Black" DataSourceID="SqlDataSource1_M"
                                        PageSize="50" GridLines="Vertical" CssClass="Grid" PagerSettings-PageButtonCount="30">
                                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="RefID" SortExpression="RefID" ItemStyle-HorizontalAlign="Center">
                                                <ItemTemplate>
                                                    <a href='Checkout_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank"><%# Eval("RefID") %></a>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Transaction ID" SortExpression="BankTransactionID">
                                                <ItemTemplate>
                                                    <%# Eval("BankTransactionID") %>
                                                </ItemTemplate>
                                                <ItemStyle Wrap="false" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Emp ID" SortExpression="InsertBy">

                                                <ItemTemplate>
                                                    <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="BranchCode" HeaderText="Branch ID" SortExpression="BranchCode"
                                                ItemStyle-HorizontalAlign="Center">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Paid DT" SortExpression="PaidDT">
                                                <ItemTemplate>
                                                    <span title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                        <%# TrustControl1.ToRecentDateTime(Eval("PaidDT")) %></span>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="CustomerName" HeaderText="CustomerName" SortExpression="CustomerName" />
                                            <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" SortExpression="CustomerCode" />
                                            <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" SortExpression="InvoiceNo" />

                                            <asp:BoundField DataField="InvoiceAmount" HeaderText="Invoice Amount" HtmlEncode="false"
                                                SortExpression="InvoiceAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle Font-Bold="true" HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="PaidAmount" HeaderText="Paid Amount" HtmlEncode="false"
                                                SortExpression="PaidAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="SourceTaxAmount" HeaderText="AIT/Source Tax" HtmlEncode="false"
                                                SortExpression="SourceTaxAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="RevenueStamp" HeaderText="Rev.Stamp" HtmlEncode="false"
                                                SortExpression="RevenueStamp"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="Zone" HeaderText="Zone" SortExpression="Zone"
                                                ItemStyle-HorizontalAlign="Center">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RoutingNo" HeaderText="Routing" SortExpression="RoutingNo" />

                                        </Columns>
                                        <EmptyDataTemplate>
                                            Data is OK, No Reconciliation Needed.
                                        </EmptyDataTemplate>
                                        <FooterStyle BackColor="#CCCC99" />
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                        <AlternatingRowStyle BackColor="White" />
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource1_M" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Titas_Reconciliation_TBL_M" SelectCommandType="StoredProcedure"
                                        OnSelected="SqlDataSource1_M_Reconciliation_Selected">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="txtDateFrom2" DbType="Date" Name="DateFrom" PropertyName="Text" />

                                            <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                            <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                Type="String" />
                                            <asp:ControlParameter ControlID="cboBranch2" Name="BranchIDIN" PropertyName="SelectedValue"
                                                Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <div>
                                        <asp:Label ID="lblStatusTBL_M" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                            </div>
                            <div class="group">
                                <h4>Extra Paid Marked at TITAS End</h4>
                                <div class="group-body">
                                    <asp:GridView ID="GridView2_M" runat="server" BackColor="White" AutoGenerateColumns="false"
                                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" AllowPaging="true"
                                        AllowSorting="true" ForeColor="Black" DataSourceID="SqlDataSource2_M"
                                        PageSize="50" GridLines="Vertical" CssClass="Grid" PagerSettings-PageButtonCount="30">
                                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                                        <Columns>
                                            <asp:BoundField DataField="CustomerCode" HeaderText="Customer Code" SortExpression="CustomerCode" />
                                            <asp:BoundField DataField="InvoiceNo" HeaderText="Invoice No" SortExpression="InvoiceNo" />

                                            <asp:BoundField DataField="PaymentID" HeaderText="Payment ID" SortExpression="PaymentID" />
                                            <asp:BoundField DataField="InvoiceAmount" HeaderText="Invoice Amount" HtmlEncode="false"
                                                SortExpression="InvoiceAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle Font-Bold="true" HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="PaidAmount" HeaderText="Paid Amount" HtmlEncode="false"
                                                SortExpression="PaidAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="SourceTaxAmount" HeaderText="AIT/Source Tax" HtmlEncode="false"
                                                SortExpression="SourceTaxAmount"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RevenueStamp" HeaderText="Rev.Stamp" HtmlEncode="false"
                                                SortExpression="RevenueStamp"
                                                DataFormatString="{0:N2}">
                                                <ItemStyle HorizontalAlign="Right" />
                                            </asp:BoundField>

                                            <asp:BoundField DataField="Zone" HeaderText="Zone" SortExpression="Zone"
                                                ItemStyle-HorizontalAlign="Center">
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="RoutingNo" HeaderText="Routing" SortExpression="RoutingNo" />

                                        </Columns>
                                        <EmptyDataTemplate>
                                            Data is OK, No Reconciliation Needed.
                                        </EmptyDataTemplate>
                                        <FooterStyle BackColor="#CCCC99" />
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                        <AlternatingRowStyle BackColor="White" />
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource2_M" runat="server"
                                        ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Titas_Reconciliation_Titas_M" SelectCommandType="StoredProcedure"
                                        OnSelected="SqlDataSource2_M_Reconciliation_Selected">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="txtDateFrom2" DbType="Date" Name="DateFrom" PropertyName="Text" />
                                            <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                                            <asp:ControlParameter ControlID="hidPageID" Name="SessionID" PropertyName="Value"
                                                Type="String" />
                                            <asp:ControlParameter ControlID="cboBranch2" Name="BranchIDIN" PropertyName="SelectedValue"
                                                Type="String" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                    <div>
                                        <asp:Label ID="lblStatusTitas_M" runat="server" Text=""></asp:Label>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>
            </asp:TabContainer>
            <div style="padding: 5px;">
                <asp:Label ID="lblStatus" Font-Size="Medium" Font-Bold="true" ForeColor="Blue" runat="server"
                    Text="*** Reconciliation results may not be correct during the transaction hour."></asp:Label>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
