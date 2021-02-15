<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Passport_Payment.aspx.cs"
    MasterPageFile="~/MasterBootstrap.master" Inherits="Passport_Payment"  %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="head" runat="server" ID="content1">
    <title>Trust Bank Checkout</title>
    <link rel="shortcut icon" href="favicon.ico" />
    <meta http-equiv="Expires" content="0" />
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta http-equiv="Pragma" content="no-cache" />
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
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" CombineScripts="true"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-2 text-center">
                    <img src="Images/checkout.png" width="100" height="100" border="0" alt="Checkout" />
                </div>
                <div class="col-sm-10 ">
                    <div>
                        Dear
                        <asp:Label ID="lblTitle" runat="server" Text=""></asp:Label>,<br />
                        Welcome to Trust Bank Checkout. Please click on your desired payment method you
                        want to use.
                    </div>
                    <asp:Panel runat="server" ID="PanelEmail" Style="margin-top: 20px" CssClass="form-group">
                        <label class="col-sm-5 control-label">
                            Enter your email address (receipt will be sent):
                        </label>
                        <div class="col-sm-7 has-feedback">
                            <asp:TextBox ID="txtEmail" runat="server" placeholder="valid email address" CssClass="form-control"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server" ForeColor="Red" ID="ReqEmail" ControlToValidate="txtEmail"
                                CssClass="form-control-feedback" ErrorMessage="*" SetFocusOnError="true" required></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator runat="server" ID="RegEmail" ControlToValidate="txtEmail"
                                CssClass="" SetFocusOnError="True" Display="Dynamic" ForeColor="Red" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                ErrorMessage="Please enter correct email address">
                            </asp:RegularExpressionValidator>
                        </div>
                    </asp:Panel>
                    <div class="panel panel-success" style="margin-top: 20px">
                        <div class="panel-heading">
                            Select Payment Method
                        </div>
                        <div class="row" style="margin-top: 10px;">
                            <div class="col-sm-5 col-md-4 col-md-offset-2 col-sm-offset-1">
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
                                        <td>
                                            MRP/V Frees:
                                        </td>
                                        <td class="text-right">
                                            <asp:Label ID="lblTBMM_PaymentAmount" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Charge:
                                        </td>
                                        <td class="text-right">
                                            <asp:Label ID="lblTBMM_Charge" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Total Cost:
                                        </td>
                                        <td class="text-right bold">
                                            <asp:Label ID="lblTBMM_Total" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-sm-5 col-md-4 text-center">
                                <asp:LinkButton runat="server" ID="lnkMobile" CommandArgument="MB" OnCommand="lnk_Command">
                                        <div class="bigbutton">
                                            <img src="Images/tbl-mobile-banking.png" width="200" height="94" border="0" alt="" />
                                        </div>
                                </asp:LinkButton>
                                <asp:ConfirmButtonExtender ID="ConfirmButtonExtender1" runat="server" TargetControlID="lnkMobile"
                                    ConfirmText="Do you want to pay using Trust Bank Mobile Money?">
                                </asp:ConfirmButtonExtender>
                            </div>
                        </div>
                        <hr />
                        <div class="row" style="margin-top: 10px">
                            <div class="col-sm-5 col-md-4 col-md-offset-2 col-sm-offset-1">
                                <table class="table table-condensed">
                                    <thead>
                                        <tr>
                                            <th colspan="2" class="text-center bold">
                                                <asp:LinkButton ID="lnkVisa" runat="server" ForeColor="Green" Font-Size="110%" CommandArgument="ITCL"
                                                    OnCommand="lnk_Command">
                                                    Q-Cash Card
                                                </asp:LinkButton>
                                                <asp:ConfirmButtonExtender ID="ConfirmButtonExtender2" runat="server" TargetControlID="lnkVisa"
                                                    ConfirmText="Do you want to pay using Q-Cash Card?">
                                                </asp:ConfirmButtonExtender>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tr>
                                        <td>
                                            MRP/V Frees:
                                        </td>
                                        <td class="text-right">
                                            <asp:Label ID="lblVisa_PaymentAmount" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Charge:
                                        </td>
                                        <td class="text-right">
                                            <asp:Label ID="lblVisa_Charge" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="bold">
                                            Total Cost:
                                        </td>
                                        <td class="text-right bold">
                                            <asp:Label ID="lblVisa_Total" runat="server" Text="0.00"></asp:Label>
                                            Tk
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-sm-5 col-md-4 text-center">
                                <asp:LinkButton runat="server" ID="lnkItcl" CommandArgument="ITCL" OnCommand="lnk_Command">
                                        <div class="bigbutton">
                                            <img src="Images/qcash.png" width="98" height="94" border="0" alt="" />
                                        </div>
                                </asp:LinkButton>
                                <asp:ConfirmButtonExtender ID="ConfirmButtonExtender3" runat="server" TargetControlID="lnkItcl"
                                    ConfirmText="Do you want to pay using Q-Cash Card?">
                                </asp:ConfirmButtonExtender>
                            </div>
                        </div>
                    </div>
                    <asp:Panel runat="server" ID="PanelError" CssClass="div-error" Visible="false">
                    </asp:Panel>
                    <%--<textarea runat="server" id="txtxml" rows="16" style="width: 100%" visible="false"></textarea>--%>
                    <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
                </div>
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
