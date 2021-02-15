<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CheckoutPaymentLog.aspx.cs" Inherits="CheckoutPaymentLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Checkout Payment Log Details
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
                                        <asp:TextBox ID="txtRefID" runat="server" Watermark="ref no/order id/mobile" MaxLength="50"
                                            Width="130px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTrnsID" runat="server" Watermark="transaction id" MaxLength="50"
                                            Width="200px"></asp:TextBox>
                                    </td>

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
                                        <asp:DropDownList ID="dblType" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                            <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                            <asp:ListItem Value="MB_OFF" Text="Mobile Banking(Off Line)"></asp:ListItem>
                                            <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>


                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td>
                                        <b>Status:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dblStatus" DataSourceID="SqlDataSourceStatus" runat="server" AppendDataBoundItems="True" CausesValidation="false" DataTextField="Status" DataValueField="StatusID" AutoPostBack="true">
                                            <asp:ListItem Value="-1" Text="All"></asp:ListItem>


                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSourceStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                            SelectCommand="SELECT StatusID, Status FROM [PaymentsDB].[dbo].[Status_Checkout]"></asp:SqlDataSource>
                                    </td>


                                    <td>
                                        <b>Verified:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlVerified" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td>
                                        <b>Used:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlUsed" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                            <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                            <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td><b>Merchant:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlMarchentType" runat="server" AutoPostBack="true"
                                            AppendDataBoundItems="True" DataTextField="MarchentName"
                                            DataValueField="MarchentID" DataSourceID="SqlDataSource1">
                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                            ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                            SelectCommand="SELECT [MarchentID], [MarchentName] FROM [Checkout_Marchent] order by MarchentName"></asp:SqlDataSource>
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

                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" 
                    AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_Payment_Checkout" PageSize="10" AllowSorting="true"
                    CellPadding="4" DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" 
                    PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" 
                    OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound">
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

                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="MarchentID" HeaderText="Marchent" SortExpression="MarchentID" />
                        <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />


                        <asp:TemplateField HeaderText="Insert on" SortExpression="InsertDT">
                            <ItemTemplate>
                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="Status" SortExpression="Status">
                            <ItemTemplate>

                                <%# Eval("icon").ToString() == "" ? Eval("StatusName") : "<img src='Images/" + Eval("icon") + "' title='" + Eval("StatusName") +"' width='20' />"%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Verified" SortExpression="Verified">
                            <ItemTemplate>
                                <%# Eval("Verified").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Used" SortExpression="Used">
                            <ItemTemplate>

                                <%# Eval("Used").ToString() == "True" ? "<img src='Images/verified.png' title='Used' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Used" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("UsedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="SenderMobile" HeaderText="PaidMobile" SortExpression="SenderMobile" />
                        <asp:BoundField DataField="PAN" HeaderText="PAN" SortExpression="PAN" />
                        <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" Visible="false" />
                        <asp:BoundField DataField="ParentRefID" HeaderText="ParentRefID" SortExpression="ParentRefID" />


                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                        <asp:BoundField DataField="TransactionID" HeaderText="Trns ID" SortExpression="TransactionID" ItemStyle-Wrap="false" />
                        <asp:BoundField DataField="NotifyMobile" HeaderText="NotifyMobile" SortExpression="NotifyMobile" Visible="false" />

                        <asp:BoundField DataField="SenderAccType" HeaderText="SenderAccType" SortExpression="SenderAccType" Visible="false" />

                        <asp:BoundField DataField="ItclOrderID" HeaderText="ItclOrderID" SortExpression="ItclOrderID" />


                        <asp:BoundField DataField="SID" HeaderText="SID" SortExpression="SID" />
                        <asp:TemplateField HeaderText="Update" SortExpression="UpdateDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />

                                <asp:HyperLink runat="server" ID="hypHistory" Target="_blank" NavigateUrl='<%# Eval("RefID","Checkout_Edit_History.aspx?refid={0}")%>'
                                    Visible='<%# AKControl1.isRole("ADMIN") && Eval("UpdateBy").ToString() != "" %>'>
                                <img src="Images/History-icon.png" width="20" height="20" border="0" />
                                </asp:HyperLink>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancel" SortExpression="CancelDT">
                            <ItemTemplate>
                                <div title='<%# Eval("CancelDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("CancelDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("CancelDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                    <uc2:EMP ID="EMPCancel" runat="server" Username='<%# Eval("CancelBy") %>' Prefix="By: " />
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Paid" SortExpression="PaidDT">
                            <ItemTemplate>
                                <div title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("PaidDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>

                                </div>
                                  <div >
                                  
                                    <%# Eval("TrnDate","<b>Trn Date:<br>{0:dd/MM/yyyy}</b>")%>
                                    
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Verified" SortExpression="VerifiedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("VerifiedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("VerifiedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("VerifiedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>





                        <asp:BoundField DataField="Fees" HeaderText="Fees" SortExpression="Fees"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="VatAmount" HeaderText="Vat" SortExpression="VatAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="ServiceCharge" HeaderText="Service Charge" SortExpression="ServiceCharge" />
                          <asp:BoundField DataField="InterestAmount" HeaderText="Emi Interest" SortExpression="InterestAmount" />

                        <asp:BoundField DataField="FullName" HeaderText="Full Name" ReadOnly="True" SortExpression="FullName" />
                        <asp:BoundField DataField="Email" HeaderText="Email" ReadOnly="True" SortExpression="Email" />
                        <asp:BoundField DataField="Meta1" HeaderText="Meta1" SortExpression="Meta1" />
                        <asp:BoundField DataField="Meta2" HeaderText="Meta2" SortExpression="Meta2" />
                        <asp:BoundField DataField="Meta3" HeaderText="Meta3" SortExpression="Meta3" />
                        <asp:BoundField DataField="Meta4" HeaderText="Meta4" SortExpression="Meta4" />
                        <asp:BoundField DataField="Meta5" HeaderText="Meta5" SortExpression="Meta5" />
                        <asp:BoundField DataField="PaymentSuccessUrl" HeaderText="Payment Success Url" SortExpression="PaymentSuccessUrl" />

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
                    SelectCommand="s_Checkout_Payment_Log" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Payment_Checkout_Selected">

                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtRefID" DbType="String" Name="RefID" DefaultValue="*" />
                        <asp:ControlParameter ControlID="txtTrnsID" DbType="String" Name="TrnsID" DefaultValue="*" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" DefaultValue="1/1/1900" />

                        <asp:ControlParameter ControlID="dblType" Name="Type" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />
                        <asp:ControlParameter ControlID="dblStatus" Name="Status" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlUsed" Name="Used" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlVerified" Name="Verified" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlMarchentType" Name="MarchentType" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />

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
