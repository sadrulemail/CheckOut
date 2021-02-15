<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="MerchantInf" Title="Merchant" CodeFile="MerchantSeviceCharge.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Service Charge Setup
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="Panel1" style="padding: 7px; display: inline-block">
                <asp:DetailsView ID="ItemsDetailsView" runat="server" AutoGenerateRows="False" CssClass="Grid"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ID" DataSourceID="SqlItemsInsert" ForeColor="Black"
                    GridLines="Vertical">

                    <FooterStyle BackColor="#CCCC99" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Middle" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>
                    <Fields>
                        <asp:TemplateField HeaderText="Marchent ID" SortExpression="MerchantID">
                            <ItemTemplate>
                                <%# Eval("MerchantID")%>
                            </ItemTemplate>
                            <%-- <EditItemTemplate>
                                <asp:Label ID="txtMerchantID" runat="server" Text='<%# Bind("MarchentID") %>' MaxLength="255"></asp:Label>
                              
                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="ddlMarchent" runat="server"
                                    AppendDataBoundItems="True" DataTextField="MarchentName"
                                    DataValueField="MarchentID" DataSourceID="sqlMerchant">
                                    <asp:ListItem Value="" Text="Select Merchant"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlMarchent" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                                <asp:SqlDataSource ID="sqlMerchant" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                    SelectCommand="SELECT [MarchentID], [MarchentName] FROM [Checkout_Marchent] order by MarchentName"></asp:SqlDataSource>
                            </InsertItemTemplate>
                            <ItemStyle Font-Bold="true" Font-Size="Large" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Payment Type" SortExpression="MarchentName">
                            <ItemTemplate>
                                <%# Eval("MarchentName")%>
                            </ItemTemplate>
                            <%-- <EditItemTemplate>
                                <asp:TextBox ID="txtMerchantName" runat="server" Text='<%# Bind("MarchentName") %>' MaxLength="255" Width="700px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMName" runat="server"
                                    ControlToValidate="txtMerchantName" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:DropDownList ID="dblType" runat="server">
                                    <asp:ListItem Value="" Text="Select"></asp:ListItem>
                                    <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                    <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="dblType" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                            <ItemStyle Font-Bold="true" />
                            <HeaderStyle Wrap="false" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Min Amount" SortExpression="Contact">
                            <ItemTemplate>
                                <%# Eval("Contact").ToString().Replace("\n","<br>") %>
                            </ItemTemplate>
                            <%--  <EditItemTemplate>
                                <asp:TextBox ID="txtMinAmount" runat="server" Text='<%# Bind("Contact") %>'  TextMode="Number"></asp:TextBox>

                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMinAmount" runat="server" Text="1" TextMode="Number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtMinAmount" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Max Amount" SortExpression="Contact">
                            <ItemTemplate>
                                <%# Eval("Contact").ToString().Replace("\n","<br>") %>
                            </ItemTemplate>
                            <%-- <EditItemTemplate>
                                <asp:TextBox ID="txtMaxAmount" runat="server" Text='<%# Bind("Contact") %>'  TextMode="Number"></asp:TextBox>

                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMaxAmount" runat="server" Text="9999999" TextMode="Number"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtMaxAmount" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Fixed Service Charge" SortExpression="Contact">
                            <ItemTemplate>
                                <%# Eval("Contact").ToString().Replace("\n","<br>") %>
                            </ItemTemplate>
                            <%-- <EditItemTemplate>
                                <asp:TextBox ID="txtServiceCharge" runat="server" Text='<%# Bind("Contact") %>'  TextMode="Number"></asp:TextBox>

                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtServiceCharge" runat="server" Text='<%# Bind("FixedServiceCharge") %>' TextMode="Number"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Service Charge(%)" SortExpression="Contact">
                            <ItemTemplate>
                                <%# Eval("Contact").ToString().Replace("\n","<br>") %>
                            </ItemTemplate>
                            <%-- <EditItemTemplate>
                                <asp:TextBox ID="txtChargePercent" runat="server" Text='<%# Bind("Contact") %>'  TextMode="Number"></asp:TextBox>

                            </EditItemTemplate>--%>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtChargePercent" runat="server" Text='<%# Bind("ServiceChargePercentage") %>' TextMode="Number"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>



                        <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit" />
                                <asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                    Text="New" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="Button1"></asp:ConfirmButtonExtender>
                                <asp:LinkButton ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:Button ID="cmdInsert" runat="server" CausesValidation="True" CommandName="Insert"
                                    Text="Insert" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                    Enabled="True" TargetControlID="cmdInsert"></asp:ConfirmButtonExtender>
                                <asp:LinkButton ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </InsertItemTemplate>
                            <ControlStyle Width="80px" />
                        </asp:TemplateField>

                    </Fields>
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <AlternatingRowStyle BackColor="White" />
                </asp:DetailsView>
                <asp:SqlDataSource ID="SqlItemsInsert" runat="server"
                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    InsertCommand="s_Checkout_Merchant_ServiceCharge"
                    InsertCommandType="StoredProcedure" OnInserted="SqlItemsInsert_Inserted"
                    OnUpdated="SqlItemsInsert_Updated"
                    SelectCommand="SELECT *  FROM Checkout_Merchant_ServiceCharge WHERE ID=@ID"
                    UpdateCommand="s_MerchantInfo_Add_Edit"
                    UpdateCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GdvItemList" Name="ID"
                            PropertyName="SelectedValue" />
                    </SelectParameters>
                    <InsertParameters>
                        <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                        <asp:ControlParameter Name="MarchentID" ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$ddlMarchent" Type="String" DefaultValue="Test" PropertyName="SelectedValue" />
                        <asp:ControlParameter ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$dblType" Name="PaymentType" DefaultValue="MB" PropertyName="SelectedValue"
                            Type="String" />

                        <asp:ControlParameter ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$txtMinAmount" Type="Decimal" Name="MinAmount" />
                        <asp:ControlParameter ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$txtMaxAmount" Type="Decimal" Name="MaxAmount" />

                        <asp:Parameter Name="FixedServiceCharge" Type="Decimal" />

                        <asp:Parameter Name="ServiceChargePercentage" Type="Decimal" />




                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </InsertParameters>

                    <%--  <UpdateParameters>
                          <asp:Parameter Name="AddEdit" Type="String" DefaultValue="EDIT" />
                        <asp:Parameter Name="MarchentID" Type="String" />
                        <asp:Parameter Name="MarchentName" Type="String" />
                        <asp:Parameter Name="MarchentCompanyURL" Type="String" />
                        <asp:Parameter Name="MarchentLogoURL" Type="String" />

                          <asp:Parameter Name="Contact" Type="String" />
                          <asp:Parameter Name="Active" Type="Boolean" />
                          <asp:Parameter Name="PaymentGetUrl" Type="String" />

                        <asp:Parameter Name="AllowReceiptPrint" Type="Boolean" />
                         <asp:Parameter Name="AllowEmailReceipt" Type="Boolean" />
                         <asp:Parameter Name="AllowReceiptLink" Type="Boolean" />
                         <asp:Parameter Name="AllowEMI" Type="Boolean" />
                         <asp:Parameter Name="AllowXmlResponce" Type="Boolean" />

                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </UpdateParameters>--%>
                </asp:SqlDataSource>
            </div>


            <div style="padding-top:10px;">
                <asp:TextBox ID="txtFilter" ToolTip="type search info" PostBack="true" 
                     OnTextChanged="txtFilter_TextChanged"  runat="server" Width="200px"></asp:TextBox>
            </div>
            <div class="content-start">
                <asp:GridView ID="GdvItemList" runat="server" CssClass="Grid"
                    AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ID" DataSourceID="SqlIMerchantChargeList" ForeColor="Black"
                    GridLines="Vertical" AllowPaging="True" PageSize="15" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom"
                    OnSelectedIndexChanging="GdvItemList_SelectedIndexChanging">
                    <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" PageButtonCount="30" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                    <Columns>

                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton runat="server" ID="lnkEdit" CommandName="Select">
                                  <img src="Images/edit-label.png" />
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>



                        <asp:TemplateField HeaderText="Marchent Name" SortExpression="MarchentName">
                            <ItemTemplate>
                                <div style="font-size: medium; font-weight: bold">

                                    <%# Eval("MerchantID") %>
                                </div>
                                <div>
                                    <%# Eval("MarchentName") %>
                                </div>

                            </ItemTemplate>
                        </asp:TemplateField>


                        <%-- <asp:TemplateField HeaderText="Active" SortExpression="Active">
                            <ItemTemplate>
                                <%# Eval("Active").ToString() == "True" ? "<img src='Images/Tick.png' title='Verified' width='32' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>--%>



                        <asp:BoundField DataField="PaymentType" HeaderText="Payment Type" SortExpression="PaymentType" />
                        <asp:BoundField DataField="MinAmount" HeaderText="Min Amount" SortExpression="MinAmount" />
                        <asp:BoundField DataField="MaxAmount" HeaderText="Max Amount" SortExpression="MaxAmount" />
                        <asp:BoundField DataField="FixedServiceCharge" HeaderText="Fixed Service Charge" SortExpression="FixedServiceCharge" />
                        <asp:BoundField DataField="ServiceChargePercentage" HeaderText="Service Charge(%)" SortExpression="ServiceChargePercentage" />


                        <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                                <br />
                                <span title='<%# Eval("InsertDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%></span>
                            </ItemTemplate>
                            <ItemStyle Font-Size="X-Small" ForeColor="Gray" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Modify" SortExpression="UpdateBy">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP2" runat="server" Username='<%# Eval("UpdateBy") %>' />
                                <br />
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
                <asp:SqlDataSource ID="SqlIMerchantChargeList" runat="server"
                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Checkout_MerchantCharge_List" SelectCommandType="StoredProcedure"
                    OnSelected="SqlMerchantListGrid_Selected" ProviderName="<%$ ConnectionStrings:PaymentsDBConnectionString.ProviderName %>">
                      <SelectParameters>
                        <asp:ControlParameter ControlID="txtFilter" Name="FilterID"
                           type="String" DefaultValue="*" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <br />
                <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
                <br />

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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
