<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="PassportEdit_Authorize.aspx.cs" Inherits="PassportEdit_Authorize" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Follow Up Authorize Pending
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel runat="server" ID="panelAddItem" CssClass="Panel1 form-inline" Style="padding: 2px 7px; margin-bottom: 10px; display: inline-table">
                <table>
                    <tr>

                        <td>
                            <asp:TextBox ID="txtFilter" runat="server" placeholder="Ref ID"
                                Width="200px"></asp:TextBox>

                        </td>
                        <td>Branch:
                        </td>
                        <td>
                            <asp:DropDownList ID="cboBranch" runat="server" DataSourceID="SqlBranch" AppendDataBoundItems="true"
                                OnDataBound="cboBranch_DataBound"
                                DataTextField="BranchName" DataValueField="BranchID" Enabled="false">
                                <%-- <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>--%>
                                 <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                            </asp:DropDownList>
                             <asp:SqlDataSource ID="SqlBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [ViewBranch]">
                                                          </asp:SqlDataSource>
                        </td>

                      <%--  <td>Edit Date:
                        </td>
                        <td>
                            <asp:TextBox ID="txtDateFrom" runat="server" Width="80px" CssClass="Watermark Date"
                                Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                        </td>
                        <td>to
                        </td>
                        <td>
                            <asp:TextBox ID="txtDateTo" runat="server" Width="80px" CssClass="Watermark Date"
                                Watermark="dd/mm/yyyy" AutoPostBack="true"></asp:TextBox>
                        </td>
                          --%>

                        <%--  <td>Insert By:
                        </td>
                        <td>
                            <asp:TextBox ID="txtInsertBy" runat="server" CssClass="empid-pick" 
                                placeholder="empid" Width="60px"></asp:TextBox>
                        </td>--%>
                        <%--   <td>Type:
                        </td>--%>
                        <%--   <td>
                            <asp:DropDownList ID="ddlType" runat="server" DataSourceID="sqlType" AppendDataBoundItems="true"
                                DataTextField="TypeName" DataValueField="TypeID" AutoPostBack="True" >
                                <asp:ListItem Text="ALL" Value="-1"></asp:ListItem>
                            </asp:DropDownList>

                            <asp:SqlDataSource ID="sqlType" runat="server" ConnectionString="<%$ ConnectionStrings:ErpConnectionString %>"
                                SelectCommand="SELECT [TypeID],[TypeName] FROM [dbo].[FollowUp_Types] with (nolock) order by TypeName"></asp:SqlDataSource>
                        </td>--%>
                        <%--</tr></table><table><tr>
                             <td>Insert From: </td>
                        <td>
                             <asp:DropDownList ID="ddlBranchID" runat="server" AppendDataBoundItems="true" 
                                    DataSourceID="SqlDataSourceReqBranch" DataTextField="BranchName" DataValueField="BranchID" CssClass="silgleselect"  >
                                 <asp:ListItem Value="-1" Text="All Branch"></asp:ListItem>   
                                 <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceReqBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                    SelectCommand="SELECT [BranchID], [BranchName] FROM [ViewBranchOnly] with (nolock) ORDER BY [BranchName]"></asp:SqlDataSource>

                        </td>
                        <td>

                            <asp:DropDownList ID="ddlDeptID" runat="server"
                                    DataSourceID="SqlDataSourceDept" DataTextField="Department" DataValueField="DeptID"
                                    AppendDataBoundItems="true" CssClass="silgleselect" >
                                    <asp:ListItem Text="All Deptartment" Value="-1"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlDataSourceDept" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                    SelectCommand="SELECT DeptID, Department FROM ViewDept with (nolock) WHERE (Department <> '' and ShowInHeadOffice = 1) ORDER BY Department"></asp:SqlDataSource>
                        </td>--%>
                        <td style="padding-left: 10px;">
                            <asp:Button ID="btnSearch" runat="server" Text="Search"
                                CommandName="Select" OnClick="btnSearch_Click" />
                        </td>
                    </tr>
                </table>



            </asp:Panel>

            <div>
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="Sql_EditAuthorize_Pending" PageSize="10" AllowSorting="true"
                    CellPadding="4" DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" OnRowCommand="GridView1_RowCommand">
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
                   
                      
                        <asp:BoundField DataField="InsertDT" HeaderText="Payment Date" SortExpression="InsertDT"
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                        
                      
                        
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="TransactionID" HeaderText="Transaction ID" SortExpression="TransactionID" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Update" SortExpression="UpdateDT">
                            <ItemTemplate>

                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                <%# Eval("UpdateReason","<div class='bold' title='Update Reason'>{0}</div>") %>
                                <asp:HyperLink runat="server" ID="hypHistory" Target="_blank" NavigateUrl='<%# Eval("RefID","Passport_Edit_History.aspx?refid={0}")%>'
                                    Visible='<%# TrustControl1.isRole("ADMIN") && Eval("UpdateBy").ToString() != "" %>'>
                                <img src="Images/History-icon.png" width="20" height="20" border="0" />
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Authorization" SortExpression="EditAuthorizeDT">
                            <ItemTemplate>
                                <div title="Authorization">
                                    <asp:Button runat="server" ID="cmdAuthorizeButtonShow"
                                        Visible='<%# (bool)Eval("EditAuthorize")==false %>'
                                         Enabled='<%# (bool)Eval("EditAuthorize")==false && Eval("UpdateBy").ToString()!=Session["EMPID"].ToString()%>'
                                        CommandName="Authorize" Text="Authorize"
                                        CommandArgument='<%# Eval("RefID") %>'></asp:Button>
                                    <asp:ConfirmButtonExtender runat="server" ID="conAuthorize"
                                        TargetControlID="cmdAuthorizeButtonShow" ConfirmText="Do you wan to Authorize?" />
                                </div>
                                <table class='noborder <%# (bool)Eval("EditAuthorize") ? "" : "hidden"  %>'>
                                    <td>
                                        <%# (bool)Eval("EditAuthorize") ? "<img src='Images/Tick.png' height='24' width='24' />" : "" %>
                                    </td>
                                    <td>
                                        <uc2:EMP ID="EMP3" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                        <div title='<%# Eval("EditAuthorizeDT","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                            <%# TrustControl1.ToRecentDateTime( Eval("EditAuthorizeDT")) %><br />
                                            <time class="timeago" datetime='<%# Eval("EditAuthorizeDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </td>
                                </table>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <%--    <asp:TemplateField HeaderText="Update By">
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
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <a href='Passport_Link.aspx?refid=<%# Eval("RefID") %>' target="_blank" title="Open">
                                    <img alt="Open" src="Images/open.png" width="16" height="16" border="0" /></a>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Authoziration Pending.
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
                <%-- <asp:GridView ID="Gdv_Browse" runat="server" CssClass="Grid"
                    AllowSorting="True" AutoGenerateColumns="False" DataKeyNames="ID"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataSourceID="Sql_Browse" ForeColor="Black" OnRowDataBound="Gdv_Browse_RowDataBound"
                    GridLines="Vertical" AllowPaging="True" PageSize="20" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom">
                    <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" PageButtonCount="30" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>   
                    
                        <asp:TemplateField HeaderText="Comment" SortExpression="Comment" >
                            <ItemTemplate>
                              <%# Eval("Comment") %>
                            </ItemTemplate>
                            <ItemStyle Font-Size="120%" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Subject" HeaderText="Subject" SortExpression="Subject" />

                        <asp:BoundField DataField="AuthoName" HeaderText="Req Autho" SortExpression="AuthoName" />

                        <asp:BoundField DataField="TypeName" HeaderText="Type" SortExpression="TypeName" ItemStyle-HorizontalAlign="Center" />

                  
                        <asp:BoundField DataField="StatusName" HeaderText="Status" SortExpression="StatusName" ItemStyle-HorizontalAlign="Center" />

                        <asp:TemplateField HeaderText="Comment By/DT" InsertVisible="false">
                            <ItemTemplate>
                                <span class="trustclick" type="emp" val='<%# Eval("InsertBy") %>'><%# Eval("InsertBy") %></span>
                                <div title='<%# Eval("InsertDT","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime( Eval("InsertDT")) %><br />
                                    <time class="timeago" datetime='<%# Eval("InsertDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField SortExpression="Authorizable">
                            <ItemTemplate>
                               <%# (bool)Eval("Authorizable") ? "please authorize" : "you can not authorize this" %>
                            </ItemTemplate>
                            <ItemStyle ForeColor="Gray" Font-Size="80%" />
                        </asp:TemplateField>



                    </Columns>
                    <EmptyDataTemplate>
                        No Data Found
                    </EmptyDataTemplate>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle HorizontalAlign="Left" CssClass="PagerStyle" />
                    <SelectedRowStyle BackColor="#FFD24D" />
                    <HeaderStyle BackColor="#6B696B" ForeColor="White" HorizontalAlign="Center" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>--%>
                <br />
                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
            </div>
            <asp:SqlDataSource ID="Sql_EditAuthorize_Pending" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_Passport_EditAuthorize_Pending"
                SelectCommandType="StoredProcedure" OnSelected="Sql_Browse_Selected">
                <SelectParameters>
                    <asp:ControlParameter ControlID="txtFilter" Name="FilterName" PropertyName="Text" DefaultValue='*' />
                      <asp:ControlParameter ControlID="cboBranch" Name="BranchID" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                     <%--<asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom"
                        DefaultValue="1/1/1900" />
                    <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" DefaultValue="1/1/1900" />
                    <asp:SessionParameter Name="ViewerID" SessionField="EMPID" />
                    <asp:SessionParameter Name="ViewerBranchID" SessionField="BRANCHID" />
                    <asp:SessionParameter Name="ViewerDeptID" SessionField="DEPTID" />--%>

                </SelectParameters>
            </asp:SqlDataSource>

        </ContentTemplate>
        <Triggers>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>

