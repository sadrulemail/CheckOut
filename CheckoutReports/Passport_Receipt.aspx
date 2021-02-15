<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Passport_Receipt.aspx.cs" Inherits="Passport_Receipt_Print" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Passport Receipt Print
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="Panel1" style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <b>Ref Number</b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtReceiptNo" runat="server" Width="160px" CssClass="center" Font-Size="120%"
                                MaxLength="14" Watermark="enter ref no."></asp:TextBox>
                        </td>
                        <td>
                            <asp:Button ID="cmdOK" runat="server" Text="Show" />
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                    PageSize="20" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4"
                    DataKeyNames="RefID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
                    CssClass="Grid" PagerSettings-Position="TopAndBottom" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-PageButtonCount="30">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="Print">
                            <ItemTemplate>
                                <a target="_blank" href='Passport_Payment_Receipt.ashx?refid=<%# Eval("RefID") %>&key=<%# Eval("keycode")%>'
                                    title="Print Receipt">
                                    <img src="Images/printer-green-icon.png" width="48" height="48" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ref ID" SortExpression="Ref">
                            <ItemTemplate>
                                <%# Eval("RefID")%>
                            </ItemTemplate>
                            <ItemStyle Font-Size="Medium" Font-Bold="true" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name and Email" SortExpression="FullName">
                            <ItemTemplate>
                                <div style="font-size: medium; font-weight: bold">
                                    <%# Eval("FullName")%></div>
                                <div>
                                    <%# Eval("Email")%></div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Amount" SortExpression="TotalAmount">
                            <ItemTemplate>
                                <%# Eval("TotalAmount","{0:N2}")%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" Font-Size="Medium" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Type" SortExpression="Type" HeaderText="Type" ItemStyle-HorizontalAlign="Center"
                            ReadOnly="true">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Insert on" SortExpression="InsertDT">
                            <ItemTemplate>
                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Update on" SortExpression="UpdateDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Used on" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("UsedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <EmptyDataTemplate>
                        No Data Found</EmptyDataTemplate>
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                    SelectCommand="s_Passport_Payment_Select" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtReceiptNo" DefaultValue="*" PropertyName="Text"
                            Name="RefID" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
