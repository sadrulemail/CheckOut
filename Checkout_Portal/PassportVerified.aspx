<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="PassportVerified.aspx.cs" Inherits="PassportVerified" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Passport Verified Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <table class="Panel1">
                                <tr>
                                    <td>
                                        <b>Payment Date:</b> from
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
                                    <td style="padding-left: 10px">
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
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Used_Report" SelectCommandType="StoredProcedure" CacheDuration="60"
                    EnableCaching="true">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" />
                        <asp:Parameter Name="Summary" DefaultValue="True" />
                        <asp:ControlParameter ControlID="dboType" DbType="String" Name="Type" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:GridView ID="GridView2" runat="server" BackColor="White" AutoGenerateColumns="false"
                    DataSourceID="SqlDataSource1" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="0"
                    CellPadding="4" ForeColor="Black" GridLines="None" ShowHeader="false">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div>
                                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                                        Total Paid: <span style="font-size: 140%">
                                            <%# Eval("Total") %>
                                        </span>
                                    </div>
                                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                                        Total Amount: <span style="font-size: 140%">
                                            <%# Eval("TotalAmount","{0:N2}") %></span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle BackColor="White" />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <RowStyle BackColor="#F7F7DE" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_s_Passport_Used_Report" PageSize="20" AllowSorting="true"
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
                        <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                        <asp:BoundField DataField="UsedDT" HeaderText="Paid On" SortExpression="UsedDT" DataFormatString="{0:dd/MM/yyyy}"
                            ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" ItemStyle-HorizontalAlign="Center"
                            Visible="false" />
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center" />
                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Verified Data Found
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
                <asp:SqlDataSource ID="SqlDataSource_s_Passport_Used_Report" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_Used_Report" SelectCommandType="StoredProcedure" CacheDuration="60"
                    EnableCaching="true">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" />
                        <asp:ControlParameter ControlID="dboType" DbType="String" Name="Type" />
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
