<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="WestZoneReconcilation.aspx.cs" Inherits="WestZoneReconcilation" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Reconcile summary & Confirmation"></asp:Label>
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
                                <td>Payment Date: </td>
                                <td>
                                    <asp:TextBox ID="txtPayDate" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                             CssClass="Date"></asp:TextBox>
                                </td>
                                <td>OTC: </td>
                                 <td>
                                     <asp:DropDownList ID="ddlOtc" AppendDataBoundItems="true" runat="server">
                                           <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                          <%--  <asp:ListItem Value="0" Text="No"></asp:ListItem>
                                            <asp:ListItem Value="2" Text="Mobile Banking Apps"></asp:ListItem>--%>
                                     </asp:DropDownList>
                                   
                                </td>
                                <td>
                                    <asp:Button ID="cmdOK" runat="server" OnClick="cmdOK_Click" Text="Reconcile Summary" />
                                     <asp:ConfirmButtonExtender ID="cmdOK_ConfirmButtonExtender" runat="server"
                                    ConfirmText="Do you want to Show the Reconcilation Summary?" Enabled="True"
                                    TargetControlID="cmdOK"></asp:ConfirmButtonExtender>
                                </td>
                                <td>
                                    <asp:Button ID="btnDetails" runat="server" OnClick="btnDetails_Click" Text="Reconcile Details" />
                                      <asp:ConfirmButtonExtender ID="btnDetails_ConfirmButtonExtender" runat="server"
                                    ConfirmText="Do you want to Show the Reconcilation Details?" Enabled="True"
                                    TargetControlID="btnDetails"></asp:ConfirmButtonExtender>
                                </td>
                            </tr>
                        </table>
                    </td>
                   

                </tr>
            </table>
            <asp:Panel ID="PanelReconcileSummary" runat="server" Visible="true">
             <div>
                <b>Reconcile Summary</b>
            </div>

            <div>
                <asp:GridView ID="GridViewReconcileSummary" runat="server" AutoGenerateColumns="False"  BackColor="White"  BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" CssClass="Grid" DataKeyNames="ID" DataSourceID="SqlDataSourceReconcileSummary"  OnDataBound="GridViewReconcileSummary_DataBound">
                    <Columns>
                        <asp:BoundField DataField="Org_Code" HeaderText="Org Code"  SortExpression="Org_Code" />
                        <asp:BoundField DataField="Pay_Date" HeaderText="Pay_Date" SortExpression="Pay_Date" />
                        <asp:BoundField DataField="Otc" HeaderText="Otc" SortExpression="Otc" />
                        <asp:BoundField DataField="Bank_Name" HeaderText="Bank Name" SortExpression="Bank_Name" />
                        <asp:BoundField DataField="Branch_Name" HeaderText="Branch Name" SortExpression="Branch_Name" />
                        <asp:BoundField DataField="Org_Principal_Amount" HeaderText="Org Principal Amount" SortExpression="Org_Principal_Amount" />
                        <asp:BoundField DataField="Vat_Amount" HeaderText="Vat Amount" SortExpression="Vat_Amount" />

                          <asp:BoundField DataField="Org_Total_Amount" HeaderText="Org Total Amount" SortExpression="Org_Total_Amount" />
                          <asp:BoundField DataField="Revenue_Stamp_Amount" HeaderText="Revenue Stamp Amountt" SortExpression="Revenue_Stamp_Amount" />
                          <asp:BoundField DataField="Net_Org_Amount" HeaderText="Net Org Amount" SortExpression="Net_Org_Amount" />
                          <asp:BoundField DataField="Total_Trans" HeaderText="Total Trans" SortExpression="Total_Trans" />
                                                
                    <asp:TemplateField HeaderText="Reconciled By" SortExpression="Insert_By">                        
                        <ItemTemplate>
                            <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("Insert_By") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>       

                    </Columns>
                     <EmptyDataTemplate>
                       Data not found.
                   </EmptyDataTemplate>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceReconcileSummary" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Reconcile_Summary] WHERE ([Page_ID] = @PageID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="PageID" QueryStringField="pageid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
                <div style="padding:10px 0 0 0;">
                    <asp:Button ID="btnReconsConfirm" runat="server" Text="Confirmation" OnClick="btnReconsConfirm_Click" />
                      <asp:ConfirmButtonExtender ID="btnReconsConfirmt_ConfirmButtonExtender" runat="server"
                                    ConfirmText="Do you want to confirm the Reconcilation?" Enabled="True"
                                    TargetControlID="btnReconsConfirm"></asp:ConfirmButtonExtender>
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
