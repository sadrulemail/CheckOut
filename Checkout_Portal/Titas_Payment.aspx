<%@ Page Title="Titas Non-Metered" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="Titas_Payment.aspx.cs" Inherits="Titas_Payment" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script>
        function CalcTotal1() {
            var Surchage = $('#ctl00_ContentPlaceHolder2_txtSurcharge').val();
            var Amount = $('#ctl00_ContentPlaceHolder2_txtBillAmount').val();
            if (Surchage=="") Surchage = 0;
            if (Amount=="") Amount = 0;
            var TotalBill = (parseFloat(Surchage).toFixed(2) * 1) + (parseFloat(Amount).toFixed(2) * 1);
            $('#ctl00_ContentPlaceHolder2_txtTotalBill').val(TotalBill.toFixed(2));
            //console.log(TotalBill);
        }
        function pageReady() {
            $('#ctl00_ContentPlaceHolder2_txtSurcharge,#ctl00_ContentPlaceHolder2_txtBillAmount')
                .on('propertychange keyup paste input', function () {
                CalcTotal1();
            });
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTitle" runat="server" Text="Titas Gas Payment (Non-Metered)"></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <table width="100%">
                <tr>
                    <td valign="top">
                        <table class="Panel1">
                            <tr>
                                <td>Payment Type: Non-Metered:</td>
                                <td>
                                    <asp:RadioButtonList ID="dboPaymentType" runat="server" AutoPostBack="true" 
                                        RepeatDirection="Horizontal" ui="buttonset"
                                        OnSelectedIndexChanged="dboPaymentType_SelectedIndexChanged">
                                        <asp:ListItem Value="1" Selected="True" Text="Payment Entry"></asp:ListItem>
                                        <%--<asp:ListItem Value="2" Text="Installment Payment" Enabled="false"></asp:ListItem>--%>
                                        <asp:ListItem Value="3" Text="Demand Note"></asp:ListItem>
                                        
                                    </asp:RadioButtonList>
                                </td>

                            </tr>
                        </table>
                    
            <asp:Panel runat="server" ID="Panel1" style="display:table">

                <div class="group">
                    <h1>Titas Gas Non-Metered Payment Entry</h1>
                    
                    <div class="group-body">
                        <div style="display:inline-block">
                        <fieldset class="group">
                            <legend>Search</legend>
                            <asp:TextBox ID="txtCustomerID" MaxLength="13" Width="150px" placeholder="customer id" runat="server" onfocus="select()"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="txtCustomerID" ValidationGroup="NMPayEntry" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:FilteredTextBoxExtender runat="server" ID="filtxtCustomerID" TargetControlID="txtCustomerID" FilterMode="ValidChars" ValidChars="0123456789" />
                            <asp:Button ID="cmdSearch" runat="server" ValidationGroup="NMPayEntry" Text="Search" OnClick="cmdSearch_Click" />
                        </fieldset>
                        
                        <fieldset class="group" runat="server" id="PanelCusInfo" visible="false">
                            <legend>Customer Info</legend>
                            
                            <table class="table-stripe">
                                <tr>
                                    <td>Customer Code: </td>
                                    <td>
                                        <asp:Label ID="lblCusCode" runat="server" Text="" CssClass="bold"></asp:Label>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Customer Name:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCusName" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Address:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCusAddress" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Applicance:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblApplicance" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                            </div>
                        <fieldset class="group" style="display:inline-block" runat="server" id="PanelPaymentInfo" visible="false">
                            <legend>Payment Info</legend>
                            <table class="table-stripe">
                                <tr>
                                    <td>Particulars: </td>
                                    <td>
                                        <asp:TextBox ID="txtParticulars" MaxLength="200" Width="250px" placeholder="MMYY, MMYY, MMYY" runat="server"></asp:TextBox>
                                        <asp:FilteredTextBoxExtender runat="server" ID="filtxtParticulars" TargetControlID="txtParticulars" FilterMode="ValidChars" ValidChars="0123456789," />
                                    </td>
                                </tr>
                                <tr>
                                    <td>Surcharge:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSurcharge" TextMode="Number" min="0" step="0.01" Width="120px" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Amount:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtBillAmount" TextMode="Number" min="0" step="0.01" Width="120px" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Total:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTotalBill" TextMode="Number" step="0.01" Text="0" Enabled="false" CssClass="bold" Width="120px" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Cash Received:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCashReceived" TextMode="Number" min="0" step="0.01" CssClass="bold" Width="120px" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Mobile:
                                    </td>
                                    <td>
                                        +88<asp:TextBox ID="txtCustomerContactNo" PlaceHolder="Contact No" ToolTip="Bangladesh Mobile No. (01xxxxxxxxx)" runat="server" 
                                            Width="150px" MaxLength="11" pattern="^0(1[3456789])\d{8}$"></asp:TextBox>
                                        
                                        <span class="silver">01xxxxxxxxx</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdPay" runat="server" Text="Pay Non-Metered Payment" OnClick="cmdPay_Click" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <div class="bold center" style="font-size:150%">
                        <asp:Literal ID="litStatus1" runat="server"></asp:Literal>
                            </div>
                    </div>
                </div>
            </asp:Panel>
            <asp:HiddenField ID="hidRefID" runat="server" />
            <asp:HiddenField ID="hidPayID" runat="server" />
            <asp:Panel runat="server" ID="Panel2" style="display:table" Visible="false">

                <div class="group">
                    <h1 style="background-color: #b6ff00">Titas Gas Non-Metered Installment Payment</h1>
                    <div class="group-body">
                        <div style="display:inline-block">
                        <fieldset class="group">
                            <legend>Search</legend>
                        <asp:TextBox ID="txtInvoiceNumber2" MaxLength="20" Width="150px" placeholder="invoice number" runat="server" onfocus="select()"></asp:TextBox>
                            <asp:FilteredTextBoxExtender runat="server" ID="filtxtInvoiceNumber2" TargetControlID="txtInvoiceNumber2" FilterMode="ValidChars" ValidChars="0123456789" />
                            <asp:Button ID="cmdSearch2" runat="server" Text="Search" OnClick="cmdSearch2_Click" />
                            </fieldset>
                        <fieldset class="group" runat="server" id="PanelCusInfo2" visible="false">
                            <legend>Customer Info</legend>
                            
                            <table class="table-stripe">
                                <tr>
                                    <td>Customer Code: </td>
                                    <td>
                                        <asp:Label ID="lblCustomerCode2" runat="server" Text="1234567890123" CssClass="bold"></asp:Label>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Customer Name:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCustomerName2" runat="server" Text="Customer Name" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Address:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCusAddress2" runat="server" Text="Customer Address" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Applicance:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblApplicance2" runat="server" Text="AG2" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                            </div>
                        <fieldset class="group" style="display:inline-block" runat="server" id="PanelPaymentInfo2" visible="false">
                            <legend>Payment Info</legend>
                            <table class="table-stripe">
                                <tr>
                                    <td>Invoice No.
                                    </td>
                                    <td>
                                        <asp:Label ID="lblInvoice" runat="server" Text="27364" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Due Date:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblDueDate" runat="server" Text="17-08-2019" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>                                
                                <tr>
                                    <td>Surcharge:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSurcharge2" Enabled="false" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Amount:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAmount2" Enabled="false" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Total:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTotalBill2" Enabled="false" CssClass="bold" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Cash Received:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCashReceived2" TextMode="Number" min="0" step="0.01" CssClass="bold" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Mobile:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCustomerContactNo2" PlaceHolder="Contact No" ToolTip="Bangladesh Mobile No. (+8801xxxxxxxxx)" runat="server" 
                                            Width="150px" MaxLength="50" pattern="^[\+]880(1[3456789])\d{8}$"></asp:TextBox>
                                        
                                        <span class="silver">+8801xxxxxxxxx</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdPay2" runat="server" Text="Pay Non-Metered Installment" style="background-image: none;box-shadow: 0 0 3px #999 inset;background-color: #b6ff00" OnClick="cmdPay2_Click" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <div class="bold center" style="font-size:150%">
                        <asp:Literal ID="litStatus2" runat="server"></asp:Literal>
                            </div>
                    </div>
                </div>
            </asp:Panel>

            <asp:Panel runat="server" ID="Panel3" style="display:table" Visible="false">

                <div class="group">
                    <h1 style="background-color: #00ffff">Titas Gas Non-Metered Bill Collection for Demand Note</h1>
                    <div class="group-body">
                        <div style="display:inline-block">
                        <fieldset class="group">
                            <legend>Search</legend>
                        <asp:TextBox ID="txtInvoiceNumber3" MaxLength="20" Width="150px" placeholder="invoice number" runat="server" onfocus="select()"></asp:TextBox>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtInvoiceNumber3" ValidationGroup="NMPayDemandNote" runat="server" ErrorMessage="*" ForeColor="Red"></asp:RequiredFieldValidator>
                            <asp:FilteredTextBoxExtender runat="server" ID="FiltxtInvoiceNumber3" TargetControlID="txtInvoiceNumber3" FilterMode="ValidChars" ValidChars="0123456789" />
                            <asp:Button ID="cmdSearch3" runat="server" ValidationGroup="NMPayDemandNote" Text="Search" OnClick="cmdSearch3_Click"  />
                            </fieldset>
                        <fieldset class="group"  runat="server" id="PanelCusInfo3" visible="false">
                            <legend>Customer Info</legend>
                            
                            <table class="table-stripe">
                                <tr>
                                    <td>Customer Code: </td>
                                    <td>
                                        <asp:Label ID="lblCustomerCode3" runat="server" Text="1234567890123" CssClass="bold"></asp:Label>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Customer Name:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCustomerName3" runat="server" Text="Customer Name" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Address:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCusAddress3" runat="server" Text="Customer Address" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Customer ID:
                                    </td>
                                    <td style="max-width:250px">
                                        <asp:Label ID="lblCustomerID3" runat="server" Text="Customer ID" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Mobile:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMobile" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                            </div>
                        <fieldset class="group" style="display:inline-block"  runat="server" id="PanelPaymentInfo3" visible="false">
                            <legend>Payment Info</legend>
                            <table class="table-stripe">
                                <tr>
                                    <td>Invoice No.
                                    </td>
                                    <td>
                                        <asp:Label ID="lblInvoice3" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Due Date:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblDueDate3" runat="server" Text="" CssClass="bold"></asp:Label>
                                    </td>
                                </tr>                                
                                
                                <tr>
                                    <td>Payment Amount:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTotalBill3" Enabled="false" CssClass="bold" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Cash Received:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCashReceived3" TextMode="Number" min="0" step="0.01" CssClass="bold" Width="120px" placeholder="0" runat="server"></asp:TextBox>

                                    </td>
                                </tr>
                                <tr>
                                    <td>Mobile:
                                    </td>
                                    <td>
                                        +88<asp:TextBox ID="txtCustomerContactNo3" PlaceHolder="Contact No" ToolTip="Bangladesh Mobile No. (+8801xxxxxxxxx)" runat="server" 
                                            Width="150px" MaxLength="11" pattern="^0(1[3456789])\d{8}$"></asp:TextBox>
                                        
                                        <span class="silver">01xxxxxxxxx</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td></td>
                                    <td>
                                        <asp:Button ID="cmdPay3" runat="server" Text="Pay Non-Metered Demand Note"  style="background-image: none;box-shadow: 0 0 3px #999 inset;background-color: #00ffff" OnClick="cmdPay3_Click" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <div class="bold center" style="font-size:150%">
                        <asp:Literal ID="litStatus3" runat="server"></asp:Literal>
                            </div>
                    </div>
                </div>
            </asp:Panel>
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
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>

