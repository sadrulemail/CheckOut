<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Passport.aspx.cs" Inherits="Passport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Passport Payment Report
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
                                        <b>Verify Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtUsedDateFrom" runat="server" Width="75px" AutoPostBack="true"
                                            Watermark="dd/mm/yyyy" OnTextChanged="txtDateFrom_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>
                                        to
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtUsedDateTo" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateTo_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <b>Payment Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateFrom_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>
                                        to
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateTo_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td>
                                        <b>Type:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dboType" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                            <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                            <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td style="padding-left: 10px">
                                        <b>Status:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dboStatus" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="1+2" Text="USED, UNUSED"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="USED"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="UNUSED"></asp:ListItem>
                                            <asp:ListItem Value="8" Text="REJECTED"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="CANCELED"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="REQ"></asp:ListItem>                                            
                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                        </asp:DropDownList>
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
                <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Report" SelectCommandType="StoredProcedure" CacheDuration="60"
                    EnableCaching="false">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="InsertDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="InsertDateTo" DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtUsedDateFrom" DbType="Date" Name="UsedDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtUsedDateTo" DbType="Date" Name="UsedDateTo" DefaultValue="1/1/1900" />
                        <asp:Parameter Name="Summary" DefaultValue="True" />
                        <asp:ControlParameter ControlID="dboType" DbType="String" Name="Type" />
                        <asp:ControlParameter ControlID="dboStatus" DbType="String" Name="Status" />
                    </SelectParameters>
                </asp:SqlDataSource>--%>
                <div>
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Paid: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotalPaid" Text="0" runat="server"></asp:Literal></span>
                    </div>
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Amount: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotalAmount" Text="0.00" runat="server"></asp:Literal></span>
                    </div>
                    =
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Amount without Vat: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotal_Amount_WithOutVat" Text="0.00" runat="server"></asp:Literal></span>
                    </div>
                    +
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Vat: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotal_Vat" Text="0.00" runat="server"></asp:Literal></span>
                    </div>
                </div>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_s_Passport_Report" PageSize="20" AllowSorting="true"
                    CellPadding="4" DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" OnDataBound="GridView1_DataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <a href='Passport_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank" title="Open">
                                    <img alt="Open" src="Images/open.png" width="16" height="16" border="0" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RefID" HeaderText="Ref ID" ReadOnly="True" SortExpression="RefID"
                            ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName" />
                        <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" SortExpression="TotalAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Amount_WithOutVat" HeaderText="Amount without Vat" SortExpression="Amount_WithOutVat"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Vat" HeaderText="Vat Amount" SortExpression="Vat" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="InsertDT" HeaderText="Payment Date" SortExpression="InsertDT"
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="UsedDT" HeaderText="Verify Date" SortExpression="UsedDT"
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" />
                        <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" ItemStyle-HorizontalAlign="Center"
                            Visible="false" />
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" SortExpression="TransactionID" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Update By">
                            <ItemTemplate>
                                  <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# AKControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </div>
                            <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                            <%# Eval("UpdateReason","<div class='bold' title='Update Reason'>{0}</div>") %>
                            <asp:HyperLink runat="server" ID="hypHistory" Target="_blank" NavigateUrl='<%# Eval("RefID","Passport_Edit_History.aspx?refid={0}")%>'
                                Visible='<%# AKControl1.isRole("ADMIN") && Eval("UpdateBy").ToString() != "" %>'>
                                <img src="Images/History-icon.png" width="20" height="20" border="0" />
                            </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_s_Passport_Report" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Payment_Report" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSource_s_Passport_Report_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="InsertDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="InsertDateTo" DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtUsedDateFrom" DbType="Date" Name="UsedDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtUsedDateTo" DbType="Date" Name="UsedDateTo" DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="dboType" DbType="String" Name="Type" />
                        <asp:ControlParameter ControlID="dboStatus" DbType="String" Name="Status" />
                        <asp:Parameter DbType="Double" Name="TotalAmount" Direction="InputOutput" DefaultValue="0" />
                        <asp:Parameter DbType="Double" Name="TotalPaid_Vat" Direction="InputOutput" DefaultValue="0" />
                        <asp:Parameter DbType="Double" Name="TotalPaid_Amount_WithOutVat" Direction="InputOutput"
                            DefaultValue="0" />
                        <asp:Parameter DbType="Int64" Name="TotalPaid" Direction="InputOutput" DefaultValue="0" />
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
