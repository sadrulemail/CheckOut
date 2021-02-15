<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="CheckoutPaymentLogDetails.aspx.cs" Inherits="CheckoutPaymentLog" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Checkout Payment Log Details
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div>
                <b>CheckoutPaymentVerifyLog</b>
            </div>

            <div>
                <asp:GridView ID="GridViewCheckoutVLog" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceCheckoutVLog">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="RefID" HeaderText="RefID" SortExpression="RefID" />
                        <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />
                        <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" />
                        <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                        <asp:BoundField DataField="Verify_Status" HeaderText="Verify_Status" SortExpression="Verify_Status" />
                        <asp:CheckBoxField DataField="isWebserviceCalled" HeaderText="isWebserviceCalled" SortExpression="isWebserviceCalled" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceCheckoutVLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [CheckoutPaymentVerifyLog] WHERE ([RefID] = @RefID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div style="margin-top: 6px;">
                <b>Merchant_Service_Push_Update_Log</b>
            </div>

            <div>
                <asp:GridView ID="GridViewNIDPayCLog" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceNIDConfLog">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="RefID" HeaderText="RefID" SortExpression="RefID" />
                        <asp:BoundField DataField="MerchantID" HeaderText="MerchantID" SortExpression="MerchantID" />
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
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceNIDConfLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Merchant_Service_Push_Update_Log] WHERE ([RefID] = @RefID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>

            <div style="margin-top: 6px;">
                ITCL_Response
            </div>
            <div>
                <asp:GridView ID="GridViewItclResp" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceItclResponse">
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
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceItclResponse" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="s_Itcl_Response_Show" SelectCommandType="StoredProcedure">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="margin-top: 6px;">
                <b>ITCL_GetOrderStatus_Log</b>
            </div>
            <div>
                <asp:GridView ID="GridViewItclOrderStatus" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSourceItclOrderStatus">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="OrderID" HeaderText="OrderID" SortExpression="OrderID" />
                        <asp:BoundField DataField="RefID" HeaderText="RefID" SortExpression="RefID" />
                        <asp:BoundField DataField="UID" HeaderText="UID" SortExpression="UID" />
                        <asp:BoundField DataField="OrderStatus" HeaderText="OrderStatus" SortExpression="OrderStatus" />
                        <asp:BoundField DataField="StatusCode" HeaderText="StatusCode" SortExpression="StatusCode" />
                        <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                        <asp:BoundField DataField="ErrorMsg" HeaderText="ErrorMsg" SortExpression="ErrorMsg" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceItclOrderStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [ITCL_GetOrderStatus_Log] WHERE ([RefID] = @RefID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="margin-top: 6px;">
                TBMM_Response
            </div>
            <div>
                <asp:GridView ID="GridViewTbmmResp" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceTbmmResponce">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="transaction_id" HeaderText="transaction_id" SortExpression="transaction_id" />
                        <asp:BoundField DataField="application_id" HeaderText="application_id" SortExpression="application_id" />
                        <asp:BoundField DataField="BillingCode" HeaderText="BillingCode" SortExpression="BillingCode" />
                        <asp:BoundField DataField="success" HeaderText="success" SortExpression="success" />
                        <asp:BoundField DataField="Status" HeaderText="Status" SortExpression="Status" />
                        <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                    </Columns>
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSourceTbmmResponce" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [TBMM_Response] WHERE ([application_id] = @application_id)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="application_id" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>
            </div>
            <div style="margin-top: 6px;">
                <b>Checkout_TrxConfirm_Log</b>
            </div>
            <div>
                <asp:GridView ID="GridViewTrxLog" runat="server" AutoGenerateColumns="False" DataKeyNames="ID" DataSourceID="SqlDataSourceTrxLog">
                    <Columns>
                        <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True" SortExpression="ID" />
                        <asp:BoundField DataField="RefID" HeaderText="RefID" SortExpression="RefID" />
                        <asp:BoundField DataField="Type" HeaderText="Type" SortExpression="Type" />
                        <asp:BoundField DataField="TrnID" HeaderText="TrnID" SortExpression="TrnID" />
                        <asp:BoundField DataField="DT" HeaderText="DT" SortExpression="DT" />
                        <asp:BoundField DataField="ReturnValue" HeaderText="ReturnValue" SortExpression="ReturnValue" />
                        <asp:BoundField DataField="MobileNo" HeaderText="MobileNo" SortExpression="MobileNo" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource ID="SqlDataSourceTrxLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>" SelectCommand="SELECT * FROM [Checkout_TrxConfirm_Log] WHERE ([RefID] = @RefID)">
                    <SelectParameters>
                        <asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />
                    </SelectParameters>
                </asp:SqlDataSource>

            </div>
        </ContentTemplate>
        <%--  <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
        </Triggers>--%>
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
