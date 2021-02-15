<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CheckoutPaymentSummary.aspx.cs" Inherits="CheckoutPaymentSummary" EnableViewState="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Checkout Payment Summary
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

                <asp:GridView ID="GridView1" runat="server" AllowPaging="false" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" 
                    DataSourceID="SqlDataSource_Checkout_Summary" PageSize="10" AllowSorting="true"
                    CellPadding="2" DataKeyNames="MarchentID" ForeColor="Black" GridLines="Vertical" 
                    PagerSettings-Mode="NumericFirstLast" ShowFooter="true"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" 
                    OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                
                                    <img alt="Visit" title='<%# Eval("MarchentID") %>' src='<%# ConfigurationManager.AppSettings["LogoPrefix"] %><%# Eval("MarchentLogoURL").ToString() %>' width="32" />
                                
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Merchant Name" SortExpression="MarchentName">
                            <ItemTemplate>
                                <a href='<%# Eval("MarchentCompanyURL") %>' target="_blank" title="Visit Merchant Site">
                                    <%# Eval("MarchentName") %>
                                </a>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="Paid" HeaderText="Paid No" SortExpression="Paid" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="PaidAmount" HeaderText="Paid Amount" SortExpression="PaidAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />

                        <asp:BoundField DataField="Verified" HeaderText="Verified No" SortExpression="Verified" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="VerifiedAmount" HeaderText="Verified Amount" SortExpression="VerifiedAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />

                        <asp:BoundField DataField="NotVerified" HeaderText="NotVerified No" SortExpression="NotVerified" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="NotVerifiedAmount" HeaderText="NotVerified Amount" SortExpression="NotVerifiedAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />

                        <asp:BoundField DataField="Used" HeaderText="Used No" SortExpression="Used" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="UsedAmount" HeaderText="Used Amount" SortExpression="UsedAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Cancel" HeaderText="Cancel No" SortExpression="Cancel" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="CancelAmount" HeaderText="Cancel Amount" SortExpression="CancelAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Req" HeaderText="Req No" SortExpression="Req" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="ReqAmount" HeaderText="Req Amount" SortExpression="ReqAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Rejected" HeaderText="Rejected No" SortExpression="Rejected" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="RejectedAmount" HeaderText="Rejected Amount" SortExpression="RejectedAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />

                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" Font-Bold="true" CssClass="right" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White"  HorizontalAlign="Center" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>


                <asp:SqlDataSource ID="SqlDataSource_Checkout_Summary" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Checkout_Summary" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Checkout_Summary_Selected">

                    <SelectParameters>

                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" DefaultValue="1/1/1900" />


                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="padding-top: 10px">
                <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                <asp:Button ID="cmdExport" runat="server" Text="Export as XLSX" OnClick="cmdExport_Click"
                    Width="150px" CssClass="hidden" />
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
