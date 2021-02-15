<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="MerchantDetailInf" Title="Merchant Detail" CodeFile="MerchantDetailInf.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Merchant Detail Setup
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="Panel1" style="padding: 7px;display:inline-block">
                <asp:DetailsView ID="ItemsDetailsView" runat="server" AutoGenerateRows="False" CssClass="Grid"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ID" DataSourceID="SqlItemsInsert" ForeColor="Black"
                    GridLines="Vertical">

                    <FooterStyle BackColor="#CCCC99" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Middle" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <%--   <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>--%>
                    <Fields>
                         <asp:TemplateField HeaderText="ID" SortExpression="ID">
                            <ItemTemplate>
                                <%# Eval("ID")%>
                            </ItemTemplate>
                            <EditItemTemplate>

                                <asp:Label ID="lblID" runat="server" Text='<%# Bind("ID") %>'></asp:Label>

                            </EditItemTemplate>
                        
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Marchent ID" SortExpression="CheckoutMerchantID">
                            <ItemTemplate>
                                <%# Eval("CheckoutMerchantID")%>
                            </ItemTemplate>
                            <EditItemTemplate>

                                <asp:Label ID="lblMerchantID" runat="server" Text='<%# Bind("CheckoutMerchantID") %>'></asp:Label>

                            </EditItemTemplate>
                            <ItemStyle Font-Bold="true" Font-Size="Large" />
                        
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Type" SortExpression="Type">
                            <ItemTemplate>
                                <%# Eval("Type")%>
                            </ItemTemplate>
                            <EditItemTemplate>

                                <asp:Label ID="lblType" runat="server" Text='<%# Bind("Type") %>'></asp:Label>
                            </EditItemTemplate>
                           
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Key Code" SortExpression="Keycode">
                            <ItemTemplate>
                                <%# Eval("Keycode")%>
                            </ItemTemplate>
                                                    
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UID" SortExpression="UID">
                            <ItemTemplate>
                                <%# Eval("UID")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtUID" runat="server" Text='<%# Bind("UID") %>'></asp:TextBox>

                            </EditItemTemplate>
                        
                        </asp:TemplateField>
                                           
                           <asp:TemplateField HeaderText="Password" SortExpression="Password">
                            <ItemTemplate>
                                <%# Eval("Password")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPassword" runat="server" Text='<%# Bind("Password") %>'></asp:TextBox>

                            </EditItemTemplate>
                        
                        </asp:TemplateField>
                           <asp:TemplateField HeaderText="Account No" SortExpression="AccountNo">
                            <ItemTemplate>
                                <%# Eval("AccountNo")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtAccountNo" runat="server" Text='<%# Bind("AccountNo") %>'></asp:TextBox>

                            </EditItemTemplate>
                        
                        </asp:TemplateField>
                            <asp:TemplateField HeaderText="Port No" SortExpression="PortNo">
                            <ItemTemplate>
                                <%# Eval("PortNo")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtPort" runat="server" Text='<%# Bind("PortNo") %>'></asp:TextBox>

                            </EditItemTemplate>
                        
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Active" SortExpression="Active">
                            <ItemTemplate>
                             
                                <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("Active") %>'
                                    Enabled="false" />
                            </ItemTemplate>
                        
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("Active") %>' />
                            </EditItemTemplate>
                        </asp:TemplateField>
                       
                        
                        <asp:TemplateField HeaderText="Pay with Charge" SortExpression="PayWithCharge">
                            <ItemTemplate>
                             
                                <asp:CheckBox ID="IsPayCharge" runat="server" Checked='<%# Bind("PayWithCharge") %>'
                                    Enabled="false" />
                            </ItemTemplate>
                        
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsPayCharge" runat="server" Checked='<%# Bind("PayWithCharge") %>' />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Allow EMI" SortExpression="AllowEMI">
                            <ItemTemplate>
                             
                                <asp:CheckBox ID="IsEmi" runat="server" Checked='<%# Bind("AllowEMI") %>'
                                    Enabled="false" />
                            </ItemTemplate>
                        
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsEmi" runat="server" Checked='<%# Bind("AllowEMI") %>' />
                            </EditItemTemplate>
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Pay with Charge Type" SortExpression="PayWithChargeType">
                            <ItemTemplate>
                                <%# Eval("PayWithChargeType")%>
                            </ItemTemplate>
                           <%-- <EditItemTemplate>
                                
                                <asp:DropDownList ID="txtChargeType" runat="server" SelectedValue='<%# Bind("PayWithChargeType")%>'>
                                    <asp:ListItem></asp:ListItem>
                                    <asp:ListItem>+</asp:ListItem>
                                    <asp:ListItem>-</asp:ListItem>

                                </asp:DropDownList>
                                                              

                            </EditItemTemplate>--%>
                        
                        </asp:TemplateField>

                        <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit" />
                              <%--  &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                    Text="New" />--%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" />
                                <cc1:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="Button1">
                                </cc1:ConfirmButtonExtender>
                                <asp:LinkButton ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:Button ID="cmdInsert" runat="server" CausesValidation="True" CommandName="Insert"
                                    Text="Insert" />
                                <cc1:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                    Enabled="True" TargetControlID="cmdInsert">
                                </cc1:ConfirmButtonExtender>
                            </InsertItemTemplate>
                            <ControlStyle Width="80px" />
                        </asp:TemplateField>

                    </Fields>
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:DetailsView>
                <asp:SqlDataSource ID="SqlItemsInsert" runat="server"
                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                 
                    OnUpdated="SqlItemsInsert_Updated"
                    SelectCommand="SELECT * FROM Checkout_Marchant_Details with (nolock) WHERE ID=@ID"
                    UpdateCommand="s_CheckoutMerchant_Detail_Info"
                    UpdateCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GdvItemList" Name="ID"
                            PropertyName="SelectedValue" />
                    </SelectParameters>
             

                    <UpdateParameters>
                        <asp:Parameter Name="AddEdit" Type="String" DefaultValue="EDIT" />
                        <asp:Parameter Name="ID" Type="Int32" />
                        <asp:Parameter Name="CheckoutMerchantID" Type="String" />
                        <asp:Parameter Name="UID" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                        <asp:Parameter Name="AccountNo" Type="String" />

                        <asp:Parameter Name="PortNo" Type="String" />
                        <asp:Parameter Name="Active" Type="Boolean" />
                        <asp:Parameter Name="AllowEMI" Type="Boolean" />
                        <asp:Parameter Name="PayWithCharge" Type="Boolean" />
                        <asp:Parameter Name="PayWithChargeType" Type="String" />
                     

                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>

            <br />
            <div class="content-start">
                <asp:GridView ID="GdvItemList" runat="server" CssClass="Grid"
                    AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ID" DataSourceID="SqlIMerchantListGrid" ForeColor="Black"
                    GridLines="Vertical" AllowPaging="True" PageSize="20" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom"
                    OnSelectedIndexChanging="GdvItemList_SelectedIndexChanging">
                    <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" PageButtonCount="30" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>
                            <asp:TemplateField >
                            <ItemTemplate>
                              <asp:LinkButton runat="server" ID="lnkEdit" CommandName="Select">
                                  <img src="Images/edit-label.png" />
                              </asp:LinkButton>

                            </ItemTemplate>
                            
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID" HeaderText="ID" Visible="False" ReadOnly="True"
                            SortExpression="ID" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="CheckoutMerchantID" HeaderText="Marchent ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="CheckoutMerchantID" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle Font-Bold="true" HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />

                        
                        <asp:BoundField DataField="UID" HeaderText="UID" SortExpression="UID" />
                        <asp:BoundField DataField="Password" HeaderText="Password" SortExpression="Password" />
                        <asp:BoundField DataField="AccountNo" HeaderText="Account No" SortExpression="AccountNo" />

                        <asp:TemplateField HeaderText="Active" SortExpression="Active">
                            <ItemTemplate>
                                <%# Eval("Active").ToString() == "True" ? "<img src='Images/Tick.png' title='Verified' width='32' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Pay With Charge" SortExpression="PayWithCharge">
                            <ItemTemplate>
                                <%# Eval("PayWithCharge").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                       <asp:TemplateField HeaderText="Allow EMI" SortExpression="AllowEMI">
                            <ItemTemplate>
                                <%# Eval("AllowEMI").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        
                        <asp:BoundField DataField="PayWithChargeType" HeaderText="Pay with Charge Type" SortExpression="PayWithChargeType" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="PortNo" HeaderText="Port" SortExpression="PortNo" ItemStyle-HorizontalAlign="Center" />

                     
                        <asp:BoundField DataField="Keycode" HeaderText="Key Code" SortExpression="Keycode" />
                       
                        <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                            <ItemTemplate>
                                 <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' /><br />
                                <span title='<%# Eval("InsertDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%></span>
                            </ItemTemplate>
                            <ItemStyle Font-Size="X-Small" ForeColor="Gray" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Modify" SortExpression="UpdateDT">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' /><br />
                                <span title='<%# Eval("UpdateDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("UpdateDT"))%></span>
                            </ItemTemplate>
                            <ItemStyle Font-Size="X-Small" ForeColor="Gray" />
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
                </asp:GridView>
                <asp:SqlDataSource ID="SqlIMerchantListGrid" runat="server"
                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="select * from Checkout_Marchant_Details with (nolock) WHERE CheckoutMerchantID=@MerchantID"
                    OnSelected="SqlMerchantListGrid_Selected" ProviderName="<%$ ConnectionStrings:PaymentsDBConnectionString.ProviderName %>">
                    <SelectParameters>

                        <asp:QueryStringParameter QueryStringField="merchantid" Name="MerchantID" Type="String" />
                    </SelectParameters>


                </asp:SqlDataSource>
                <br />
                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                <br />

            </div>


        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
