<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CheckoutPayEdit.aspx.cs" Inherits="CheckoutPayEdit" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Payment Transaction Edit"></asp:Label>
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
                                <td>Checkout Ref ID: </td>
                                <td>
                                    <asp:TextBox ID="txtFilter" runat="server" AutoPostBack="True" CausesValidation="false" MaxLength="14" OnTextChanged="cmdOK_Click" Watermark="enter ref no" Width="130px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Button ID="cmdOK" runat="server" OnClick="cmdOK_Click" Text="Show" />
                                </td>
                            </tr>
                        </table>
                    </td>
                   

                </tr>
            </table>
          <asp:DetailsView ID="PaymentEdit" runat="server" AutoGenerateRows="False" CssClass="Grid"
                        BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                        CellPadding="4" DataSourceID="SqlPaymentEdit" ForeColor="Black" DataKeyNames="RefID"
                        GridLines="Vertical">

                        <FooterStyle BackColor="#CCCC99" />
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Middle" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                       <%-- <EmptyDataTemplate>
                            <asp:LinkButton ID="Button3" runat="server" Text="Add Other Expence/Income" CommandName="New" Width="200px" />
                        </EmptyDataTemplate>--%>
                        <Fields>
                          <%--  <asp:BoundField DataField="SL" HeaderText="SL" InsertVisible="False"
                                ReadOnly="True" SortExpression="SL" />--%>

                            <asp:TemplateField HeaderText="Ref ID" SortExpression="RefID">
                                <ItemTemplate>
                                     <a href='Checkout_Link.aspx?refid=<%# Eval("RefID") %>'><%# Eval("RefID") %></a>
                                </ItemTemplate>
                                <ItemStyle Font-Bold="true" Font-Size="Medium" />
                              <%--  <EditItemTemplate>
                                    <%# Bind("RefID") %>
                              </EditItemTemplate>--%>
                            </asp:TemplateField>

                           
                            <asp:TemplateField HeaderText="Order ID" SortExpression="OrderID">
                                <ItemTemplate>
                                    <asp:Label ID="LabelOrderID" runat="server" Text='<%# Bind("OrderID") %>'></asp:Label>
                                </ItemTemplate>
                               
                            </asp:TemplateField>
                           <asp:TemplateField HeaderText="Full Name" SortExpression="FullName">
                                <ItemTemplate>
                                    <asp:Label ID="LabelFullName" runat="server" Text='<%# Bind("FullName") %>'></asp:Label>
                                </ItemTemplate>
                               
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Amount" SortExpression="Amount">
                                <ItemTemplate>
                                    <asp:Label ID="LabelAmount" runat="server" Text='<%# Bind("Amount") %>'></asp:Label>
                                </ItemTemplate>
                               
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Payment Date" SortExpression="PaidDT">
                                <ItemTemplate>
                                       <div title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                  <%--  <b>Paid:</b><br />--%>
                                    <%# TrustControl1.ToRecentDateTime(Eval("PaidDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                                  <%--  <asp:Label ID="LabelPaydate" runat="server" Text='<%# Bind("PaidDT","{0:dd/MM/yyyy}") %>'></asp:Label>--%>
                                </ItemTemplate>
                               
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="Transaction Date" SortExpression="TrnDate">
                                <ItemTemplate>
                                    <%# Eval("TrnDate","{0:dd/MM/yyyy}") %>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtTrnsDate" runat="server" Width="75px" Watermark="dd/mm/yyyy"  Text='<%# Bind("TrnDate","{0:dd/MM/yyyy}") %>'
                                        CssClass="Date"></asp:TextBox>
                                </EditItemTemplate>
                                  <ItemStyle Font-Size="Medium" Font-Bold="true" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Remarks" SortExpression="Reason">
                                <ItemTemplate>
                                    <asp:Label ID="LabelRemarks" runat="server" Text='<%# Bind("Reason") %>'></asp:Label>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtRemarks" runat="server" Width="300px" Watermark="remarks"  Text='<%# Bind("Reason") %>'
                                       ></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="UpdateResion" ControlToValidate="txtRemarks" SetFocusOnError="True" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>
                                </EditItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                <ItemTemplate>
                                    <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit" />
                                  <%--  &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                        Text="New" />--%>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:Button ID="Button1" runat="server" CausesValidation="true" CommandName="Update" ValidationGroup="UpdateResion"
                                        Text="Update" />
                                    <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                        Enabled="True" TargetControlID="Button1">
                                    </asp:ConfirmButtonExtender>
                                    &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                        Text="Cancel" />
                                  <%--   <asp:RequiredFieldValidator ID="RequiredFieldValidator33" ValidationGroup="UpdateResion" ControlToValidate="Button1" SetFocusOnError="True" runat="server" ErrorMessage="*"></asp:RequiredFieldValidator>--%>
                                </EditItemTemplate>
                          
                                <ControlStyle Width="80px" />
                            </asp:TemplateField>

                        </Fields>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:DetailsView>
                    <asp:SqlDataSource ID="SqlPaymentEdit" runat="server"
                        ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                      
                     
                        SelectCommand="s_Checkout_TrnEditByRef"
                         SelectCommandType="StoredProcedure"
                        UpdateCommand="s_Checkout_TrnDate_Change"
                          OnUpdated="CheckoutTrnEditByRef_Updated"
                        UpdateCommandType="StoredProcedure">
                        <SelectParameters>
                            <asp:ControlParameter ControlID="txtFilter" Name="RefID"
                                PropertyName="Text" />
                        </SelectParameters>
                       
                        <UpdateParameters>
                          <%--  <asp:Parameter Direction="InputOutput" Name="RefID" Type="String" />--%>
                            <asp:Parameter Name="RefID" Type="String" />
                            <asp:Parameter Name="TrnDate" Type="DateTime" />
                            <asp:Parameter Name="Reason" Type="String" />
                           
                            <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                            <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                                Type="String" />
                          
                        </UpdateParameters>
                    </asp:SqlDataSource>
           
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
