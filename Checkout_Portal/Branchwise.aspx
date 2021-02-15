<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Branchwise.aspx.cs" Inherits="Branchwise" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="Branch.ascx" TagName="Branch" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Branch wise Passport Payment Report
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <table class="Panel1">
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtFilter" runat="server" Width="170px" watermark="enter text to filter"></asp:TextBox>
                                    </td>
                                    <td style="padding-left: 10px; white-space: nowrap">
                                        <b>Payment Date:</b>
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
                                ToolTip="Previous Day" CssClass="button-round"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                            <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        </td>
                    </tr>
                </table>
            </div>
            <div>
                <%--<asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Payments_Passport_Branchwise" SelectCommandType="StoredProcedure"
                    CacheDuration="60" EnableCaching="true">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
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
                        Total Paid: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotalPaid" Text="0" runat="server"></asp:Literal></span>
                    </div>
                    <div class="group" style="display: inline-block; padding: 5px; margin-bottom: 0">
                        Total Amount: <span style="font-size: 140%;">
                            <asp:Literal ID="litTotalAmount" Text="0.00" runat="server"></asp:Literal></span>
                    </div>
                </div>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AllowSorting="True"
                    PageSize="10" PagerSettings-Mode="NumericFirstLast" PagerSettings-Position="TopAndBottom"
                    PagerSettings-PageButtonCount="30" AutoGenerateColumns="False" BackColor="White"
                    BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="RefID"
                    DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <a href='Passport_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank" title="Open">
                                    <img alt="Open" src="Images/open.png" width="16" height="16" border="0" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="RefID" HeaderText="Ref ID" ReadOnly="True" SortExpression="RefID"
                            ItemStyle-Font-Bold="true" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Name and Email" SortExpression="FullName">
                            <ItemTemplate>
                                <b>
                                    <%# Eval("FullName")%></b>
                                <%# Eval("Email","<br>{0}")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" />
                        <asp:TemplateField HeaderText="Insert on" SortExpression="InsertDT">
                            <ItemTemplate>
                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Update on" SortExpression="UpdateDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <div>
                                    <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Used on" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UsedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Child of" SortExpression="ParentRefID">
                            <ItemTemplate>
                                <%# Eval("ParentRefID", "<a href='Passport_Link.aspx?refid={0}' target='_blank'>{0}</a>")%>
                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("ParentRefID_AddedOn"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("ParentRefID_AddedOn", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <uc2:EMP ID="EMP3" runat="server" Username='<%# Eval("ParentRefID_AddedBy") %>' Prefix="By: " />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Notify Mobile" SortExpression="NotifyMobile">
                            <ItemTemplate>
                                <%# Eval("NotifyMobile") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" SortExpression="TransactionID"
                            Visible="false" />
                        <asp:TemplateField HeaderText="Paid Branch" SortExpression="PaidBranchID">
                            <ItemTemplate>
                                <uc3:Branch ID="Branch1" runat="server" BranchID='<%# Eval("PaidBranchID") %>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status" SortExpression="StatusName">
                            <ItemTemplate>
                                <div title='<%# Eval("Status")%>'>
                                    <%# Eval("StatusName")%></div>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
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
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Payments_Passport_Branchwise" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSource1_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtFilter" Name="Filter" PropertyName="Text" Type="String"
                            DefaultValue="*" Size="255" />
                        <asp:ControlParameter ControlID="cboBranch" Name="BranchID" PropertyName="SelectedValue"
                            Type="Int32" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom" PropertyName="Text" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" PropertyName="Text" />
                        <asp:Parameter DbType="Double" Name="TotalAmount" Direction="InputOutput" DefaultValue="0" />
                        <asp:Parameter DbType="Int64" Name="TotalPaid" Direction="InputOutput" DefaultValue="0" />
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
