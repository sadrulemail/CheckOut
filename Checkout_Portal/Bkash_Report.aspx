<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Bkash_Report.aspx.cs" Inherits="Bkash_Report" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    bKash Notifications Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td class="Panel1">
                            <table>
                                <tr>
                                    <td>
                                        <b>Transaction Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateTran" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                             CssClass="Date"></asp:TextBox>
                                    </td>
                                  
                                    <td>
                                        <b>Trace No:</b>
                                    </td>
                                    <td>
                                       <asp:TextBox ID="txtTraceNo" MaxLength="200" Width="350px" placeholder="traceNo, traceNo, traceNo" runat="server"></asp:TextBox>
                                    </td>
                               
                                    <td style="padding-left: 10px">
                                        <asp:Button ID="cmdOK" runat="server" Text="Show" OnClick="cmdOK_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                                ToolTip="Previous Day" CssClass="button-round"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                            <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
              
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_s_Bkash_Report" PageSize="20" AllowSorting="true"
                    CellPadding="4"  ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" OnDataBound="GridView1_DataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                    
                        <asp:BoundField DataField="TraceNo" HeaderText="Trace No" ReadOnly="True" SortExpression="TraceNo"/>
                        <asp:BoundField DataField="TransactionDate" HeaderText="TransactionDate" SortExpression="Transaction Date"
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                         <asp:BoundField DataField="TransactionParticulars" HeaderText="Transaction Particulars" SortExpression="TransactionParticulars" />
                     
                        <asp:BoundField DataField="AmountTk" HeaderText="AmountTk" SortExpression="AmountTk"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                         <asp:BoundField DataField="Remarks" HeaderText="Remarks" SortExpression="Remarks" />
                       
                        <asp:BoundField DataField="TBL_Status" HeaderText="TBL_Status" SortExpression="TBL_Status" ItemStyle-HorizontalAlign="Center" />
                         <asp:BoundField DataField="TBL_StatusName" HeaderText="TBL_StatusName" SortExpression="TBL_StatusName" ItemStyle-HorizontalAlign="Center" />
                         <asp:BoundField DataField="bKash_Response" HeaderText="bKash_Response" SortExpression="bKash_Response" ItemStyle-HorizontalAlign="Center" />
                         <asp:BoundField DataField="bKash_ResponseName" HeaderText="bKash_ResponseName" SortExpression="bKash_ResponseName" ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_s_Bkash_Report" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_APIBaseTransactionNotifications" SelectCommandType="StoredProcedure"
                    >
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateTran" DbType="Date" Name="TrnDate"
                            DefaultValue="1/1/1900" />
                     <asp:ControlParameter ControlID="txtTraceNo"  Name="TraceNos"
                            DefaultValue="*" />
              
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="margin-top: 10px">
                <asp:Button ID="cmdExport" runat="server" Text="Export as XLSX" OnClick="cmdExport_Click"
                    Width="150px" />
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
        </Triggers>
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
