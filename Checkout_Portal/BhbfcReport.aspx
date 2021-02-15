<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="BhbfcReport.aspx.cs" Inherits="BhbfcReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    BHBFC Payment Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:AKControl ID="AKControl1" runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td class="Panel1">
                            <table>
                                <tr>
                                  

                                    <td>
                                        <b>Payment Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateFrom_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>to
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateTo_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>
                                        <b>Type:</b>
                                    </td>
                                    <td>
                                       <asp:DropDownList ID="ddlBranch" runat="server" AppendDataBoundItems="True" CssClass="form-control" DataSourceID="SqlDataSourceBranch"
                                DataTextField="BranchName" DataValueField="BranchCode" AutoPostBack="true"
                                CausesValidation="false">
                                <asp:ListItem Text="All branch" Value="*"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                SelectCommand="SELECT BranchCode,BranchName FROM dbo.Bhbfc_Branch with (nolock) order by BranchName"></asp:SqlDataSource>
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

                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" 
                    AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_Payment_Checkout" PageSize="10" AllowSorting="true"
                    CellPadding="4" DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" 
                    PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" 
                    OnDataBound="GridView1_DataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="Ref ID">
                            <ItemTemplate>
                                <a href='Checkout_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank" title="View"><%# Eval("RefID") %>
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--  <asp:BoundField DataField="RefID" HeaderText="RefID" ReadOnly="True" SortExpression="RefID"
                            ItemStyle-HorizontalAlign="Center" />--%>

                        <asp:BoundField DataField="Fees" HeaderText="Amount" SortExpression="Fees"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
      



                        <asp:BoundField DataField="LoanAcc" HeaderText="Loan Acc No" ReadOnly="True" SortExpression="LoanAcc" />
                        <asp:BoundField DataField="LoanType" HeaderText="LoanType" ReadOnly="True" SortExpression="Loan Type" />
                        <asp:BoundField DataField="LoanCatagory" HeaderText="Loan Catagory" SortExpression="LoanCatagory" />
                        <asp:BoundField DataField="Meta2" HeaderText="Branch" SortExpression="Meta2" />
                       <asp:TemplateField HeaderText="Paid On" SortExpression="PaidDT">
                            <ItemTemplate>
                                <div title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("PaidDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>

                                </div>
                              
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>

                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>


                <asp:SqlDataSource ID="SqlDataSource_Payment_Checkout" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Bhbfc_PaymentReport" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Payment_Checkout_Selected">

                    <SelectParameters>
                       
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="FromDate"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="ToDate" DefaultValue="1/1/1900" />

                        <asp:ControlParameter ControlID="ddlBranch" Name="BhbfcBranchCode" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />
                     <%--   <asp:ControlParameter ControlID="dblStatus" Name="Status" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlUsed" Name="Used" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlVerified" Name="Verified" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlMarchentType" Name="MarchentType" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />--%>

                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="padding-top: 10px">
                <div>
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </div>
                <div>
                    <asp:Button ID="cmdExport" runat="server" Text="Export as XLSX" OnClick="cmdExport_Click"
                        Width="150px" />
                </div>
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
