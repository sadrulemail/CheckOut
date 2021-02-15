<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="MerchantPermission" Title="Merchant Permission" CodeFile="MerchantPermission.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Merchant Portal Permission
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
                    <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>
                    <Fields>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False"
                            ReadOnly="True" SortExpression="ID" ShowHeader="false" />
                        <asp:TemplateField HeaderText="Email" SortExpression="Email" ShowHeader="false">
                            <ItemTemplate>
                                <div style="font-weight: bold; font-size: X-large"><%# Eval("Email") %></div>
                                <div>Userid: <%# Eval("UserID") %></div>
                                <div class="bold"><%# Eval("FullName") %></div>
                                <div><%# Eval("Mobile") %></div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                Email:<br />
                                <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("Email") %>' MaxLength="255" Width="300px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEmail" runat="server"
                                    ControlToValidate="txtEmail" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                Email:<br />
                                <asp:TextBox ID="txtEmail" runat="server" MaxLength="255" Width="300px" Text='<%# Bind("Email") %>' ></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorEmail1" runat="server"
                                    ControlToValidate="txtEmail" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Merchant" ShowHeader="false">
                            <ItemTemplate>
                                <div style="font-weight: bold; font-size: large"><%# Eval("MarchentName")%></div>
                                <div>ID: <%# Eval("MerchantID")%></div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                Merchant:<br />
                                <asp:DropDownList ID="cmbMerchant" runat="server" SelectedValue='<%# Bind("MerchantID") %>'
                                    DataSourceID="SqlMerchantList" AppendDataBoundItems="true" DataTextField="MarchentName"
                                    DataValueField="MarchentID">

                                    <asp:ListItem Text="All" Value="*"></asp:ListItem>
                                </asp:DropDownList>

                                <asp:SqlDataSource ID="SqlMerchantList" runat="server"
                                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                    SelectCommand="SELECT [MarchentName], [MarchentID] FROM Checkout_Marchent with (nolock) WHERE ([Active] = 1)"></asp:SqlDataSource>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                Merchant:<br />
                                <asp:DropDownList ID="cmbMerchant" runat="server" SelectedValue='<%# Bind("MerchantID") %>'
                                    DataSourceID="SqlMerchantList" AppendDataBoundItems="true" DataTextField="MarchentName"
                                    DataValueField="MarchentID">
                                    <asp:ListItem Text="All" Value="*"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:SqlDataSource ID="SqlMerchantList" runat="server" 
                                    ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                    SelectCommand="SELECT [MarchentName], [MarchentID] FROM Checkout_Marchent WHERE ([Active] = 1)"></asp:SqlDataSource>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Active" SortExpression="IsActive" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("IsActive") %>'
                                    Enabled="false" Text="Active" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Text="Active" Checked='<%# Bind("IsActive") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("IsActive") %>'
                                    Text="Active" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                            <asp:TemplateField HeaderText="Amount Visible" SortExpression="TotalAmountVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsTotalAmountVisible" runat="server" Checked='<%# Bind("TotalAmountVisible") %>'
                                    Enabled="false" Text="Amount Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsTotalAmountVisible" runat="server" Text="Amount Visible" Checked='<%# Bind("TotalAmountVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsTotalAmountVisible" runat="server" Checked='<%# Bind("TotalAmountVisible") %>'
                                    Text="Amount Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                               <asp:TemplateField HeaderText="Service Charge Visible" SortExpression="ServiceChargeVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsServiceChargeVisible" runat="server" Checked='<%# Bind("ServiceChargeVisible") %>'
                                    Enabled="false" Text="Service Charge Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsServiceChargeVisible" runat="server" Text="Service Charge Visible" Checked='<%# Bind("ServiceChargeVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsServiceChargeVisible" runat="server" Checked='<%# Bind("ServiceChargeVisible") %>'
                                    Text="Service Charge Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                               <asp:TemplateField HeaderText="VAT Visible" SortExpression="VatVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsVatVisible" runat="server" Checked='<%# Bind("VatVisible") %>'
                                    Enabled="false" Text="VAT Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsVatVisible" runat="server" Text="VAT Visible" Checked='<%# Bind("VatVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsVatVisible" runat="server" Checked='<%# Bind("VatVisible") %>'
                                    Text="VAT Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                              <asp:TemplateField HeaderText="Summary Report Visible" SortExpression="SummaryReportVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsSummaryVisible" runat="server" Checked='<%# Bind("SummaryReportVisible") %>'
                                    Enabled="false" Text="Summary Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsSummaryVisible" runat="server" Text="Summary Visible" Checked='<%# Bind("SummaryReportVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsSummaryVisible" runat="server" Checked='<%# Bind("SummaryReportVisible") %>'
                                    Text="Summary Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                           <asp:TemplateField HeaderText="Used Visible" SortExpression="UsedVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsUsedVisible" runat="server" Checked='<%# Bind("UsedVisible") %>'
                                    Enabled="false" Text="Used Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsUsedVisible" runat="server" Text="Used Visible" Checked='<%# Bind("UsedVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsUsedVisible" runat="server" Checked='<%# Bind("UsedVisible") %>'
                                    Text="Used Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                            <asp:TemplateField HeaderText="Verified Visible" SortExpression="VerifiedVisible" ShowHeader="false">
                            <ItemTemplate>
                                <asp:CheckBox ID="IsVerifiedVisible" runat="server" Checked='<%# Bind("VerifiedVisible") %>'
                                    Enabled="false" Text="Verified Visible" />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsVerifiedVisible" runat="server" Text="Verified Visible" Checked='<%# Bind("VerifiedVisible") %>' />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsVerifiedVisible" runat="server" Checked='<%# Bind("VerifiedVisible") %>'
                                    Text="Verified Visible" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                            <ItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="False" CommandName="Edit"
                                    Text="Edit" />
                                &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                    Text="New" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:Button ID="Button1" runat="server" CausesValidation="True" CommandName="Update"
                                    Text="Update" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="Button1">
                                </asp:ConfirmButtonExtender>
                                <asp:LinkButton ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                    Text="Cancel" />
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:Button ID="cmdInsert" runat="server" CausesValidation="True" CommandName="Insert"
                                    Text="Insert" />
                                <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                    Enabled="True" TargetControlID="cmdInsert">
                                </asp:ConfirmButtonExtender>
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
                    InsertCommand="s_Checkout_Merchant_Permission_Insert_Update"
                    InsertCommandType="StoredProcedure" OnInserted="SqlItemsInsert_Inserted"
                    OnUpdated="SqlItemsInsert_Updated"
                    SelectCommand="SELECT * FROM v_Checkout_MerchantPortalPermission with (nolock) WHERE ID=@ID"
                    UpdateCommand="s_Checkout_Merchant_Permission_Insert_Update"
                    UpdateCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GdvItemList" Name="ID"
                            PropertyName="SelectedValue" />
                    </SelectParameters>
                    <InsertParameters>
                        <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                        <asp:Parameter Name="Email" Type="String" />
                        <asp:Parameter Name="MerchantID" Type="String" />
                        <asp:Parameter Name="IsActive" Type="Boolean" />
                        <asp:Parameter Name="SummaryReportVisible" Type="Boolean" />
                        <asp:Parameter Name="UsedVisible" Type="Boolean" />
                        <asp:Parameter Name="VerifiedVisible" Type="Boolean" />
                        <asp:Parameter Name="VatVisible" Type="Boolean" />
                        <asp:Parameter Name="ServiceChargeVisible" Type="Boolean" />
                          <asp:Parameter Name="TotalAmountVisible" Type="Boolean" />
                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </InsertParameters>

                    <UpdateParameters>
                        <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                        <asp:Parameter Name="Email" Type="String" />
                        <asp:Parameter Name="MerchantID" Type="String" />
                        <asp:Parameter Name="IsActive" Type="Boolean" />
                           <asp:Parameter Name="SummaryReportVisible" Type="Boolean" />
                        <asp:Parameter Name="UsedVisible" Type="Boolean" />
                        <asp:Parameter Name="VerifiedVisible" Type="Boolean" />
                        <asp:Parameter Name="VatVisible" Type="Boolean" />
                        <asp:Parameter Name="ServiceChargeVisible" Type="Boolean" />
                          <asp:Parameter Name="TotalAmountVisible" Type="Boolean" />
                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </div>

            <div style="padding-top:10px;">
                <asp:TextBox ID="txtFilter" ToolTip="type search info" AutoPostBack="true" Watermark="filter"
                     OnTextChanged="txtFilter_TextChanged"  runat="server" Width="200px"></asp:TextBox>
            </div>
            <div class="content-start">
                <asp:GridView ID="GdvItemList" runat="server" CssClass="Grid"
                    AllowSorting="True" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="ID" DataSourceID="SqlItemListGrid" ForeColor="Black"
                    GridLines="Vertical" AllowPaging="True" PageSize="10" PagerSettings-Mode="NumericFirstLast"
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
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                            SortExpression="ID" ItemStyle-HorizontalAlign="Center">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                        <asp:BoundField DataField="UserID" HeaderText="Userid" SortExpression="UserID" ItemStyle-CssClass="center" />
                        <asp:TemplateField HeaderText="Full Name" SortExpression="FullName">
                            <ItemTemplate>
                                <%# Eval("FullName") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Mobile" SortExpression="Mobile">
                            <ItemTemplate>
                                <%# Eval("Mobile") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                         <asp:TemplateField HeaderText="Merchant" SortExpression="MerchantID">
                            <ItemTemplate>
                                <div style="font-weight:bold"><%# Eval("MerchantID") %></div>
                                <%# Eval("MarchentName") %>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="Active" SortExpression="IsActive">
                            <ItemTemplate>
                                <%# Eval("IsActive").ToString() == "True" ? "<img src='Images/Tick.png' title='Verified' width='24' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>


                        <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                                <br />
                                <span title='<%# Eval("InsertDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%></span>
                            </ItemTemplate>
                            <ItemStyle Font-Size="X-Small" ForeColor="Gray" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Modify" SortExpression="UpdateDT">
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
                <asp:SqlDataSource ID="SqlItemListGrid" runat="server"
                    ConnectionString="<%$ ConnectionStrings:WebDBConnectionString %>"
                    SelectCommand="SELECT * from v_Checkout_MerchantPortalPermission with (nolock) WHERE (@FilterID='*' OR MerchantID +','+MarchentName +','+Email +','+FullName  LIKE '%'+@FilterID+'%') order by ID desc;"
                    OnSelected="SqlItemListGrid_Selected" ProviderName="<%$ ConnectionStrings:PaymentsDBConnectionString.ProviderName %>">
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
