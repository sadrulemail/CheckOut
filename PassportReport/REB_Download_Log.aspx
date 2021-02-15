<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="REB_Download_Log.aspx.cs" Inherits="REB_Download_Log" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    REB Download Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:TrustControl ID="AKControl" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block">
                <table>
                    <tr>
                        <td>
                            <div class="Panel1">
                                <table>
                                    <tr>
                                        <td>
                                            <b>Date:</b> from
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDateFrom" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"></asp:TextBox>
                                        </td>
                                        <td>
                                            to
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtDateTo" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"></asp:TextBox>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="dboBranch" runat="server" CausesValidation="false" AutoPostBack="true"
                                                AppendDataBoundItems="true" DataSourceID="SqlDataSource111" DataTextField="BranchName"
                                                DataValueField="BID">
                                                <%--<asp:ListItem Value="*" Text="All"></asp:ListItem>
                                                <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                                <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>--%>
                                            </asp:DropDownList>
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
            <asp:SqlDataSource ID="SqlDataSource111" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="SELECT BID,BranchName FROM [Branch] WHERE OrgID=3" SelectCommandType="Text">
            </asp:SqlDataSource>
            <div>
                <asp:GridView ID="GridView2" runat="server" AllowPaging="True" CssClass="Grid" AllowSorting="True"
                    Visible="true" AutoGenerateColumns="False" BackColor="White" PagerSettings-Position="TopAndBottom"
                    PagerSettings-Mode="NumericFirstLast" BorderColor="#DEDFDE" BorderStyle="Solid"
                    BorderWidth="1px" CellPadding="4" PageSize="20" DataSourceID="SqlDataSourceDataDownloadLog"
                    ForeColor="Black" Style="font-size: small" EnableSortingAndPagingCallbacks="True">
                    <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" />
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <a data-toggle="tooltip" href='REB_Download_Batch.aspx?batch=<%# Eval("DownloadBatch") %>&keycode=<%# Eval("keycode") %>&type=view'
                                    title="View Items" target="_blank">
                                    <img src='Images/open1.png' width='16' height='16' border='0' />
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="DownloadBatch" HeaderText="Download Batch" InsertVisible="False"
                            ReadOnly="True" SortExpression="DownloadBatch" />
                        <asp:TemplateField HeaderText="Download On" SortExpression="DownloadDT" ItemStyle-Wrap="false"
                            ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <span data-toggle="tooltip" title='<%# Eval("DownloadDT", "{0:dddd, <br>d MMMM, yyyy <br>h:mm:ss tt}")%>'>
                                    <%# AKControl.ToRecentDateTime(Eval("DownloadDT"))%></span></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="About" SortExpression="InserDT" ItemStyle-Wrap="false"
                            ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# AKControl.ToTimeAgo((DateTime)Eval("DownloadDT"))%>'></time>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="By Emp" SortExpression="DownloadBy">
                            <ItemTemplate>
                                <%--<uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />--%>
                                <%# Eval("DownloadBy")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="TotalRecords" HeaderText="Total Records" SortExpression="TotalRecords"
                            DataFormatString="{0:N0}" />
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Download" HeaderStyle-Width="90px">
                            <ItemTemplate>
                                <a href='<%# "REB_Download_Batch.aspx?batch=" + Eval("DownloadBatch")+ "&keycode=" + Eval("keycode") + "&type=csv" %>'
                                    class="Link">CSV</a>
                                <%--<a href='<%# "Data_Export_Download.aspx?type=csv&batch=" + Eval("SL")+ "&CardType=" + Eval("CardType") + "&branches=" + (Eval("Branches")).ToString().Replace(" ", "") %>'
                                                        class="Link">CSV</a>--%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceDataDownloadLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_REB_Download_Log" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:SessionParameter Name="EmpID" SessionField="USERNAME" Type="String" />
                        <asp:ControlParameter ControlID="txtDateFrom" Type="DateTime" Name="DateFrom" DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" Type="DateTime" Name="DateTo" DefaultValue="1/1/1900" />
                        <%-- <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="InsertDateTo" DefaultValue="1/1/1900" />--%>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            </td> </tr> </table> </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <%-- <div class="TransparentGrayBackground">
            </div>--%>
            <asp:Image ID="Image1" runat="server" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
