<%@ Page Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" Inherits="MerchantInf" Title="Merchant" CodeFile="MerchantInf.aspx.cs" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="CSS/StyleSheet.css" rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    Merchant Setup
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="Panel1" style="padding: 7px;display:inline-block">
                <asp:DetailsView ID="ItemsDetailsView" runat="server" AutoGenerateRows="False" CssClass="Grid"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    CellPadding="4" DataKeyNames="MarchentID" DataSourceID="SqlItemsInsert" ForeColor="Black"
                    GridLines="Vertical">

                    <FooterStyle BackColor="#CCCC99" />
                    <RowStyle BackColor="#F7F7DE" VerticalAlign="Middle" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <EmptyDataTemplate>
                        <asp:Button ID="Button3" runat="server" Text="Add New" CommandName="New" Width="100px" />
                    </EmptyDataTemplate>
                    <Fields>
                        <asp:TemplateField HeaderText="Marchent ID" SortExpression="MarchentID">
                             <ItemTemplate>
                                <%# Eval("MarchentID")%>
                            </ItemTemplate>
                           <EditItemTemplate>
                                <asp:Label ID="txtMerchantID" runat="server" Text='<%# Bind("MarchentID") %>' MaxLength="255"></asp:Label>
                              
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMerchantID" runat="server" Text='<%# Bind("MarchentID") %>' MaxLength="255"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMID1" runat="server"
                                    ControlToValidate="txtMerchantID" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                            <ItemStyle Font-Bold="true" Font-Size="Large" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Marchent Name" SortExpression="MarchentName">
                              <ItemTemplate>
                                <%# Eval("MarchentName")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtMerchantName" runat="server" Text='<%# Bind("MarchentName") %>' MaxLength="255" Width="700px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMName" runat="server"
                                    ControlToValidate="txtMerchantName" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMerchantName" runat="server" Text='<%# Bind("MarchentName") %>' MaxLength="255" Width="700px"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorMName1" runat="server"
                                    ControlToValidate="txtMerchantName" Display="Dynamic"
                                    ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                            </InsertItemTemplate>
                            <ItemStyle Font-Bold="true"  />
                            <HeaderStyle Wrap="false" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Marchent URL" SortExpression="MarchentCompanyURL">
                               <ItemTemplate>
                                <%# Eval("MarchentCompanyURL")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtMerchantUrl" runat="server" Text='<%# Bind("MarchentCompanyURL") %>' MaxLength="255" Width="700px"></asp:TextBox>

                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMerchantUrl" runat="server" Text='<%# Bind("MarchentCompanyURL") %>' MaxLength="255" Width="700px"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Logo URL" SortExpression="MarchentLogoURL">
                              <ItemTemplate>
                                <img src='<%# ConfigurationManager.AppSettings["LogoPrefix"] %><%# Eval("MarchentLogoURL","{0}")%>' style="max-height:100px" />
                            </ItemTemplate>
                            <EditItemTemplate>
                                <%# ConfigurationManager.AppSettings["LogoPrefix"] %><asp:TextBox ID="txtMerchantLogoUrl" runat="server" Text='<%# Bind("MarchentLogoURL") %>' MaxLength="255" Width="300px"></asp:TextBox>

                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <%# ConfigurationManager.AppSettings["LogoPrefix"] %><asp:TextBox ID="txtMerchantLogoUrl" runat="server" Text='<%# Bind("MarchentLogoURL") %>' MaxLength="255" Width="300px"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Contact" SortExpression="Contact">
                            <ItemTemplate>
                                <%# Eval("Contact").ToString().Replace("\n","<br>") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtMerchantContact" runat="server" Text='<%# Bind("Contact") %>' MaxLength="255" Width="400px" Rows="3" TextMode="MultiLine"></asp:TextBox>

                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMerchantContact" runat="server" Text='<%# Bind("Contact") %>' MaxLength="255" Width="400px" Rows="3" TextMode="MultiLine"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Success URL" SortExpression="PaymentGetUrl">
                              <ItemTemplate>
                                <%# Eval("PaymentGetUrl")%>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtSuccessUrl" runat="server" Text='<%# Bind("PaymentGetUrl") %>' MaxLength="255" Width="800px"></asp:TextBox>

                            </EditItemTemplate>
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtSuccessUrl" runat="server" Text='<%# Bind("PaymentGetUrl") %>' MaxLength="255" Width="800px"></asp:TextBox>
                            </InsertItemTemplate>
                        </asp:TemplateField>
                   
                     
                           <asp:TemplateField HeaderText="Active" SortExpression="IsActive">
                                 <ItemTemplate>
                               <%-- <%# Eval("Active")%>--%>
                                       <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("Active") %>'
                                           Enabled="false"
                                     />
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Checked="true" />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="IsActive" runat="server" Checked='<%# Bind("Active") %>'
                                     />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:CheckBoxField DataField="AllowReceiptPrint" HeaderText="Receipt Print"
                            SortExpression="AllowReceiptPrint" />
                        <asp:CheckBoxField DataField="AllowEmailReceipt" HeaderText="Email Receipt"
                            SortExpression="AllowEmailReceipt" />
                        <asp:CheckBoxField DataField="AllowReceiptLink" HeaderText="Receipt Link"
                            SortExpression="AllowReceiptLink" />
                        <asp:CheckBoxField DataField="AllowEMI" HeaderText="Allow EMI"
                            SortExpression="AllowEMI" />
                        
                        <asp:TemplateField HeaderText="Xml Responce" SortExpression="AllowXmlResponce">
                             <ItemTemplate>
                               <%-- <%# Eval("AllowXmlResponce")%>--%>
                                   <asp:CheckBox ID="viewCheckBox" runat="server" Checked='<%# Bind("AllowXmlResponce") %>' Enabled="false"/>
                            </ItemTemplate>
                            <InsertItemTemplate>
                                <asp:CheckBox ID="viewCheckBox" runat="server" Checked="true" />
                            </InsertItemTemplate>
                            <EditItemTemplate>
                                <asp:CheckBox ID="viewCheckBox" runat="server" Checked='<%# Bind("AllowXmlResponce") %>'  
                                   />
                            </EditItemTemplate>
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
                    InsertCommand="s_MerchantInfo_Add_Edit"
                    InsertCommandType="StoredProcedure" OnInserted="SqlItemsInsert_Inserted"
                    OnUpdated="SqlItemsInsert_Updated"
                    SelectCommand="SELECT * FROM Checkout_Marchent WHERE MarchentID=@MarchentID"
                    UpdateCommand="s_MerchantInfo_Add_Edit"
                    UpdateCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:ControlParameter ControlID="GdvItemList" Name="MarchentID"
                            PropertyName="SelectedValue" />
                    </SelectParameters>
                    <InsertParameters>
                        <asp:Parameter Name="AddEdit"  Direction="InputOutput" Type="String" DefaultValue="ADD" />
                        <asp:Parameter Name="MarchentID" Type="String" />
                        <asp:Parameter Name="MarchentName" Type="String" />
                        <asp:Parameter Name="MarchentCompanyURL" Type="String" />
                        <asp:Parameter Name="MarchentLogoURL" Type="String" />

                          <asp:Parameter Name="Contact" Type="String" />

                        <%--  <asp:Parameter Name="Active" Type="Boolean" />--%>
                        <asp:ControlParameter Name="Active" ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$IsActive" Type="Boolean"/>
                          <asp:Parameter Name="PaymentGetUrl" Type="String" />

                        <asp:Parameter Name="AllowReceiptPrint" Type="Boolean" />
                         <asp:Parameter Name="AllowEmailReceipt" Type="Boolean" />
                         <asp:Parameter Name="AllowReceiptLink" Type="Boolean" />
                         <asp:Parameter Name="AllowEMI" Type="Boolean" />
            <%--    <asp:Parameter Name="AllowXmlResponce" Type="Boolean" />--%>
                        <asp:ControlParameter ControlID="ctl00$ContentPlaceHolder2$ItemsDetailsView$viewCheckBox" Name="AllowXmlResponce" Type="Boolean" />

                        <asp:SessionParameter Name="ModifiedBy" SessionField="EMPID" Type="String" />
                        <asp:Parameter DefaultValue="" Direction="InputOutput" Name="Msg" Size="255"
                            Type="String" />
                        <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done"
                            Type="Boolean" />
                    </InsertParameters>

                    <UpdateParameters>
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
                    CellPadding="4" DataKeyNames="MarchentID" DataSourceID="SqlIMerchantListGrid" ForeColor="Black"
                    GridLines="Vertical" AllowPaging="True" PageSize="10" PagerSettings-Mode="NumericFirstLast"
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

                        <asp:TemplateField HeaderText="Logo" >
                            <ItemTemplate>
                               <a href='<%# Eval("MarchentCompanyURL") %>' target="_blank" title="Goto Website">
                                   <img src='<%# ConfigurationManager.AppSettings["LogoPrefix"] %><%# Eval("MarchentLogoURL") %>' style="max-height:50px;max-width:150px" />
                               </a>
                            </ItemTemplate>  
                            <ItemStyle BackColor="White" HorizontalAlign="Center" />                          
                        </asp:TemplateField>                                        
                     
                        <asp:TemplateField HeaderText="Marchent Name" SortExpression="MarchentName">
                            <ItemTemplate>
                                <div style="font-size:medium;font-weight:bold">
                                    <a target="_blank" href='MerchantDetailInf.aspx?merchantid=<%# Eval("MarchentID") %>' style="color:green" title="Details">
                                          <%# Eval("MarchentID") %>                     
                                </a></div>
                              <%# Eval("MarchentName") %>                               
                            </ItemTemplate>                            
                        </asp:TemplateField>
          

                        <asp:TemplateField HeaderText="Active" SortExpression="Active">
                            <ItemTemplate>
                                <%# Eval("Active").ToString() == "True" ? "<img src='Images/Tick.png' title='Verified' width='32' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Xml Responce" SortExpression="AllowXmlResponce">
                            <ItemTemplate>
                                <%# Eval("AllowXmlResponce").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Allow EMI" SortExpression="AllowEMI">
                            <ItemTemplate>
                                <%# Eval("AllowEMI").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Receipt Print" SortExpression="AllowReceiptPrint">
                            <ItemTemplate>
                                <%# Eval("AllowReceiptPrint").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Email Receipt" SortExpression="AllowEmailReceipt">
                            <ItemTemplate>
                                <%# Eval("AllowEmailReceipt").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                          <asp:TemplateField HeaderText="Receipt Link" SortExpression="AllowReceiptLink">
                            <ItemTemplate>
                                <%# Eval("AllowReceiptLink").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField> 
                       
                        <asp:BoundField DataField="PaymentGetUrl" HeaderText="Payment Get Url" SortExpression="PaymentGetUrl" Visible="false" />
                        <asp:BoundField DataField="Contact" HeaderText="Contact" SortExpression="Contact" Visible="false" />

                        
                        <asp:TemplateField HeaderText="Insert" SortExpression="InsertDT">
                            <ItemTemplate>
                                <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' /><br />
                                <span title='<%# Eval("InsertDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                    <%# TrustControl1.ToRecentDateTime(Eval("InsertDT"))%></span>
                            </ItemTemplate>
                            <ItemStyle Font-Size="X-Small" ForeColor="Gray" />
                        </asp:TemplateField>
                       
                        <asp:TemplateField HeaderText="Modify" SortExpression="UpdateBy">
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
                    SelectCommand="SELECT * from Checkout_Marchent WHERE (@FilterID='*' OR MarchentID +','+MarchentName LIKE '%'+@FilterID+'%')"
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
