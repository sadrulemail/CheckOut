<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Checkout_Link.aspx.cs" Inherits="Checkout_Link" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Checkout Receipt"></asp:Label>
    <%--  <style>
        .div-edit {
            margin-bottom: 7px;
        }
    </style>--%>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>

            <div style="display:inline-block;vertical-align:middle">
                <table class="Panel1" style="margin-right: 10px;display:inline-block;vertical-align:middle">
                    <tr>
                        <td>Checkout Ref ID:
                        </td>
                        <td>
                            <asp:TextBox ID="txtFilter" runat="server" Watermark="enter ref no" MaxLength="14"
                                Width="130px" AutoPostBack="True" CausesValidation="false" OnTextChanged="cmdOK_Click"></asp:TextBox>
                        </td>
                        <%--<td style="padding-left: 10px">
                        Branch:
                    </td>
                    <td>
                        <asp:DropDownList ID="dboBranch" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                            DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                            OnDataBound="cboBranch_DataBound">
                            <asp:ListItem Value="-1" Text="All Branch"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                            SelectCommand="SELECT [BranchID], [BranchName] FROM [ViewBranchOnly] ORDER BY [BranchName]">
                        </asp:SqlDataSource>
                    </td>
                    <td style="padding-left: 10px">
                        Department:
                    </td>
                    <td>
                        <asp:DropDownList ID="dboDept" runat="server" AppendDataBoundItems="True" AutoPostBack="True"
                            DataSourceID="SqlDataSourceDept" DataTextField="Department" DataValueField="DeptID"
                            OnDataBound="dboDept_DataBound">
                            <asp:ListItem Value="-1" Text="All Department"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:SqlDataSource ID="SqlDataSourceDept" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                            SelectCommand="SELECT DeptID, Department FROM dbo.ViewDept order by Department">
                        </asp:SqlDataSource>
                    </td>--%>
                        <td>
                            <asp:Button ID="cmdOK" runat="server" Text="Show" OnClick="cmdOK_Click" />
                        </td>
                    </tr>
                </table>
                <table style="display:inline-block;border: 1px silver solid; padding: 0 5px 0 0;margin-right:10px; border-radius: 8px;vertical-align:middle"
                    class="Shadow">
                    <tr>
                        <td>
                            <asp:HyperLink ID="lblImage" runat="server" Target="_blank" ToolTip="Visit Marchent Site"></asp:HyperLink>
                            <asp:HiddenField ID="hiddenAccNo" runat="server" />
                            <asp:HiddenField ID="hiddenMerchantID" runat="server" />
                        </td>
                        <td>
                            <asp:HyperLink ID="lblMarchentID" Target="_blank" runat="server" Text="" Style="font-weight: bold; color: Black;"
                                ToolTip="Visit Merchant Site"></asp:HyperLink>
                        </td>

                    </tr>
                </table>

            </div>

            <div style="display:inline-block" >
                <asp:HyperLink ID="lblPullData" Target="_blank" runat="server" Text="Pull data" Style="font-weight: bold; color: Black;" Visible="false"
                    ToolTip="Pull data from BGSL Server"></asp:HyperLink>


            </div>
            <div style="display:inline-block">
                <%--       <asp:HyperLink ID="hLinkPushData" Target="_blank" runat="server" Text="Push data"  Style="font-weight: bold; color: Black;" visible="false"
                                ToolTip="Push data to Server"></asp:HyperLink>--%>
                <asp:Button ID="btnPushData" runat="server" Text="Push Data" Visible="false" OnClick="btnPushData_Click" />

            </div>

             

            <div style="clear: left">
            </div>
            <div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                    PageSize="20" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4"
                    DataKeyNames="RefID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
                    CssClass="Grid" PagerSettings-Position="TopAndBottom" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-PageButtonCount="30" OnDataBound="GridView1_DataBound" OnRowDataBound="GridView1_RowDataBound"
                    OnRowCommand="GridView1_RowCommand" AllowSorting="false">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <a target="_blank" href='Checkout_Payment_Receipt.ashx?refid=<%# Eval("RefID") %>&key=<%# Eval("keycode")%>&merid=<%# Eval("MarchentID")%>'
                                    class='<%# (bool)Eval("ShowPrintButton") == false ? "hidden" : "" %>' title="Print Receipt">
                                    <img alt="Print" src="Images/print-icon.png" width="36" height="36" />
                                </a>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Details">
                            <ItemTemplate>
                                <div style="font-size: 130%; font-weight: bold">
                                    <%# Eval("RefID")%>
                                </div>
                                <div style="font-size: 110%; font-weight: bold">
                                    <%# Eval("FullName")%>
                                </div>
                                <%# Eval("Email", "<div title='Email'>{0}</div>")%>
                                <%# Eval("NotifyMobile", "<div title='Notify Mobile'>{0}</div>")%>
                                <div title='<%# Eval("M1_Description_Eng","{0}")%><%# Eval("M1_Description_Ban","\n{0}")%>'>
                                    <%# Eval("Meta1_Label","{0}:")%>
                                    <%# Eval("Meta1","{0}")%>
                                </div>
                                <div title='<%# Eval("M2_Description_Eng","{0}")%><%# Eval("M2_Description_Ban","\n{0}")%>'>
                                    <%# Eval("Meta2_Label","{0}:")%>
                                    <%# Eval("Meta2","{0}")%>
                                </div>
                                <div title='<%# Eval("M3_Description_Eng","{0}")%><%# Eval("M3_Description_Ban","\n{0}")%>'>
                                    <%# Eval("Meta3_Label","{0}:")%>
                                    <%# Eval("Meta3","{0}")%>
                                </div>
                                <div title='<%# Eval("M4_Description_Eng","{0}")%><%# Eval("M4_Description_Ban","\n{0}")%>'>
                                    <%# Eval("Meta4_Label","{0}:")%>
                                    <%# Eval("Meta4","{0}")%>
                                </div>
                                <div title='<%# Eval("M5_Description_Eng","{0}")%><%# Eval("M5_Description_Ban","\n{0}")%>'>
                                    <%# Eval("Meta5_Label","{0}:")%>
                                    <%# Eval("Meta5","{0}")%>
                                </div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div style="font-size: 130%; font-weight: bold" class="div-edit">
                                    <%# Eval("RefID")%>
                                </div>
                                <div style="white-space: normal">
                                    <div class="div-edit">
                                        Full Name<br />
                                        <asp:TextBox ID="txtName" runat="server" Text='<%# Bind("FullName") %>' Width="300px"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ID="req_Name" Display="Dynamic" ForeColor="Red"
                                            ControlToValidate="txtName" SetFocusOnError="true" ErrorMessage="*"></asp:RequiredFieldValidator>
                                    </div>
                                    <%--  <br />--%>
                                    <div class="div-edit">
                                        Email<br />
                                        <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' Width="300px"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                            ErrorMessage="Invalid Email" SetFocusOnError="True" Display="Dynamic" ForeColor="Red"
                                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                    </div>
                                    <%--  <br />--%>
                                    <div class='div-edit <%# Eval("Meta1_Label").ToString() == "" ? "hidden" : "" %>'>
                                        <%# Eval("Meta1_Label") %><br />
                                        <asp:TextBox runat="server" ID="txtMeta1" Text='<%# Bind("Meta1") %>' MaxLength="100"
                                            placeholder='<%# Eval("Meta1_Label").ToString() %>' Enabled='<%# Eval("Meta1_ReadOnly") %>'
                                            Width="280px"></asp:TextBox>
                                    </div>
                                    <%--  <br />--%>
                                    <div class='div-edit <%# Eval("Meta2_Label").ToString() == "" ? "hidden" : "" %>'>
                                        <%# Eval("Meta2_Label") %><br />
                                        <asp:TextBox runat="server" ID="txtMeta2" placeholder='<%# Eval("Meta2_Label").ToString() %>'
                                            Text='<%# Bind("Meta2") %>' Enabled='<%# Eval("Meta2_ReadOnly") %>' MaxLength="100"
                                            Width="280px"></asp:TextBox>
                                    </div>
                                    <%--  <br />--%>
                                    <div class='div-edit <%# Eval("Meta3_Label").ToString() == "" ? "hidden" : "" %>'>
                                        <%# Eval("Meta3_Label") %><br />
                                        <asp:TextBox runat="server" ID="txtMeta3" placeholder='<%# Eval("Meta3_Label").ToString() %>'
                                            Text='<%# Bind("Meta3") %>' Enabled='<%# Eval("Meta3_ReadOnly") %>' MaxLength="100"
                                            Width="280px"></asp:TextBox>
                                    </div>
                                    <%--  <br />--%>
                                    <div class='div-edit <%# Eval("Meta4_Label").ToString() == "" ? "hidden" : "" %>'>
                                        <%# Eval("Meta4_Label") %><br />
                                        <asp:TextBox runat="server" ID="txtMeta4" placeholder='<%# Eval("Meta4_Label").ToString() %>'
                                            Text='<%# Bind("Meta4") %>' Enabled='<%# Eval("Meta4_ReadOnly") %>' MaxLength="100"
                                            Width="280px"></asp:TextBox>
                                    </div>
                                    <%--  <br />--%>
                                    <div class='div-edit <%# Eval("Meta5_Label").ToString() == "" ? "hidden" : "" %>'>
                                        <%# Eval("Meta5_Label") %><br />
                                        <asp:TextBox runat="server" ID="txtMeta5" placeholder='<%# Eval("Meta5_Label").ToString() %>'
                                            Text='<%# Bind("Meta5") %>' Enabled='<%# Eval("Meta5_ReadOnly") %>' MaxLength="100"
                                            Width="280px"></asp:TextBox>
                                    </div>
                                    <%--  <br />--%>
                                    <div class="div-edit">
                                        Edit Reason<br />
                                        <asp:TextBox runat="server" ID="txtPassportUpdateReason" placeholder="Reason" Text='<%# Bind("UpdateReason") %>'
                                            MaxLength="255" Width="300px"></asp:TextBox>
                                        <asp:RequiredFieldValidator runat="server" ID="reqReason" ControlToValidate="txtPassportUpdateReason"
                                            ErrorMessage="*">
                                        </asp:RequiredFieldValidator>
                                    </div>
                                    <%-- <br />--%>
                                </div>
                                <div>
                                    <asp:Button ID="lnkUpdate" CommandName="Update" runat="server" Text="Update" />
                                    <asp:ConfirmButtonExtender runat="server" ID="con_Update" TargetControlID="lnkUpdate"
                                        ConfirmText="Do you want to Update?">
                                    </asp:ConfirmButtonExtender>
                                    <asp:Button ID="lnkCancel" CommandName="Cancel" runat="server" CausesValidation="false"
                                        Text="Cancel" />
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Amount" SortExpression="TotalAmount" Visible="false">
                            <ItemTemplate>
                                <%# Eval("TotalAmount","{0:N2}")%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Right" Font-Bold="true" Font-Size="Medium" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Amount">
                            <ItemTemplate>
                                <table width="100%" class="noborder">


                                    <%# Eval("TotalFees","<tr><td><b>Fee:</td><td class='right'>{0:N2}</b></td></tr>")%>
                                    <%# (Eval("TotalVatAmount").ToString() == "0.00" ? "" : Eval("TotalVatAmount","<tr><td><b>Vat Amount:</td><td class='right'>{0:N2}</b></td></tr>")) %>
                                    <%# Eval("TotalServiceCharge","<tr><td><b>Service Charge:</td><td class='right'>{0:N2}</b></td></tr>")%>
                                    <%# (Eval("TotalInterestAmount").ToString() == "0.00" ? "" : Eval("TotalInterestAmount","<tr><td><b>EMI Interest:</td><td class='right'>{0:N2}</b></td></tr>")) %>
                                    <%# Eval("TotalAmount","<tr><td><b>Total Amount:</td><td class='right bold' style='font-size:Medium'>{0:N2}</b></td></tr>")%>
                                </table>

                            </ItemTemplate>
                            <ItemStyle />
                        </asp:TemplateField>
                        <%--  <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right" ReadOnly="true">
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>--%>
                        <asp:TemplateField HeaderText="Type/ Status" SortExpression="Type">
                            <ItemTemplate>
                                <%# Eval("Type") %>
                                <div title='<%# Eval("Status","{0}")%>'>
                                    <%# Eval("StatusName","<b>{0}</b>")%>
                                </div>
                                <%--  <div>
                                    <img src='Images/<%# Eval("Verified").ToString() == "True" ? "verified.png" : "Not_Verified.png" %>' width="20" title='<%# Eval("Verified").ToString() == "True" ? "Verified" : "Not Verified" %>' />
                                </div>--%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Verified" SortExpression="Verified">
                            <ItemTemplate>

                                <div>
                                    <img src='Images/<%# Eval("Verified").ToString() == "True" ? "verified.png" : "Not_Verified.png" %>' width="20" title='<%# Eval("Verified").ToString() == "True" ? "Verified" : "Not Verified" %>' />
                                </div>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Wrap="false" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="On">
                            <ItemTemplate>
                                <div title='<%# Eval("InsertDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <b>Insert:</b><br />
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>

                                <div title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <b>Paid:</b><br />
                                    <%# TrustControl1.ToRecentDateTime(Eval("PaidDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>

                                <div>

                                    <%# Eval("TrnDate","<b>Trn Date:<br>{0:dd/MM/yyyy}</b>")%>
                                    <%# Eval("RefID","<div><a href='CheckoutPayEdit.aspx?refid={0}'><img src='Images/edit-label.png' title='Edit Trn Date'></a></div>") %>
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
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                <%# Eval("UpdateReason","<div class='bold' title='Update Reason'>{0}</div>") %>
                                <asp:HyperLink runat="server" ID="hypHistory" Target="_blank" NavigateUrl='<%# Eval("RefID","Checkout_Edit_History.aspx?refid={0}")%>'
                                    Visible='<%# TrustControl1.isRole("ADMIN") && Eval("UpdateBy").ToString() != "" %>'>
                                <img src="Images/History-icon.png" width="20" height="20" border="0" />
                                </asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Cancel on" SortExpression="CancelDT">
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
                        <asp:TemplateField HeaderText="Used on" SortExpression="UsedDT">
                            <ItemTemplate>
                                <div>
                                    <img src='Images/<%# Eval("Used").ToString() == "True" ? "verified.png" : "Not_Verified.png" %>' width="20" title='<%# Eval("Used").ToString() == "True" ? "Used" : "Not Used" %>' />
                                </div>
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
                                    CausesValidation="false" CommandArgument='<%# Eval("TransactionID","{0}") + "|" + Eval("Amount","{0:N2}") %>'
                                    Visible='<%# (Eval("TransactionID").ToString() != "" && Eval("SenderMobile").ToString() != "" ) %>'><img src="Images/mobile.png" width="16" height="16" border="0"/ ></asp:LinkButton>
                                <%# Eval("MarchentID", "<div title='Marchent ID'>{0}</div>")%>
                                <div class='<%# Eval("MarchentID").ToString() == "WZPDCL" ? "" : "hidden" %>'>
                                    <a href='WestZonePayCancel.aspx?transid=<%# Eval("TransactionID") %>&refid=<%# Eval("RefID") %>'
                                        target="_blank" title="Payment Cancel">Payment Cancel</a>

                                </div>
                                 <div class='<%# (bool)Eval("ShowPayCancelButton") ? "" : "hidden" %>'>
                                    <a href='MerchantPayCancel.aspx?transid=<%# Eval("MarchentID") %>&refid=<%# Eval("RefID") %>'
                                        target="_blank" title="Payment Cancel">Payment Cancel</a>

                                </div>
                                <div class='<%# (bool)Eval("AllowMerchantServicePush") ? "" : "hidden" %>'>               
                                     <a id="hLinkPushData" href='MerchantDataPush.aspx?refid=<%= Request.QueryString["refid"] %>' target="_blank" 
                                        >Merchant Push</a>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <span id="idEdit">
                                    <asp:LinkButton runat="server" ID="lnkEdit" ToolTip="Edit" CommandName="Edit" CommandArgument='<%# Eval("RefID") %>'
                                        CausesValidation="false" Visible='<%# !(bool)Eval("Used") && Eval("Status").ToString() != "9" && Eval("Status").ToString() != "0" %>'> <img src="Images/edit-label.png" width="20" height="20" border="0" /></asp:LinkButton>
                                </span><span id="idCancelreason" class="hidden">
                                    <asp:TextBox runat="server" ID="txtPassportDeleteReason" placeholder="Cancel reason"
                                        Text='<%# Bind("CancelReason") %>' ValidationGroup="Cancel" MaxLength="255" Width="200px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvCancelReason" ControlToValidate="txtPassportDeleteReason"
                                        runat="server" SetFocusOnError="true" ValidationGroup="Cancel" Display="Dynamic"
                                        ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                                    <br />
                                    <asp:LinkButton runat="server" ID="lnkCANCELED" Style="margin-left: 7px" ToolTip="Mark as CANCELED"
                                        CommandName="CANCELED" CommandArgument='<%# Eval("RefID") %>' Visible='<%# !(bool)Eval("Used") && Eval("Status").ToString() != "9"  && TrustControl1.isRole("ADMIN") %>'
                                        CssClass="button1" ValidationGroup="Cancel">Mark as Cancel</asp:LinkButton>
                                    <asp:ConfirmButtonExtender runat="server" ID="conCANCELED" TargetControlID="lnkCANCELED"
                                        ConfirmText="Are you sure you want to mark as CANCELED?">
                                    </asp:ConfirmButtonExtender>
                                </span><span style="white-space: nowrap" class='<%# (!(bool)Eval("Used") && Eval("Status").ToString() != "9" &&  TrustControl1.isRole("ADMIN")) == true ? "" : "hidden" %>'>
                                    <a href="" id="cancelBtnclient" onclick='$("#idCancelreason").show();$(this).hide();$("#idEdit").hide();$("#cancelCloseBtnclient").show();return false'>
                                        <img src="Images/delete.png" width="16" height="16" border="0" /></a> <a href=""
                                            class="hidden" id="cancelCloseBtnclient" onclick='$("#idCancelreason").hide();$(this).hide();$("#idEdit").show();$("#cancelBtnclient").show();return false'>Close</a> </span>
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
                    SelectCommand="s_Checkout_Payment_Select" SelectCommandType="StoredProcedure"
                    UpdateCommand="s_Checkout_Name_Update" UpdateCommandType="StoredProcedure" OnUpdated="SqlDataSource1_Updated"
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
                        <asp:Parameter Name="Meta1" Type="String" />
                        <asp:Parameter Name="Meta2" Type="String" />
                        <asp:Parameter Name="Meta3" Type="String" />
                        <asp:Parameter Name="Meta4" Type="String" />
                        <asp:Parameter Name="Meta5" Type="String" />
                        <asp:Parameter Name="UpdateReason" Type="String" Size="255" />
                        <asp:SessionParameter Name="EmpID" SessionField="EMPID" Type="String" />
                        <asp:Parameter Name="Msg" Type="String" DefaultValue="" Size="255" Direction="InputOutput" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>
            <div style="padding-left: 50px">
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="White"
                    BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="RefID"
                    DataSourceID="SqlDataSource2" ForeColor="Black" GridLines="Vertical" CssClass="Grid" OnRowDataBound="GridView2_RowDataBound"
                    OnRowCommand="GridView2_RowCommand">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:TemplateField HeaderText="Child Details" SortExpression="FullName">
                            <ItemTemplate>
                                <div style="font-size: 120%; font-weight: bold; color: Gray">
                                    <%# Eval("RefID")%>
                                </div>
                                <div style="font-size: 110%; font-weight: bold">
                                    <%# Eval("FullName")%>
                                </div>
                                <%# Eval("Email", "<div title='Email'>{0}</div>")%>
                                <%# Eval("NotifyMobile", "<div title='Notify Mobile'>{0}</div>")%>
                                <div title='<%# Eval("Meta1_Label","{0}")%>'>
                                    <%# Eval("Meta1","{0}")%>
                                </div>
                                <div title='<%# Eval("Meta2_Label","{0}")%>'>
                                    <%# Eval("Meta2","{0}")%>
                                </div>
                                <div title='<%# Eval("Meta3_Label","{0}")%>'>
                                    <%# Eval("Meta3","{0}")%>
                                </div>
                                <div title='<%# Eval("Meta4_Label","{0}")%>'>
                                    <%# Eval("Meta4","{0}")%>
                                </div>
                                <div title='<%# Eval("Meta5_Label","{0}")%>'>
                                    <%# Eval("Meta5","{0}")%>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" DataFormatString="{0:N2}"
                            ItemStyle-HorizontalAlign="Right">
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
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
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' Prefix="By: " />
                                <%# Eval("UpdateReason","<div class='bold' title='Reason'>{0}</div>") %>
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
                                <%# Eval("EID","<div title='EID'>{0}</div>") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Linked On">
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
                                <%# Eval("MarchentID", "<div title='Marchent ID'>{0}</div>")%>
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
                    SelectCommand="s_Checkout_Payment_Select_Child" SelectCommandType="StoredProcedure"
                    DeleteCommand="s_Checkout_Payment_Ref_Link_Delete" DeleteCommandType="StoredProcedure"
                    OnDeleted="SqlDataSource2_Deleted" OnDeleting="SqlDataSource2_Deleting">
                    <DeleteParameters>
                        <asp:Parameter Name="RefID" Type="String" />
                        <asp:Parameter Name="ParentRefID" Type="String" />
                        <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                        <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                    </DeleteParameters>
                    <SelectParameters>
                        <asp:QueryStringParameter QueryStringField="refid" Name="ParentRefID" Type="String" />
                        <asp:Parameter Name="Msg" Direction="InputOutput" DefaultValue="" ConvertEmptyStringToNull="false"
                            Size="255" Type="String" />
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
                            <asp:TemplateField HeaderText="Child Details">
                                <ItemTemplate>

                                    <div title='<%# Eval("Meta1_Label","{0}")%>'>
                                        <%# Eval("Meta1","{0}")%>
                                    </div>
                                    <div title='<%# Eval("Meta2_Label","{0}")%>'>
                                        <%# Eval("Meta2","{0}")%>
                                    </div>
                                    <div title='<%# Eval("Meta3_Label","{0}")%>'>
                                        <%# Eval("Meta3","{0}")%>
                                    </div>
                                    <div title='<%# Eval("Meta4_Label","{0}")%>'>
                                        <%# Eval("Meta4","{0}")%>
                                    </div>
                                    <div title='<%# Eval("Meta5_Label","{0}")%>'>
                                        <%# Eval("Meta5","{0}")%>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
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
                                    <asp:Button ID="cmdAdd" runat="server" Text="Add" CommandName="ADDCHILD" CommandArgument='<%# Eval("RefID") %>' />
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
                        SelectCommand="s_Checkout_Payment_Search" SelectCommandType="StoredProcedure"
                        OnSelected="SqlDataSource_Search_Selected" InsertCommand="s_Checkout_Payment_Ref_Link"
                        InsertCommandType="StoredProcedure" OnInserted="SqlDataSource_Search_Inserted">
                        <SelectParameters>
                            <asp:QueryStringParameter QueryStringField="refid" Name="Parent_RefID" Type="String" />
                            <asp:ControlParameter ControlID="txtRefIDAdd" Name="RefID" PropertyName="Text" Type="String" />
                            <asp:Parameter Name="Msg" Type="String" Size="255" Direction="InputOutput" DefaultValue=" " />
                        </SelectParameters>
                        <InsertParameters>
                            <asp:QueryStringParameter QueryStringField="refid" Name="Parent_RefID" Type="String" />
                            <asp:ControlParameter ControlID="txtRefIDAdd" Name="RefID" PropertyName="Text" Type="String" />
                            <asp:Parameter Name="Msg" Type="String" Size="255" Direction="InputOutput" DefaultValue=" " />
                            <asp:Parameter Name="Done" Type="Boolean" DefaultValue="false" Direction="InputOutput" />
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
                        ForeColor="Black" GridLines="Vertical" CssClass="Grid">
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
                <h4>Checkout Payment Log Details:</h4>
                <div style="padding: 5px">
                    <div class="group" style="padding: 5px">
                        <div><b>Checkout Payment Verify Log</b></div>

                        <asp:GridView ID="GridViewCheckoutVLog" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceCheckoutVLog">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />

                                <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />
                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="Verify_Status" HeaderText="Verify_Status" SortExpression="Verify_Status" />
                                <asp:CheckBoxField DataField="isWebserviceCalled" HeaderText="isWebserviceCalled" SortExpression="isWebserviceCalled" />
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
                        <asp:SqlDataSource ID="SqlDataSourceCheckoutVLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [CheckoutPaymentVerifyLog] with (Nolock) WHERE ([RefID] = @RefID) order by ID">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <div class="group" style="padding: 5px">
                        <div>
                            <b>Merchant Service Push Update Log</b>
                        </div>


                        <asp:GridView ID="GridViewNIDPayCLog" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataSourceID="SqlDataSourceNIDConfLog">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />

                                <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="ServiceResult" HeaderText="ServiceResult" SortExpression="ServiceResult" />
                                <asp:BoundField DataField="ServiceStatus" HeaderText="ServiceStatus" SortExpression="ServiceStatus" />
                                <asp:BoundField DataField="Meta1" HeaderText="Meta1" SortExpression="Meta1" />
                                <asp:BoundField DataField="Meta2" HeaderText="Meta2" SortExpression="Meta2" />

                                <asp:BoundField DataField="Meta3" HeaderText="Meta3" SortExpression="Meta3" />
                                <asp:BoundField DataField="Meta4" HeaderText="Meta4" SortExpression="Meta4" />
                                <asp:BoundField DataField="Meta5" HeaderText="Meta5" SortExpression="Meta5" />
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
                        <asp:SqlDataSource ID="SqlDataSourceNIDConfLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Merchant_Service_Push_Update_Log] WHERE ([RefID] = @RefID)" OnSelected="SqlDataSourceNIDConfLog_Selected">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                    <asp:Panel ID="panelBtcl" runat="server" Visible="false">
                     <div class="group" style="padding: 5px">
                        <div>
                            <b>BTCL Bill Ledger Status</b>
                        </div>


                        <asp:GridView ID="GridViewBtcl" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False"
                             DataSourceID="SqlDataSourceBtclLedger">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                 <asp:BoundField DataField="RefID_Merchant" HeaderText="RefID Merchant" SortExpression="RefID_Merchant" />
                                                            
                                <asp:BoundField DataField="StatusName" HeaderText="Status" SortExpression="StatusName" />
                                <asp:BoundField DataField="Used" HeaderText="Used" SortExpression="Used" />
                                <asp:BoundField DataField="ServiceStatus" HeaderText="ServiceStatus" SortExpression="ServiceStatus" />
                               
                                 <asp:BoundField DataField="BTCLAmount" HeaderText="BTCLAmount" SortExpression="BTCLAmount" />
                                 <asp:BoundField DataField="VatAmount" HeaderText="VatAmount" SortExpression="VatAmount" />

                                <asp:BoundField DataField="ExchangeCode" HeaderText="ExchangeCode" SortExpression="ExchangeCode" />
                                <asp:BoundField DataField="PhoneNumber" HeaderText="PhoneNumber" SortExpression="PhoneNumber" />
                                <asp:BoundField DataField="LastPayDate"  DataFormatString="{0:dd/MM/yyyy}" HeaderText="LastPayDate" SortExpression="LastPayDate" />

                                 <asp:BoundField DataField="BillMonth" HeaderText="BillMonth" SortExpression="BillMonth" />
                                <asp:BoundField DataField="BillYear" HeaderText="BillYear" SortExpression="BillYear" />
                               
                                <asp:BoundField DataField="BillPayStatus" HeaderText="BillPayStatus" SortExpression="BillPayStatus" />
                                <asp:BoundField DataField="BillStatus" HeaderText="BillStatus" SortExpression="BillStatus" />

                                 
                                <asp:BoundField DataField="UsedDT" HeaderText="UsedDT" SortExpression="UsedDT" />
                                <asp:BoundField DataField="InsertDT" HeaderText="InsertDT" SortExpression="InsertDT" />
                                 <asp:BoundField DataField="CancelDT" HeaderText="CancelDT" SortExpression="CancelDT" />
                                 <asp:BoundField DataField="RowNumber" HeaderText="RowNumber" SortExpression="RowNumber" />
                                <asp:BoundField DataField="BillID" HeaderText="BillID" SortExpression="BillID" />
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
                        <asp:SqlDataSource ID="SqlDataSourceBtclLedger" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" 
                            SelectCommand="SELECT *,s.Status AS StatusName FROM [BTCL_Bill_Ledger]  AS b 
                                    inner join Status_Checkout AS s ON s.StatusID=b.Status WHERE ([RefID] = @RefID)" 
                            OnSelected="SqlDataSourceBtclLedger_Selected">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                    </div>
                         </asp:Panel>

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
                        <asp:SqlDataSource ID="SqlDataSourceItclResponse" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="s_Itcl_Response_Show" SelectCommandType="StoredProcedure">
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
                            <b>Checkout Trx Confirm Log (Tbmm Offline Payment)</b>
                        </div>

                        <asp:GridView ID="GridViewTrxLog" runat="server" CssClass="Grid" ForeColor="Black" GridLines="Vertical" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceTrxLog">
                            <AlternatingRowStyle BackColor="White" />
                            <Columns>
                                <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                                <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                                <asp:BoundField DataField="TrnID" HeaderText="TrnID" SortExpression="TrnID" />
                                <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                                <asp:BoundField DataField="ReturnValue" HeaderText="ReturnValue" SortExpression="ReturnValue" />
                                <asp:BoundField DataField="MobileNo" HeaderText="MobileNo" SortExpression="MobileNo" />
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

                        <asp:SqlDataSource ID="SqlDataSourceTrxLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Checkout_TrxConfirm_Log] WHERE ([RefID] = @RefID)">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                            </SelectParameters>
                        </asp:SqlDataSource>

                    </div>
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
