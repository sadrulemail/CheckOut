<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Payment.aspx.cs"
    MasterPageFile="~/MasterBootstrap.master" Inherits="Checkout_Payment" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="head" runat="server" ID="content1">
    <title>Trust Bank Checkout</title>        
    <script type="text/javascript">
        function preventBack() { window.history.forward(); }
        setTimeout("preventBack()", 0);
        window.onunload = function () { null };
    </script>
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="content2">
    Trust Bank Checkout
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder2" runat="server" ID="content3">
    <asp:ScriptManager runat="server" ID="ToolkitScriptManager1" 
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ScriptManager>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <%--  <div class="row text-center text-warning bold" style="min-height: 200px">
                <asp:Label ID="llbStatus" runat="server" Text=""></asp:Label>
            </div>--%>
            <%--  <asp:Panel ID="pnlAuthoMer" runat="server" Visible="false">
            <asp:Label ID="lblAuthoMer" runat="server" Text="Merchant is not authorized for using this Checkout."></asp:Label>
            </asp:Panel>
            --%>
            <%--  <asp:Panel ID="pnlMerchant" runat="server">--%>
            <asp:HiddenField ID="hidFullName" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidEmail" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidOrderID" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidAmount" runat="server" Value="0" EnableViewState="true" />
            <asp:HiddenField ID="hidMerchantID" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidPaymentSuccessUrl" runat="server" Value="" EnableViewState="true" />
             <asp:HiddenField ID="hidRefID" runat="server" Value="" EnableViewState="true" />
            <div class="row">
                <div class="col-sm-2 text-center">
                    <asp:HyperLink ID="lblImage" runat="server" Target="_blank" ToolTip="Visit Merchant Site"></asp:HyperLink>
                    <br />
                    <asp:HyperLink ID="lblMarchentName1" Target="_blank" runat="server" Text="Label"
                        Style="font-weight: bold; color: Black; font-size: 85%" ToolTip="Visit Marchent Site"></asp:HyperLink>
                </div>
                <hr class="visible-xs" />
                <div class="col-sm-8 ">
                    <div>
                        <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>
                          <asp:Label ID="lblBody" runat="server" Text="Welcome to Trust Bank Checkout. To pay please click on your desired payment method."></asp:Label>
                     
                    </div>
                     <asp:Panel runat="server" ID="PanelSuccess">
                    <div class="panel panel-success" style="margin-top: 20px">
                        <div class="panel-heading hidden-xs">
                            Select Payment Method
                        </div>
                        <asp:Panel ID="PanelMB" runat="server">

                            <div class="row" style="margin-top: 10px;">
                                <div class="col-sm-6 col-md-5 col-md-offset-1">
                                    <table class="table table-condensed">
                                        <thead>
                                            <tr>
                                                <th colspan="2" class="text-center bold">
                                                    <asp:LinkButton ID="lnkTbmm" runat="server" ForeColor="Green" Font-Size="110%" CommandArgument="MB"
                                                        OnCommand="lnk_Command">
                                                    Trust Bank Mobile Money
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender ID="ConfirmButtonExtenderTbmm" runat="server" TargetControlID="lnkTbmm"
                                                        ConfirmText="Do you want to pay using Trust Bank Mobile Money?">
                                                    </asp:ConfirmButtonExtender>
                                                </th>
                                            </tr>
                                        </thead>
                                        <tr>
                                            <td>Fees:
                                            </td>
                                            <td class="text-right">
                                                <asp:Label ID="lblTBMM_PaymentAmount" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Charge + Vat:
                                            </td>
                                            <td class="text-right">
                                                <asp:Label ID="lblTBMM_Charge" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bold">Total Cost:
                                            </td>
                                            <td class="text-right bold">
                                                <asp:Label ID="lblTBMM_Total" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-sm-6 col-md-5 text-center">
                                    <asp:LinkButton runat="server" ID="lnkMobile" CommandArgument="MB" OnCommand="lnk_Command">
                                        <div class="bigbutton" title="Click to Pay">
                                            <img src="Images/t-cash.png" width="200" height="70" border="0" alt="" />
                                            
                                        </div>
                                        Click to Pay
                                    </asp:LinkButton>
                                    <asp:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="lnkMobile"
                                        ConfirmText="Do you want to pay using Trust Bank Mobile Money?">
                                    </asp:ConfirmButtonExtender>
                                </div>
                            </div>
                        </asp:Panel>
                        <hr style="margin: 0" />
                        <asp:Panel ID="PanelItcl" runat="server">
                            <div class="row" style="margin-top: 10px">
                                <div class="col-sm-6 col-md-5 col-md-offset-1">
                                    <table class="table table-condensed">
                                        <thead>
                                            <tr>
                                                <th colspan="2" class="text-center bold">
                                                    <asp:LinkButton ID="lnkVisa" runat="server" ForeColor="Green" Font-Size="110%" CommandArgument="ITCL"
                                                        OnCommand="lnk_Command">
                                                    Debit/Credit Card
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender ID="ConfirmButtonExtender2" runat="server" TargetControlID="lnkVisa"
                                                        ConfirmText="Do you want to pay using Q-Cash Card?">
                                                    </asp:ConfirmButtonExtender>
                                                </th>
                                            </tr>
                                        </thead>
                                        <tr runat="server" id="PanelEMI">
                                            <td>EMI
                                            </td>
                                            <td>
                                                <%--<asp:Panel ID="PanelEMI" runat="server" Visible="true">--%>

                                                <%-- <div class="row">
                                <label class="col-sm-2 control-label">
                                    EMI No</label>
                                <div class="col-sm-5 has-feedback">--%>
                                                <asp:SqlDataSource ID="SqlDataSourceDdlEMI" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                                    SelectCommand="SELECT EmiNo, EmiLabel FROM Checkout_Merchant_EMI WHERE MerchantID=@MerchantID ORDER BY ID">
                                                    <SelectParameters>

                                                        <asp:ControlParameter ControlID="hidMerchantID" PropertyName="Value"
                                                            Name="MerchantID" Type="String" DefaultValue="" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:DropDownList ID="ddlEMI" CssClass="form-control" runat="server"
                                                    AppendDataBoundItems="true" AutoPostBack="true" CausesValidation="false" DataSourceID="SqlDataSourceDdlEMI" OnSelectedIndexChanged="ddlEMI_SelectedIndexChanged"
                                                    DataTextField="EmiLabel" DataValueField="EmiNo">
                                                    <asp:ListItem Text="No EMI" Value="0"></asp:ListItem>
                                                </asp:DropDownList>
                                                <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidatorDropDownListCountry" runat="server"
                                            CssClass="form-control-feedback" ControlToValidate="DropDownListCountry" ErrorMessage="*" style="margin:5px" ForeColor="Red" Font-Size="25px"  Font-Bold="true"
                                            SetFocusOnError="True"></asp:RequiredFieldValidator>--%>
                                                <%--</div>
                            </div>--%>
                                                <%--</asp:Panel>--%>

                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Fees:
                                            </td>
                                            <td class="text-right">
                                                <asp:Label ID="lblVisa_PaymentAmount" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                           
                                                <asp:Literal ID="ltVatCharge"
                                                    Text="Charge + Vat:"
                                                    runat="server" />
                                            </td>
                                            <td class="text-right">
                                                <asp:Label ID="lblVisa_Charge" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                           <tr runat="server" id="PanelEMI_Interest">
                                            <td>
                                           
                                                <asp:Literal ID="ltCommission"
                                                    Text="Commission:"
                                                    runat="server" />
                                            </td>
                                            <td class="text-right">
                                                <asp:Label ID="lblVisa_Emi_Interest" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="bold">Total Cost:
                                            </td>
                                            <td class="text-right bold">
                                                <asp:Label ID="lblVisa_Total" runat="server" Text="0.00"></asp:Label>
                                                Tk
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-sm-6 col-md-5 text-center">
                                    <asp:LinkButton runat="server" ID="lnkItcl" CommandArgument="ITCL" OnCommand="lnk_Command">
                                        <div class="bigbutton" title="Click to Pay">
                                            <img src="Images/card1.png" width="79" height="76" border="0" alt="" />
                                        </div>
                                        Click to Pay
                                    </asp:LinkButton>
                                    <asp:ConfirmButtonExtender ID="conlnkItcl" runat="server" TargetControlID="lnkItcl"
                                        ConfirmText="Do you want to pay using Card?">
                                    </asp:ConfirmButtonExtender>
                                </div>
                            </div>
                        </asp:Panel>
                    </div>
                         </asp:Panel>
                  <%--  <asp:Panel runat="server" ID="PanelError" CssClass="div-error" Visible="false">
                        <asp:Label ID="labelError" runat="server" Text="Error"></asp:Label>
                    </asp:Panel>--%>
                     <asp:Panel ID="PanelError" runat="server" Visible="false">
                    <div class="row">
                        <div class="col-md-2 col-md-offset-2">
                            <img src="Images/sad-icon.png" width="128" height="128" />
                        </div>
                        <div class="col-md-8 text-left" style="margin-bottom:20px">
                            <div style="margin-bottom:20px">
                                <asp:Label ID="lblError" runat="server" Text="" Font-Bold="true" Font-Size="Medium"></asp:Label>
                            </div>
                          <%--  <div class="row">
                                <div class="col-md-3">
                                    <asp:HyperLink ID="lnkErrorGo" CssClass="btn btn-success btn-block" runat="server">Try Again</asp:HyperLink>
                                </div>
                            </div>--%>
                        </div>
                    </div>
                </asp:Panel>
                    <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
                </div>
                <div class="col-sm-2 text-center hidden-xs">
                    <img src="Images/checkout.png" width="100" height="100" border="0" alt="Checkout" />
                </div>
            </div>
            <%--   </asp:Panel>--%>
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
