<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Checkout.aspx.cs" Inherits="Checkout" Culture="en-nz" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Checkout Payment Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <div class="Panel1">
                                <table>
                                    <tr>
                                       
                                        <td style="padding-left: 10px">
                                            <b>Payment Date:</b>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDateFrom" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"
                                                OnTextChanged="txtDateFrom_TextChanged"></asp:TextBox>
                                        </td>
                                        <td>
                                            to
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDateTo" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"
                                                OnTextChanged="txtDateTo_TextChanged"></asp:TextBox>
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
                                                <%--<asp:ListItem Value="1+2" Text="USED, UNUSED"></asp:ListItem>--%>
                                                <asp:ListItem Value="2" Text="USED"></asp:ListItem>
                                                <asp:ListItem Value="1" Text="UNUSED"></asp:ListItem>
                                            </asp:DropDownList>
                                        </td>
                                        <td style="padding-left: 10px">
                                            <asp:Button ID="cmdOK" runat="server" Text="Show" OnClick="cmdOK_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </td>
                        <td>
                            <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                                ToolTip="Previous Day" data-toggle='tooltip' CssClass="button-round"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                            <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                data-toggle='tooltip' CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <%--<asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Report" SelectCommandType="StoredProcedure" CacheDuration="60"
                    EnableCaching="true">
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
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center" />
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
                
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_s_Passport_Report" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Payment_Report" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSource_s_Passport_Report_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="InsertDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="InsertDateTo" DefaultValue="1/1/1900" />
                      <%--  <asp:ControlParameter ControlID="txtUsedDateFrom" DbType="Date" Name="UsedDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtUsedDateTo" DbType="Date" Name="UsedDateTo" DefaultValue="1/1/1900" />--%>
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
