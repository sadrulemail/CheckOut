<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="BtclPayReport.aspx.cs" Inherits="BtclPayReport1" Culture="en-NZ" %>

<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="Branch.ascx" TagName="Branch" TagPrefix="uc3" %>
<%@ Register src="TrustControl.ascx" tagname="TrustControl" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Date wise BTCL Payment Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <uc1:TrustControl ID="TrustControl1" runat="server" />
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <table class="Panel1">
                                <tr>
                                  
                                    <td style="padding-left: 10px; white-space: nowrap">
                                        <b>
                                        
                                        
                                        
                                        Payment Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="true" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>
                                        to
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="true" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td style="padding-left: 10px; white-space: nowrap">
                                        <b>Branch:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                            DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                            OnDataBound="cboBranch_DataBound">
                                            <asp:ListItem Value="-1">All Branch</asp:ListItem>
                                            <asp:ListItem Value="1">Head Office</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                            SelectCommand="                                           
                                            SELECT [BranchID], [BranchName] FROM [ViewBranchOnly] order by BranchName"></asp:SqlDataSource>
                                    </td>
                                    <td>
                                        <asp:Button ID="cmdOK" runat="server" Text="Show" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td style="white-space: nowrap">
                            <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                                ToolTip="Previous Day" CssClass="button-round">
                                <img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                            <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
              <%--  <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Payments_Passport_Branchwise" SelectCommandType="StoredProcedure"
                    CacheDuration="60" EnableCaching="true">
                    <SelectParameters>
                        <asp:Parameter Name="Filter" Type="String"
                            DefaultValue="*" Size="255" />
                        <asp:ControlParameter ControlID="cboBranch" Name="BranchID" PropertyName="SelectedValue"
                            Type="Int32" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" PropertyName="Text" />
                        <asp:Parameter Name="Summary" DefaultValue="True" />
                    </SelectParameters>
                </asp:SqlDataSource>--%>
                <div>
                   
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Amount: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotalAmount" Text="0.00" runat="server"></asp:Literal></span>
                    </div>
                </div>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AllowSorting="True"
                    PageSize="10" PagerSettings-Mode="NumericFirstLast" PagerSettings-Position="TopAndBottom"
                    PagerSettings-PageButtonCount="30" AutoGenerateColumns="False" BackColor="White"
                    BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" 
                    DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                            <asp:TemplateField HeaderText="RefID/Transaction ID">
                            <ItemTemplate>
                                <div title='<%# "Ref ID" %>'>
                               <%# Eval("RefID")%>
                                    </div>
                                <div title='<%# "Transaction ID" %>'>
                               <%# Eval("TransactionID")%>
                                    </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Exchange Code">
                            <ItemTemplate>
                               <%# Eval("ExchangeCode")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="PhoneNumber" HeaderText="Phone Number" ReadOnly="True" SortExpression="PhoneNumber"
                            ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" />
                         <asp:BoundField DataField="BillMonth" HeaderText="Bill Month" SortExpression="BillMonth"
                            />
                         <asp:BoundField DataField="BillYear" HeaderText="Bill Year" SortExpression="BillYear"
                            />
                       
                        <asp:BoundField DataField="BTCLAmount" HeaderText="Bill Amount" SortExpression="BTCLAmount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="VatAmount" HeaderText="Vat" SortExpression="VatAmount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" />
                          <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" SortExpression="TotalAmount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" />
                          <asp:BoundField DataField="Meta2" HeaderText="BTCL Code" SortExpression="Meta2"
                            />
                           <asp:BoundField DataField="BranchName" HeaderText="Branch Name" SortExpression="BranchName"
                            />
                           <asp:BoundField DataField="RefID_Merchant" HeaderText="Txn Number" SortExpression="RefID_Merchant"
                            />
                      
                        <asp:TemplateField HeaderText="Used on" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# Common.ToRecentDateTime(Eval("UsedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                              
                            </ItemTemplate>
                        </asp:TemplateField>
                       
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                    <EmptyDataTemplate>
                        No Payment Data Found.
                    </EmptyDataTemplate>
                </asp:GridView>
                <div style="padding:10px 0 0 0;">
                <asp:Button ID="btnDetails" runat="server" Text="Print Details" OnClick="btnDetails_Click" />
                  <asp:Button ID="btnSummary" runat="server" Text="Print Summary" OnClick="btnSummary_Click"  />
                </div>
                <div style="padding: 7px 0 0 720px;" align="right">               
             
            </div>

                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_BtclPayDetailsDateWise" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSource1_Selected">
                    <SelectParameters>
                   
                        <asp:ControlParameter ControlID="cboBranch" Name="BranchCode" PropertyName="SelectedValue"
                            Type="Int16" DefaultValue="-1" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="FromDate" DefaultValue="1/1/1990" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="ToDate" DefaultValue="1/1/1990" />
                        <asp:Parameter DbType="Double" Name="TotalAmountAll" Direction="InputOutput" DefaultValue="0" />
                       <%-- <asp:Parameter DbType="Int64" Name="TotalPaid" Direction="InputOutput" DefaultValue="0" />--%>
                    </SelectParameters>
                </asp:SqlDataSource>


                 <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_BtclPaySummaryDateWise" SelectCommandType="StoredProcedure"
                    >
                    <SelectParameters>
                   
                        <asp:ControlParameter ControlID="cboBranch" Name="BranchCode" PropertyName="SelectedValue"
                          Type="Int16" DefaultValue="-1" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="FromDate"  />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="ToDate"  />
                     
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

       
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server" >
                <Report FileName="Reports\rptBtclDetails.rpt">
                    <DataSources>
                        <CR:DataSourceRef DataSourceID="SqlDataSource1" TableName="s_BtclPayDetailsDateWise" />
                    </DataSources>
                    <Parameters>
                    </Parameters>
                </Report>
            </CR:CrystalReportSource>

     <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" ReportSourceID="CrystalReportSource1"
                ShowAllPageIds="True" EnableDrillDown="False" DisplayStatusbar="false" HasCrystalLogo="False"
                ToolPanelView="None" HasToggleGroupTreeButton="False" HasDrilldownTabs="False" 
                HasToggleParameterPanelButton="False" AutoDataBind="True" ReuseParameterValuesOnRefresh="True"
                EnableParameterPrompt="False" />



    
             <CR:CrystalReportSource ID="CrystalReportSource2" runat="server" >
                <Report FileName="Reports\rptBtclSummary.rpt">
                    <DataSources>
                        <CR:DataSourceRef DataSourceID="SqlDataSource3" TableName="s_BtclPaySummaryDateWise" />
                    </DataSources>
                    <Parameters>
                    </Parameters>
                </Report>
            </CR:CrystalReportSource>

     <CR:CrystalReportViewer ID="CrystalReportViewer2" runat="server" ReportSourceID="CrystalReportSource2"
                ShowAllPageIds="True" EnableDrillDown="False" DisplayStatusbar="false" HasCrystalLogo="False"
                ToolPanelView="None" HasToggleGroupTreeButton="False" HasDrilldownTabs="False" 
                HasToggleParameterPanelButton="False" AutoDataBind="True" ReuseParameterValuesOnRefresh="True"
                EnableParameterPrompt="False" />
            

            </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnDetails" />
        </Triggers>
    </asp:UpdatePanel>
    
</asp:Content>
