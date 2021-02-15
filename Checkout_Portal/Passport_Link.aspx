<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Passport_Link.aspx.cs" Inherits="Passport_Link" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Passport Receipt"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <table class="Panel1">
                            <tr>
                                <td>Passport Ref ID: </td>
                                <td>
                                    <asp:TextBox ID="txtFilter" runat="server" AutoPostBack="True" CausesValidation="false" MaxLength="14" OnTextChanged="cmdOK_Click" Watermark="enter ref no" Width="130px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Button ID="cmdOK" runat="server" OnClick="cmdOK_Click" Text="Show" />
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="padding-left:20px">
                        <img src="Images/Passport.jpg" width="48" style="border: 1px silver solid; border-radius: 8px" class="Shadow" />
                    </td>
                </tr>
            </table>
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                PageSize="20" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4"
                DataKeyNames="RefID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
                CssClass="Grid" PagerSettings-Position="TopAndBottom" PagerSettings-Mode="NumericFirstLast"
                PagerSettings-PageButtonCount="30" OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound"
                OnRowCommand="GridView1_RowCommand">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:TemplateField HeaderText="Ref ID" SortExpression="Ref">
                        <ItemTemplate>
                            <%# Eval("RefID")%>
                            <br />
                            <a target="_blank" href='Passport_Payment_Receipt.ashx?refid=<%# Eval("RefID") %>&key=<%# Eval("keycode")%>'
                                title="Print Receipt">
                                <img alt="Print" src="Images/print-icon.png" width="36" height="36" /></a>
                        </ItemTemplate>
                        <ItemStyle Font-Size="110%" Font-Bold="true" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Name, Email and Mobile" SortExpression="FullName">
                        <ItemTemplate>
                            <div style="font-size: 110%; font-weight: bold">
                                <%# Eval("FullName")%>
                            </div>
                            <%# Eval("Email", "<div>{0}</div>")%>
                            <%# Eval("NotifyMobile", "<div title='Notify Mobile'>{0}</div>")%>
                        </ItemTemplate>
                        <ItemStyle Wrap="false" />
                        <EditItemTemplate>
                            Name:
                            <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("FullName") %>' Width="300px" placeholder="name on passport"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ID="req_Name" Display="Dynamic" ForeColor="Red"
                                ControlToValidate="txtName" SetFocusOnError="true" ErrorMessage="*"></asp:RequiredFieldValidator>
                            <br />
                            Email:
                            <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' Width="300px"  placeholder="email address"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                ErrorMessage="Invalid Email" SetFocusOnError="True" Display="Dynamic" ForeColor="Red"
                                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                            <br />
                            Notify Mobile:
                            <asp:TextBox ID="txtNotifyMobile" runat="server" Text='<%# Bind("NotifyMobile") %>' Width="200px" MaxLength="13"  placeholder="8801xxxxxxxxx"></asp:TextBox>
                           
                            <br />
                            Reason:
                            <asp:TextBox runat="server" ID="txtPassportUpdateReason" placeholder="change reason" Text='<%# Bind("UpdateReason") %>'
                                MaxLength="255" Width="280px"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ID="reqReason" ControlToValidate="txtPassportUpdateReason"
                                ErrorMessage="*">
                            </asp:RequiredFieldValidator>
                            <br />
                            <asp:Button ID="lnkUpdate" CommandName="Update" runat="server" Text="Update" />
                            <asp:ConfirmButtonExtender runat="server" ID="con_Update" TargetControlID="lnkUpdate"
                                ConfirmText="Do you want to Update?">
                            </asp:ConfirmButtonExtender>
                            <asp:Button ID="lnkCancel" CommandName="Cancel" runat="server" CausesValidation="false"
                                Text="Cancel" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Total Amount" SortExpression="TotalAmount">
                        <ItemTemplate>
                            <%# Eval("TotalAmount","{0:N2}")%>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Right" Font-Bold="true" Font-Size="Medium" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                        ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Type/ Status" SortExpression="Type">
                        <ItemTemplate>
                            <%# Eval("Type") %>
                            <div title='<%# Eval("Status","{0}")%>'>
                                <%# Eval("StatusName","<b>{0}</b>")%>
                            </div>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                        <ItemTemplate>
                            <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
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
                                                       <uc2:EMP ID="EMP3" runat="server" Username='<%# Eval("EditAuthorizeBy") %>' Prefix="By: " />
                                                        <div title='<%# Eval("EditAuthorizeDT","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime( Eval("EditAuthorizeDT")) %><br />
                                                            <time class="timeago" datetime='<%# Eval("EditAuthorizeDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                    </td>
                                                </table>
                          </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cancel" SortExpression="CancelDT">
                        <ItemTemplate>
                            <div title='<%# Eval("CancelDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("CancelDT"))%>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# Eval("CancelDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                                <uc2:EMP ID="EMPCancel" runat="server" Username='<%# Eval("CancelBy") %>' Prefix="By: " />
                            </div>
                            <%# Eval("CancelReason", "<div class='bold' title='Cancel Reason'>{0}</div>")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Used" SortExpression="UsedDT">
                        <ItemTemplate>
                            <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("UsedDT"))%>
                                <div class='time-small'>
                                    <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </div>
                            <%# Eval("EID","<div title='EID'>{0}</div>") %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Account/PAN/Txn">
                        <ItemTemplate>
                            <%# Eval("SenderMobile", "<div title='Sender Mobile'>{0}</div>")%>
                            <%# Eval("PAN","<div title='Card Number'>{0}</div>")%>
                            <%# Eval("TransactionID", "<div title='Transaction ID'>{0}</div>")%>
                            <%# Eval("OrderID", "<div title='Order ID'>{0}</div>")%>
                            <asp:LinkButton runat="server" ID="lnkCheckTrans" ToolTip="Check Transaction" CommandName="TRNCHK"
                                CausesValidation="false" CommandArgument='<%# Eval("TransactionID","{0}") + "|" + Eval("Amount","{0:N2}") + "|" + Eval("RefID","{0}")+ "|" + Eval("Status","{0}") %>'
                                Visible='<%# (Eval("TransactionID").ToString() != "" && Eval("SenderMobile").ToString() != "" ) %>'><img src="Images/mobile.png" width="16" height="16" border="0"/ ></asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <span id="idEdit">
                                <asp:LinkButton runat="server" ID="lnkEdit" ToolTip="Edit" CommandName="Edit" CommandArgument='<%# Eval("RefID") %>'
                                    CausesValidation="false" Visible='<%# !(bool)Eval("Used") && Eval("Status").ToString() != "9" && Eval("Status").ToString() != "0" %>'> <img src="Images/edit-label.png" width="20" height="20" border="0" /></asp:LinkButton>
                            </span>
                            <span id="idCancelreason" class="hidden">
                                <asp:TextBox runat="server" ID="txtPassportDeleteReason" placeholder="Cancel reason"
                                    Text='<%# Bind("CancelReason") %>' ValidationGroup="Cancel" MaxLength="255" Width="200px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCancelReason" ControlToValidate="txtPassportDeleteReason"
                                    runat="server" SetFocusOnError="true" ValidationGroup="Cancel" Display="Dynamic" ErrorMessage="*" ForeColor="Red"
                                    Font-Bold="true"></asp:RequiredFieldValidator>
                                <br />
                                <asp:LinkButton runat="server" ID="lnkCANCELED" Style="margin-left: 7px" ToolTip="Mark as CANCELED"
                                    CommandName="CANCELED" CommandArgument='<%# Eval("RefID") %>' Visible='<%# !(bool)Eval("Used") && Eval("Status").ToString() != "9" && Eval("Status").ToString() != "0" && TrustControl1.isRole("ADMIN") %>'
                                    CssClass="button1" ValidationGroup="Cancel">Mark as Cancel</asp:LinkButton>
                                <asp:ConfirmButtonExtender runat="server" ID="conCANCELED" TargetControlID="lnkCANCELED"
                                    ConfirmText="Are you sure you want to mark as CANCELED?">
                                </asp:ConfirmButtonExtender>


                            </span>
                            <span style="white-space: nowrap" class='<%# (!(bool)Eval("Used") && Eval("Status").ToString() != "9" && Eval("Status").ToString() != "0" && TrustControl1.isRole("ADMIN")) == true ? "" : "hidden" %>'>
                                <a href="" id="cancelBtnclient" onclick='$("#idCancelreason").show();$(this).hide();$("#idEdit").hide();$("#cancelCloseBtnclient").show();return false'>
                                    <img src="Images/delete.png" width="16" height="16" border="0" /></a> <a href=""
                                        class="hidden" id="cancelCloseBtnclient" onclick='$("#idCancelreason").hide();$(this).hide();$("#idEdit").show();$("#cancelBtnclient").show();return false'>Close</a>
                            </span>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        <EditItemTemplate>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerSettings Mode="NumericFirstLast" PageButtonCount="30" Position="TopAndBottom" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <EmptyDataTemplate>
                    No Data Found
                </EmptyDataTemplate>
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />
            </asp:GridView>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_Passport_Payment_Select" SelectCommandType="StoredProcedure"
                UpdateCommand="s_Passport_Name_Update" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated"
                OnSelected="SqlDataSource1_Selected">
                <SelectParameters>
                    <asp:QueryStringParameter QueryStringField="refid" Name="RefID" Type="String" />
                    <asp:Parameter Name="Msg" Direction="InputOutput" DefaultValue="" ConvertEmptyStringToNull="false"
                        Size="255" Type="String" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="RefID" Type="String" />
                    <asp:Parameter Name="FullName" Type="String" />
                    <asp:Parameter Name="Email" Type="String" />
                    <asp:Parameter Name="UpdateReason" Type="String" Size="255" />
                    <asp:Parameter Name="NotifyMobile" Type="String" Size="255" />
                    <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                     <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" Type="String" />
                    <asp:Parameter Name="Msg" Type="String" DefaultValue="" Size="255" Direction="InputOutput" />
                </UpdateParameters>
            </asp:SqlDataSource>
            <div style="padding-left: 50px">
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="White"
                    BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="RefID"
                    DataSourceID="SqlDataSource2" ForeColor="Black" GridLines="Vertical" CssClass="Grid" OnRowDataBound="GridView2_RowDataBound"
                    OnRowCommand="GridView2_RowCommand">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:BoundField DataField="RefID" HeaderText="Ref ID" ReadOnly="True" SortExpression="RefID"
                            ItemStyle-ForeColor="Gray">
                            <ItemStyle ForeColor="Gray" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Name, Email and Mobile" SortExpression="FullName">
                            <ItemTemplate>
                                <div style="font-size: 110%; font-weight: bold">
                                    <%# Eval("FullName")%>
                                </div>
                                <%# Eval("Email", "<div>{0}</div>")%>
                                <%# Eval("NotifyMobile", "<div title='Notify Mobile'>{0}</div>")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right">
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                            <ItemTemplate>
                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Update" SortExpression="UpdateDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UpdateDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UpdateDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UpdateDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                <%# Eval("UpdateReason","<div class='bold' title='Reason'>{0}</div>") %>
                                <asp:HyperLink runat="server" ID="hypHistory1" Target="_blank" NavigateUrl='<%# Eval("RefID","Passport_Edit_History.aspx?refid={0}")%>'
                                    Visible='<%# TrustControl1.isRole("ADMIN") && Eval("UpdateBy").ToString() != "" %>'>
                                    <img src="Images/History-icon.png" width="20" height="20" border="0" />
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Authorization" SortExpression="EditAuthorizeDT">
                          <ItemTemplate>
                                
                               <table class='noborder <%# (bool)Eval("EditAuthorize") ? "" : "hidden"  %>'>
                                                    <td>
                                                        <%# (bool)Eval("EditAuthorize") ? "<img src='Images/Tick.png' height='24' width='24' />" : "" %>
                                                    </td>
                                                    <td>
                                                       <uc2:EMP ID="EMP3" runat="server" Username='<%# Eval("EditAuthorizeBy") %>' Prefix="By: " />
                                                        <div title='<%# Eval("EditAuthorizeDT","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                                            <%# TrustControl1.ToRecentDateTime( Eval("EditAuthorizeDT")) %><br />
                                                            <time class="timeago" datetime='<%# Eval("EditAuthorizeDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                    </td>
                                                </table>
                          </ItemTemplate>
                    </asp:TemplateField>
                        <asp:TemplateField HeaderText="Used" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div title='<%# Eval("UsedDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UsedDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("UsedDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <%# Eval("EID","<div title='EID'>{0}</div>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Linked">
                            <ItemTemplate>
                                <div title='<%# Eval("ParentRefID_AddedOn","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("ParentRefID_AddedOn"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("ParentRefID_AddedOn", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("ParentRefID_AddedBy") %>' Prefix="By: " />
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Account/PAN/Txn">
                            <ItemTemplate>
                                <%# Eval("SenderMobile", "<div title='Sender Mobile'>{0}</div>")%>
                                <%# Eval("PAN","<div title='Card Number'>{0}</div>")%>
                                <%# Eval("TransactionID", "<div title='Transaction ID'>{0}</div>")%>
                                 <%# Eval("OrderID", "<div title='Order ID'>{0}</div>")%>
                                <asp:LinkButton runat="server" ID="lnkCheckTrans" ToolTip="Check Transaction" CommandName="TRNCHK"
                                    CausesValidation="false" CommandArgument='<%# Eval("TransactionID","{0}") + "|" + Eval("Amount","{0:N2}") %>'
                                    Visible='<%# (Eval("TransactionID").ToString() != "" && Eval("SenderMobile").ToString() != "" ) %>'><img src="Images/mobile.png" width="16" height="16" border="0"/ ></asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="lnkDelete" ToolTip="Unlink" CommandName="Delete"
                                    CommandArgument='<%# Eval("RefID") + "_" + Eval("ParentRefID") %>' Visible='<%# !(bool)Eval("Used") %>'> <img src="Images/delete.png" width="16" height="16" border="0" /></asp:LinkButton>
                                <asp:ConfirmButtonExtender runat="server" ID="confirm_lnkDelete" ConfirmText="Do you want to Unlink?"
                                    TargetControlID="lnkDelete">
                                </asp:ConfirmButtonExtender>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                    <SortedAscendingCellStyle BackColor="#FBFBF2" />
                    <SortedAscendingHeaderStyle BackColor="#848384" />
                    <SortedDescendingCellStyle BackColor="#EAEAD3" />
                    <SortedDescendingHeaderStyle BackColor="#575357" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="SELECT * FROM [Payments_Passport] WHERE ([ParentRefID] = @ParentRefID)"
                    DeleteCommand="s_Passport_Payment_Ref_Link_Delete" DeleteCommandType="StoredProcedure"
                    OnDeleted="SqlDataSource2_Deleted" OnDeleting="SqlDataSource2_Deleting">
                    <DeleteParameters>
                        <asp:Parameter Name="RefID" Type="String" />
                        <asp:Parameter Name="ParentRefID" Type="String" />
                        <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                    </DeleteParameters>
                    <SelectParameters>
                        <asp:QueryStringParameter QueryStringField="refid" Name="ParentRefID" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
                <asp:Panel runat="server" ID="PanelAdd" Style="margin-top: 10px">
                    <asp:TextBox ID="txtRefIDAdd" runat="server" MaxLength="14" Width="130px" Visible="false"
                        Watermark="enter ref no"></asp:TextBox>
                    <asp:LinkButton runat="server" ID="lnlAddNew" ToolTip="Link New" OnClick="lnlAddNew_Click"
                        Visible="false" CausesValidation="false"> 
                    <img src="Images/add.png" width="18" height="18" border="0" /></asp:LinkButton>
                    <asp:Button runat="server" Text="Search" ID="cmdSearch" Visible="false" OnClick="cmdSearch_Click" />
                    <asp:Button runat="server" Text="Cancel" ID="cmdCancel" Visible="false" OnClick="cmdCancel_Click" />
                    <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" BackColor="White"
                        BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="RefID"
                        DataSourceID="SqlDataSource_Search" ForeColor="Black" GridLines="Vertical" CssClass="Grid"
                        Visible="false" OnItemCommand="DetailsView1_ItemCommand">
                        <AlternatingRowStyle BackColor="White" />
                        <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <Fields>
                            <asp:BoundField DataField="RefID" HeaderText="Ref ID" ReadOnly="True" SortExpression="RefID" />
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName"
                                ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                                ItemStyle-Font-Bold="true" />
                            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
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
                            <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                            <asp:TemplateField ShowHeader="false">
                                <ItemTemplate>
                                    <asp:Button ID="cmdAdd" runat="server" Text="Add" Enabled='<%# Eval("NameMatched") %>'
                                        CommandName="ADDCHILD" CommandArgument='<%# Eval("RefID") %>' />
                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmButtonExtenderAdd" TargetControlID="cmdAdd"
                                        ConfirmText="Do you want to Add this Payment as a Child?">
                                    </asp:ConfirmButtonExtender>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                        <EmptyDataTemplate>
                            Ref ID Not Found.
                        </EmptyDataTemplate>
                        <FooterStyle BackColor="#CCCC99" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <RowStyle BackColor="#F7F7DE" />
                    </asp:DetailsView>
                    <asp:SqlDataSource ID="SqlDataSource_Search" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                        SelectCommand="s_Passport_Payment_Search" SelectCommandType="StoredProcedure"
                        OnSelected="SqlDataSource_Search_Selected" InsertCommand="s_Passport_Payment_Ref_Link"
                        InsertCommandType="StoredProcedure" OnInserted="SqlDataSource_Search_Inserted">
                        <SelectParameters>
                            <asp:QueryStringParameter QueryStringField="refid" Name="Parent_RefID" Type="String" />
                            <asp:ControlParameter ControlID="txtRefIDAdd" Name="RefID" PropertyName="Text" Type="String" />
                            <asp:Parameter Name="Msg" Type="String" Size="255" Direction="InputOutput" DefaultValue=" " />
                            <asp:Parameter Name="NameMatched" Type="Boolean" Direction="InputOutput" DefaultValue="False" />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:QueryStringParameter QueryStringField="refid" Name="Parent_RefID" Type="String" />
                            <asp:ControlParameter ControlID="txtRefIDAdd" Name="RefID" PropertyName="Text" Type="String" />
                            <asp:Parameter Name="Msg" Type="String" Size="255" Direction="InputOutput" DefaultValue=" " />
                            <asp:Parameter Name="Done" Type="Boolean" DefaultValue="false" Direction="InputOutput" />
                            <asp:Parameter Name="NameMatched" Type="Boolean" Direction="InputOutput" DefaultValue="False" />
                            <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                </asp:Panel>
            </div>
            <asp:Panel ID="PanelVerificationReport" runat="server" CssClass="group" Style="display: table; margin-top: 50px">
                <h5>Passport Office Verification:</h5>
                <div style="padding: 0 10px">
                    <asp:GridView ID="GridView_CheckPayment_Log" runat="server" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                        CellPadding="4" DataKeyNames="ID" DataSourceID="SqlDataSource_CheckPayment_Log"
                        ForeColor="Black" GridLines="Vertical" CssClass="Grid" OnRowDataBound="GridView_CheckPayment_Log_RowDataBound">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName" />
                            <asp:BoundField DataField="amount" HeaderText="Amount" SortExpression="amount" DataFormatString="{0:N2}"
                                ItemStyle-HorizontalAlign="Right" />
                            <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" />
                            <asp:BoundField DataField="PassportEnrolmentDate" HeaderText="Enrolment Date" SortExpression="PassportEnrolmentDate"
                                DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="Msg" HeaderText="Response" SortExpression="Msg" ItemStyle-HorizontalAlign="Center" />
                            <asp:BoundField DataField="Reasons" HeaderText="Reasons" SortExpression="Reasons" />
                            <asp:TemplateField HeaderText="DT" SortExpression="DT">
                                <ItemTemplate>
                                    <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                        <%# TrustControl1.ToRecentDateTime(Eval("DT"))%>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="About" SortExpression="DT">
                                <ItemTemplate>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("DT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                        <SortedAscendingHeaderStyle BackColor="#848384" />
                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                        <SortedDescendingHeaderStyle BackColor="#575357" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource_CheckPayment_Log" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                        SelectCommand="s_Passport_CheckPayment_Log" SelectCommandType="StoredProcedure"
                        OnSelected="SqlDataSource_CheckPayment_Log_Selected">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
            </asp:Panel>

             <asp:Panel ID="PanelShowLog" Visible="false" runat="server" CssClass="group" Style="display: table; margin-top: 50px">
                <h4>Passport Payment Log Details:</h4>
                <div style="padding: 5px">
               
                  
                    <div class="group" style="padding: 5px">
                        <div>
                            <b>ITCL Response </b>
                        </div>

                        <asp:GridView ID="GridViewItclResp" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceItclResponse">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />
                                <asp:BoundField DataField="TransactionType" HeaderText="TransactionType" SortExpression="TransactionType" />
                                <asp:BoundField DataField="Currency" HeaderText="Currency" SortExpression="Currency" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                                <asp:BoundField DataField="ResponseCode" HeaderText="ResponseCode" SortExpression="ResponseCode" />
                                <asp:BoundField DataField="ResponseDescription" HeaderText="ResponseDescription" SortExpression="ResponseDescription" />
                                <asp:BoundField DataField="OrderStatus" HeaderText="OrderStatus" SortExpression="OrderStatus" />
                                <asp:BoundField DataField="ApprovalCode" HeaderText="ApprovalCode" SortExpression="ApprovalCode" />
                                <asp:BoundField DataField="PAN" HeaderText="PAN" SortExpression="PAN" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="Name" HeaderText="Name" SortExpression="Name" />
                                <asp:BoundField DataField="OrderDescription" HeaderText="OrderDescription" SortExpression="OrderDescription" />
                                <asp:BoundField DataField="AcqFee" HeaderText="AcqFee" SortExpression="AcqFee" />
                                <%--  <asp:BoundField DataField="xmlmsg" HeaderText="xmlmsg" SortExpression="xmlmsg" />--%>
                                <asp:BoundField DataField="MerchantTranID" HeaderText="MerchantTranID" SortExpression="MerchantTranID" />
                                <asp:BoundField DataField="Brand" HeaderText="Brand" SortExpression="Brand" />
                                <asp:BoundField DataField="ThreeDSStatus" HeaderText="ThreeDSStatus" SortExpression="ThreeDSStatus" />
                                <asp:BoundField DataField="ThreeDSVerificaion" HeaderText="ThreeDSVerificaion" SortExpression="ThreeDSVerificaion" />
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
                        <asp:SqlDataSource ID="SqlDataSourceItclResponse" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="s_Itcl_Response_Passport" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>

                    <div class="group" style="padding: 5px">
                        <div>
                            <b>ITCL GetOrderStatus/Payment Verification </b>
                        </div>

                        <asp:GridView ID="GridViewItclOrderStatus" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataSourceID="SqlDataSourceItclOrderStatus">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />
                                <asp:BoundField DataField="UID" HeaderText="UID" SortExpression="UID" />
                                <asp:BoundField DataField="OrderStatus" HeaderText="OrderStatus" SortExpression="OrderStatus" />
                                <asp:BoundField DataField="StatusCode" HeaderText="StatusCode" SortExpression="StatusCode" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="ErrorMsg" HeaderText="ErrorMsg" SortExpression="ErrorMsg" />
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
                        <asp:SqlDataSource ID="SqlDataSourceItclOrderStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [ITCL_GetOrderStatus_Log] WHERE ([RefID] = @RefID)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="group" style="padding: 5px">
                        <div>
                            <b>TBMM Response</b>
                        </div>

                        <asp:GridView ID="GridViewTbmmResp" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceTbmmResponce" OnRowCommand="GridViewTbmmResp_RowCommand">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="transaction_id" HeaderText="transaction_id" SortExpression="transaction_id" />
                                <asp:BoundField DataField="application_id" HeaderText="application_id" SortExpression="application_id" />
                                <asp:BoundField DataField="BillingCode" HeaderText="BillingCode" SortExpression="BillingCode" />
                                <asp:BoundField DataField="success" HeaderText="success" SortExpression="success" />
                                <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />

                                <asp:TemplateField HeaderText="Trns Check">
                                    <ItemTemplate>
               
                                        <asp:LinkButton runat="server" ID="lnkCheckTrans" ToolTip="Check Transaction" CommandName="TBMMTRNCHK"
                                            CausesValidation="false" CommandArgument='<%# Eval("transaction_id") %>'
                                            Visible='<%# (Eval("transaction_id").ToString() != "") %>'><img src="Images/mobile.png" width="16" height="16" border="0"/ ></asp:LinkButton>
                                       
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
                            <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <SortedAscendingCellStyle BackColor="#FBFBF2" />
                            <SortedAscendingHeaderStyle BackColor="#848384" />
                            <SortedDescendingCellStyle BackColor="#EAEAD3" />
                            <SortedDescendingHeaderStyle BackColor="#575357" />
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSourceTbmmResponce" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [TBMM_Response] WHERE ([application_id] = @application_id)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="application_id" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>

                    <div class="group" style="padding: 5px">
                        <div>
                            <b>Passport Trx Confirm Log (Tbmm Offline Payment)</b>
                        </div>

                        <asp:GridView ID="GridViewTrxLog" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" 
                            DataKeyNames="ID" DataSourceID="SqlDataSourceTrxLog">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                                
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="ReturnValue" HeaderText="ReturnValue" SortExpression="ReturnValue" />
                                <asp:BoundField DataField="MobileMoneyStatus" HeaderText="TBMM Status" SortExpression="MobileMoneyStatus" />
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

                        <asp:SqlDataSource ID="SqlDataSourceTrxLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Passport_ConfirmPassport_Log] WHERE ([RefID] = @RefID)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>

                    </div>
                </div>
            </asp:Panel>
            <asp:Panel ID="PanelPassportUnlock"  runat="server" CssClass="group" Style="display: table; margin-top: 50px">
                <h5>Passport Unlock List:</h5>
                <div style="padding: 0 10px">
                    <asp:GridView ID="grdPassportUnlock" runat="server" AutoGenerateColumns="False"
                        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                        CellPadding="4" DataKeyNames="ID" DataSourceID="SqlDataSource_Unlock_Log"
                        ForeColor="Black" GridLines="Vertical" CssClass="Grid">
                        <AlternatingRowStyle BackColor="White" />
                        <Columns>
                            
                            <asp:BoundField DataField="Reason" HeaderText="Reason" SortExpression="Reason" />
                            
                            
                            <asp:TemplateField HeaderText="Unlocked on" SortExpression="InsertDT">
                                <ItemTemplate>
                                    <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                        <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="About" SortExpression="InsertDT">
                                <ItemTemplate>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Unlocked by">
                                <ItemTemplate>

                                    <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("ByEmp") %>' />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                        <SortedAscendingHeaderStyle BackColor="#848384" />
                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                        <SortedDescendingHeaderStyle BackColor="#575357" />
                    </asp:GridView>
                    <asp:SqlDataSource ID="SqlDataSource_Unlock_Log" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                        SelectCommand="s_Passport_Unlock_Log" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Unlock_Log_Selected">
                        <SelectParameters>
                            <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                        </SelectParameters>
                    </asp:SqlDataSource>
                </div>
             
            </asp:Panel>
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
