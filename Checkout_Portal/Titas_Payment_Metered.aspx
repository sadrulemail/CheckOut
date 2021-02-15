<%@ Page Title="Titas Metered" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Titas_Payment_Metered.aspx.cs" Inherits="Titas_Payment_Metered" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script src="script/Titas_Metered.js" type="text/javascript"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Titas Gas Payment (Metered)"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <table width="100%">
                <tr>
                    <td valign="top">
                        <asp:Panel runat="server" ID="Panel1" Style="display: table">
                            <div class="group">
                                <h1 style="background-color: #b6ff00">Titas Gas Metered Payment Entry</h1>

                                <div class="group-body">
                                    <div style="display: inline-block">
                                        <fieldset class="group">
                                            <legend>Search</legend>
                                            <table>
                                                <tr>
                                                    <td>
                                                        <span class="bold">Customer:</span>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtCustomerID" MaxLength="14" Width="120px" placeholder="customer code" runat="server" onfocus="select()"></asp:TextBox>

                                                        <asp:FilteredTextBoxExtender runat="server" ID="filtxtCustomerID" TargetControlID="txtCustomerID" FilterMode="ValidChars" ValidChars="0123456789" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>

                                                        <span class="bold">Invoice:</span>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtInvoiceNo" MaxLength="13" Width="120px" placeholder="invoice no" runat="server" onfocus="select()"></asp:TextBox>

                                                        <asp:FilteredTextBoxExtender runat="server" ID="filtxtInvoiceNo" TargetControlID="txtInvoiceNo" FilterMode="ValidChars" ValidChars="0123456789" />


                                                        <asp:Button ID="cmdSearch" runat="server" Text="Search" OnClick="cmdSearch_Click" />
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>

                                        <fieldset class="group" runat="server" id="PanelCusInfo" visible="false">
                                            <legend>Customer Info</legend>

                                            <table class="table-stripe" width="100%">
                                                <tr>
                                                    <td>Customer Code: </td>
                                                    <td>
                                                        <asp:Label ID="lblCusCode" runat="server" Text="" CssClass="bold"></asp:Label>

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Invoice No: </td>
                                                    <td>
                                                        <asp:Label ID="lblinvoiceNo" runat="server" Text="" CssClass="bold"></asp:Label>

                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Customer Name:
                                                    </td>
                                                    <td style="max-width: 250px">
                                                        <asp:Label ID="lblCusName" runat="server" Text="" CssClass="bold"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Settle Date:
                                                    </td>
                                                    <td style="max-width: 250px">
                                                        <asp:Label ID="lblSettleDT" runat="server" Text="" CssClass="bold"></asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>Zone:
                                                    </td>
                                                    <td>
                                                        <asp:Label ID="lblZone" runat="server" Text="" CssClass="bold"></asp:Label>
                                                    </td>
                                                </tr>
                                            </table>
                                        </fieldset>
                                    </div>
                                    <fieldset class="group" style="display: inline-block" runat="server" id="PanelPaymentInfo" visible="false">
                                        <legend>Payment Info</legend>
                                        <table class="table-stripe">
                                            <tr>
                                                <td>Issue Month: </td>
                                                <td class="bold">
                                                    <asp:Label ID="lblIssueMonth" runat="server"></asp:Label>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Invoice Amount: </td>
                                                <td class="bold">
                                                    <asp:TextBox ID="txtInvoiceAmount" CssClass="bold" Enabled="false" TextMode="Number" min="0" step="0.01" Width="120px" runat="server"></asp:TextBox>


                                                </td>
                                            </tr>

                                            <tr>
                                                <td>Rev.Stamp Amount: </td>
                                                <td class="bold">
                                                    <asp:TextBox ID="txtRevAmount" Enabled="false" TextMode="Number" min="0" Width="120px" runat="server"></asp:TextBox>


                                                </td>
                                            </tr>

                                            

                                            <tr>
                                                <td>Source Tax:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtSourceTax" TextMode="Number" min="0" step="0.01" Width="120px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr class="chalan-tr hidden">
                                                <td>Challan No:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtChalanNo" placeholder="challan no" MaxLength="100" Width="120px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr class="chalan-tr hidden">
                                                <td>Challan Date:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtChalanDate" CssClass="Date" Width="85px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr class="chalan-tr hidden">
                                                <td>Challan Bank:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtChalanBank" placeholder="bank name" MaxLength="100" Width="300px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr class="chalan-tr hidden">
                                                <td>Challan Bank Branch:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtChalanBankBranch"  placeholder="branch name" MaxLength="100" Width="300px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Paid Amount:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtPaidAmount" TextMode="Number" min="0" step="0.01" Enabled="false" Width="120px" runat="server"></asp:TextBox>

                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Total Amount:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtTotalBill" TextMode="Number" step="0.01" Text="0" Enabled="false" CssClass="bold" Width="120px" runat="server"></asp:TextBox>
                                                    <small>(Rev.Stamp + Source Tax + Paid Amount)</small>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="bold" style="color:green">Cash Receive:
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCashReceived" TextMode="Number" min="0" step="0.01" Enabled="false"  CssClass="bold" Width="120px" runat="server"></asp:TextBox>
                                                    <small>(Rev.Stamp + Paid Amount)</small>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Mobile:
                                                </td>
                                                <td>+88<asp:TextBox ID="txtCustomerContactNo" PlaceHolder="Contact No" ToolTip="Bangladesh Mobile No. (01xxxxxxxxx)" runat="server"
                                                    Width="150px" MaxLength="11" pattern="^0(1[3456789])\d{8}$"></asp:TextBox>

                                                    <span class="silver">01xxxxxxxxx</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td></td>
                                                <td>
                                                    <asp:Button ID="cmdPay" runat="server" Text="Pay Metered Payment" OnClick="cmdPay_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </fieldset>
                                    <div class="bold center" style="font-size: 150%">
                                        <asp:Literal ID="litStatus1" runat="server"></asp:Literal>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <asp:HiddenField ID="hidRefID" runat="server" />
                        <asp:HiddenField ID="hidPayID" runat="server" />

                    </td>
                    <td style="padding-left: 20px" valign="top" align="right">
                        <img src="Images/titaslogo.jpg" width="128" height="128" style="border-radius: 50%" class="Shadow" />
                    </td>
                </tr>
            </table>
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



