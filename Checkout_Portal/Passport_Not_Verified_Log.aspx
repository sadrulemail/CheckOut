<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Passport_Not_Verified_Log.aspx.cs" Inherits="Passport_Not_Verified_Log" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
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
                        <td>
                            <div class="Panel1">
                                <table>
                                    <tr>
                                        <td>
                                            <b>Verify Request Date:</b>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtReqDateFrom" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"
                                                OnTextChanged="txtDateFrom_TextChanged"></asp:TextBox>
                                        </td>
                                        <td>
                                            to
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtReqDateTo" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"
                                                OnTextChanged="txtDateTo_TextChanged"></asp:TextBox>
                                        </td>
                                        <td style="padding-left: 10px">
                                            <b>Enrolment Date:</b>
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtEnrolmentDateFrom" CssClass="Date" runat="server" Width="85px"
                                                AutoPostBack="true" OnTextChanged="txtDateFrom_TextChanged"></asp:TextBox>
                                        </td>
                                        <td>
                                            to
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtEnrolmentDateTo" CssClass="Date" runat="server" Width="85px"
                                                AutoPostBack="true" OnTextChanged="txtDateTo_TextChanged"></asp:TextBox>
                                        </td>
                                    </tr>
                                </table>
                                <table>
                                    <tr>
                                        <td>
                                            <b>Response Type:</b>
                                        </td>
                                        <td>
                                            <asp:DropDownList ID="dboType" runat="server" AutoPostBack="True" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourcePassport_Response_Codes" DataTextField="Reasons" DataValueField="ResponseCode">
                                                <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourcePassport_Response_Codes" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                                SelectCommand="SELECT  [ResponseCode] ,
        [Reasons]
FROM    [PaymentsDB].[dbo].[Passport_Response_Codes]
WHERE   Type = 'Passport_Check_Payment' and ResponseCode NOT IN ('0','1')
"></asp:SqlDataSource>
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
                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSourceData" PageSize="20" AllowSorting="True" CellPadding="4"
                    DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
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
                            ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right">
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Request Date" SortExpression="DT">
                            <ItemTemplate>
                                <div title='<%# Eval("DT", "{0:dddd, dd MMMM, yyyy h:mm:ss tt}") %>'>
                                    <%# Eval("DT", "{0:dd/MM/yyyy}") %></div>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" />
                        <asp:BoundField DataField="PassportEnrolmentDate" HeaderText="Enrolment Date" SortExpression="PassportEnrolmentDate"
                            DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Msg" HeaderText="Response" SortExpression="Msg" ItemStyle-HorizontalAlign="Center" />
                        <asp:TemplateField HeaderText="Reasons" SortExpression="Reasons">
                            <ItemTemplate>
                                <%# Eval("Reasons") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        No Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceData" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Passport_CheckPayment_NotVerified" SelectCommandType="StoredProcedure"
                    OnSelected="SqlDataSourceData_Selected">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtReqDateFrom" Type="DateTime" Name="ReqDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtReqDateTo" Type="DateTime" Name="ReqDateTo" DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtEnrolmentDateFrom" Type="DateTime" Name="EnrolmentDateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtEnrolmentDateTo" Type="DateTime" Name="EnrolmentDateTo"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="dboType" Type="String" Name="ResponseType" DefaultValue="*" />
                        <asp:Parameter Type="Int64" Name="Total" Direction="InputOutput" DefaultValue="0" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div>
                <div style="display: inline-block; padding: 5px; margin-bottom: 0">
                    Total: <b>
                        <asp:Literal ID="litTotalPaid" Text="0" runat="server"></asp:Literal></b>
                </div>
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
