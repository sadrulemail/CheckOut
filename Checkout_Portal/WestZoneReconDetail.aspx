<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="WestZoneReconDetail.aspx.cs" Inherits="WestZoneReconDetail" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Reconcile Details"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            
            <asp:Panel ID="PanelReconcileSummary" runat="server" Visible="true">
             <div>
                <b>Reconcile Details</b>
            </div>

            <div>
                <asp:GridView ID="GridViewReconcileDetail" runat="server" AutoGenerateColumns="False" BackColor="White"  BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" CssClass="Grid"  DataSourceID="SqlDataSourceReconcileDetail">
                    <Columns>
                        <asp:BoundField DataField="Org_Code" HeaderText="Org Code"  SortExpression="Org_Code" />
                        <asp:BoundField DataField="Pay_Date" HeaderText="Pay_Date" SortExpression="Pay_Date" />
                        <asp:BoundField DataField="Otc" HeaderText="Otc" SortExpression="Otc" />
                        <asp:BoundField DataField="Bank_Name" HeaderText="Bank Name" SortExpression="Bank_Name" />
                        <asp:BoundField DataField="Branch_Name" HeaderText="Branch Name" SortExpression="Branch_Name" />

                          <asp:BoundField DataField="Consumer_No" HeaderText="Consumer No." SortExpression="Consumer_No" />
                        <asp:BoundField DataField="Bill_No" HeaderText="Bill No." SortExpression="Bill_No" />
                        <asp:BoundField DataField="Pay_Bill_Month" HeaderText="Pay Bill Month" SortExpression="Pay_Bill_Month" />
                        <asp:BoundField DataField="Principal_Amount" HeaderText="Principal Amount" SortExpression="Principal_Amount" />
                        <asp:BoundField DataField="Vat_Amount" HeaderText="Vat Amount" SortExpression="Vat_Amount" />

                          <asp:BoundField DataField="Total_Amount" HeaderText="Total Amount" SortExpression="Total_Amount" />
                          <asp:BoundField DataField="Rev_Stamp_Amount" HeaderText="Revenue Stamp Amountt" SortExpression="Rev_Stamp_Amount" />
                          <asp:BoundField DataField="Bank_Trans_Id" HeaderText="Bank Trans Id" SortExpression="Bank_Trans_Id" />
                          <asp:BoundField DataField="Mbp_Trans_Id" HeaderText="Mbp Trans Id" SortExpression="Mbp_Trans_Id" />
                          <asp:BoundField DataField="Insert_By" HeaderText="Reconciled By" SortExpression="Insert_By" />
                  
                        
                    </Columns>
                   <EmptyDataTemplate>
                       Data not found.
                   </EmptyDataTemplate>
                      
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceReconcileDetail" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Reconcile_Details] WHERE ([Page_ID] = @PageID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="PageID" QueryStringField="pageid" Type="String" />
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
