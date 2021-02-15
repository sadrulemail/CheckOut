<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="MerchantPayCancel.aspx.cs" Inherits="MerchantPayCancel" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Merchant Payment Cancel"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div>
                   <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
            PageSize="20" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4"
            DataKeyNames="RefID" DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
            CssClass="Grid" PagerSettings-Position="TopAndBottom" PagerSettings-Mode="NumericFirstLast"
            PagerSettings-PageButtonCount="30"
            AllowSorting="false">
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
                        <uc2:emp id="EMP2" runat="server" username='<%# Eval("UpdateBy") %>' prefix="By: " />
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
                            <uc2:emp id="EMPCancel" runat="server" username='<%# Eval("CancelBy") %>' prefix="By: " />
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
                      
                    </ItemTemplate>
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
            SelectCommand="s_Checkout_Payment_Select" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:QueryStringParameter QueryStringField="refid" Name="RefID" Type="String" />
                <asp:Parameter Name="Msg" Direction="InputOutput" DefaultValue="" ConvertEmptyStringToNull="false"
                    Size="255" Type="String" />
            </SelectParameters>

        </asp:SqlDataSource>
            </div>
            <table>
                <tr>
                    <td>
                        <table class="Panel1">
                             <tr>
                                <td>Ref ID: </td>
                                <td>
                                    <asp:Label ID="lblRefId" runat="server" Text="Label"></asp:Label>
                                </td>
                                </tr>
                            <tr>
                                <td>Transaction ID: </td>
                                <td>
                                    <asp:Label ID="labelTransId" runat="server" Text="Label"></asp:Label>
                                </td>
                                </tr>
                            <tr>
                                <td>Cancel Reason: </td>
                                 <td>
                                     <asp:TextBox ID="txtReason" ToolTip="Cancel reason" Width="400px" runat="server"></asp:TextBox>
                                    
                                   
                                </td>
                                </tr>
                            <tr>
                                <td></td>
                                <td>
                                    <asp:Button ID="cmdOK" runat="server" OnClick="cmdOK_Click" Text="Merchant Payment Cancel" />
                                       <asp:RequiredFieldValidator ID="rfvCancelReason" ControlToValidate="txtReason"
                                        runat="server" SetFocusOnError="true"  Display="Dynamic"
                                        ErrorMessage="*" ForeColor="Red" Font-Bold="true"></asp:RequiredFieldValidator>
                                     <asp:ConfirmButtonExtender ID="cmdOK_ConfirmButtonExtender" runat="server"
                                    ConfirmText="Do you want to Cancel the Payment at Merchant End?" Enabled="True"
                                    TargetControlID="cmdOK"></asp:ConfirmButtonExtender>
                                </td>
                               
                            </tr>
                        </table>
                    </td>
                   

                </tr>
            </table>
         
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
