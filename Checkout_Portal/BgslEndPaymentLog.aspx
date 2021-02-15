<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="BgslEndPaymentLog.aspx.cs" Inherits="BgslEndPaymentLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>

<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
   BGSL End Payment status Log
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
   

   <%-- <asp:UpdatePanel ID="UpdatePanel1" runat="server">--%>
    <%--    <ContentTemplate>--%>
        
            <div>

                <asp:GridView ID="GridView1" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_Payment_Checkout" 
                    CellPadding="4"  ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30"   OnRowDataBound="GridView1_RowDataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                   
                        <asp:BoundField DataField="serial_no" HeaderText="Serial no" SortExpression="serial_no" />
                        <asp:BoundField DataField="customer_code_old" HeaderText="Customer code old" SortExpression="customer_code_old" />

                        <asp:BoundField DataField="customer_code" HeaderText="Customer code" SortExpression="customer_code" />
                        <asp:BoundField DataField="customer_name" HeaderText="Customer name" SortExpression="customer_name" />
                        <asp:BoundField DataField="from_bill_monthyear1" HeaderText="from bill monthyear1" SortExpression="from_bill_monthyear1" />
                        <asp:BoundField DataField="from_bill_monthyear2" HeaderText="from bill monthyear2" SortExpression="from_bill_monthyear2" />


                        <asp:BoundField DataField="to_bill_monthyear1" HeaderText="to bill monthyear1" SortExpression="to_bill_monthyear1" />
                        <asp:BoundField DataField="to_bill_monthyear2" HeaderText="to bill monthyear2" SortExpression="to_bill_monthyear2"/>
                        <asp:BoundField DataField="bill_paid1" HeaderText="bill paid1" SortExpression="bill_paid1" />
                        <asp:BoundField DataField="bill_paid2" HeaderText="bill paid2" SortExpression="bill_paid2" />
                        <asp:BoundField DataField="surcharge_paid1" HeaderText="surcharge paid1" SortExpression="surcharge_paid1" />
                        <asp:BoundField DataField="surcharge_paid2" HeaderText="surcharge paid2" SortExpression="surcharge_paid2" />
                                             

                        <asp:BoundField DataField="bank_code1" HeaderText="bank code1"  SortExpression="bank_code1" />
                        <asp:BoundField DataField="bank_code2" HeaderText="bank code2" SortExpression="bank_code2" />
                        <asp:BoundField DataField="operator_id1" HeaderText="operator id1" SortExpression="operator_id1" />
                        <asp:BoundField DataField="operator_id2" HeaderText="operator id2" SortExpression="operator_id2" />
                        <asp:BoundField DataField="entry_status" HeaderText="entry_status" SortExpression="entry_status" />
                        <asp:BoundField DataField="payment_date1" HeaderText="payment date1" SortExpression="payment_date1" />
                        <asp:BoundField DataField="payment_date2" HeaderText="payment date2" SortExpression="payment_date2" />

                        <asp:BoundField DataField="scroll_no" HeaderText="scroll_no" SortExpression="scroll_no" />
                        <asp:BoundField DataField="g_id" HeaderText="Ref ID" SortExpression="g_id" />

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


                <asp:SqlDataSource ID="SqlDataSource_Payment_Checkout" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_BgslEnd_PayBill" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Payment_Checkout_Selected">

                    <SelectParameters>
                     
                        <asp:QueryStringParameter QueryStringField="refid" Name="RefID" Type="String" DefaultValue=""/>
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="padding-top: 10px">
                <div>
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </div>
              
            </div>
     <%--   </ContentTemplate>
      
    </asp:UpdatePanel>--%>
   <%-- <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
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
    </asp:AlwaysVisibleControlExtender>--%>
</asp:Content>
