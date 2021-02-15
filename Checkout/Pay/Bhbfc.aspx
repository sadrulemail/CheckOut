<%@ Page Title="" Language="C#" MasterPageFile="~/Pay/MasterPay.master" AutoEventWireup="true"
    CodeFile="Bhbfc.aspx.cs" Inherits="Bhbfc" Culture="en-NZ" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="../CommonControl.ascx" TagName="CommonControl" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>National ID Payment</title>
    <script type="text/javascript">
        //Refresh Challenge Key
        $('#ImgChallengeReload,#ImgChallenge').click(function () {
            $('#ImgChallenge').attr('src', 'Images/loading1.gif');
            $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('').focus();
            setTimeout(function () {
                $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
            }, 100);
        });
        $('#ImgChallenge').attr('src', 'captcha.ashx?rand=' + Math.random());
        $('#ctl00_ContentPlaceHolder2_txtCaptcha').val('');

    </script>
    <script type="text/javascript">
        function BindPageFunction() {
            $('#chkAgree').change(function () {
                //    console.log($('#chkAgree:checked').length));
                //    $('input:submit').attr('disabled', $('#chkAgree:checked'));
                //$('input:submit').attr('disabled', $('#chkAgree:checked'));
                if ($("#chkAgree").is(':checked')) {
                    $('input:submit').removeAttr('disabled');
                }
                else {
                    $('input:submit').attr('disabled', 'disabled');
                }
            });
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-sm-2">
            <a href="http://www.nidw.gov.bd/" target="_blank">
                <img src="../Images/Marchent/bhbfc.jpg" width="100" height="100" alt="Passport" />
            </a>
        </div>
        <div class="col-sm-8" style="padding: 15px 0 0 0;">
            <div style="font-size: 80%">
                Bangladesh House Building Finance Corporation
            </div>
            Loan Re-Payment System
        </div>
        <div class="col-sm-2 hidden-xs">
            <%--  <div style="padding: 30px;" class="row col-md-12">--%>
            <img src="../Images/checkout.png" width="100" height="100" alt="Checkout" />
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <%--  <div style="padding: 30px;" class="row col-md-12">--%>
            <asp:Panel ID="panelLoanpayment" runat="server">
                <div class="form-group">
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Account No
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:TextBox ID="txtAccNo" runat="server" CssClass="form-control" MaxLength="13"
                                Text="3888888880001" 
                                placeholder="enter appropriate loan a/c no"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtCustomer" runat="server"
                                ControlToValidate="txtAccNo" ErrorMessage="*" Style="margin: -20px 10px 5px 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic"
                                CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            <asp:RegularExpressionValidator ID="RegExpValAcc"  Display="Dynamic"
                               ValidationExpression="\d{13}" ControlToValidate="txtAccNo" ForeColor="Red"
                                runat="server"
                                ErrorMessage="Enter valid Account no."></asp:RegularExpressionValidator>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Account Name
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:TextBox ID="txtAccname" runat="server" CssClass="form-control" MaxLength="255" placeholder="enter loan a/c name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                ControlToValidate="txtAccname" ErrorMessage="*" Style="margin: -20px 10px 5px 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic"
                                CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label">
                            Payment Amount</label>
                        <div class="col-sm-4 col-md-3 has-feedback">
                            <asp:TextBox ID="txtPaymentAmount" runat="server" CssClass="form-control" TextMode="Number" MaxLength="255" placeholder="installment amount"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                                ControlToValidate="txtPaymentAmount" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label">
                            Branch Name</label>
                        <div class="col-sm-4 col-md-3 has-feedback">
                            <asp:DropDownList ID="ddlBranch" runat="server" AppendDataBoundItems="True" CssClass="form-control" DataSourceID="SqlDataSourceBranch"
                                DataTextField="BranchName" DataValueField="BranchCode" AutoPostBack="False"
                                CausesValidation="false">
                                <asp:ListItem Text="select branch" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                SelectCommand="SELECT BranchCode,BranchName FROM dbo.Bhbfc_Branch with (nolock) order by BranchName"></asp:SqlDataSource>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                ControlToValidate="ddlBranch" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label">
                            Payment Purpose</label>
                        <div class="col-sm-4 col-md-3 has-feedback">

                            <asp:DropDownList ID="ddlPaymentPurpose" runat="server" AppendDataBoundItems="True" CssClass="form-control"
                                AutoPostBack="False"
                                CausesValidation="false">
                                <asp:ListItem Text="Loan Installment" Value="M"></asp:ListItem>
                            </asp:DropDownList>

                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                                ControlToValidate="ddlPaymentPurpose" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Mobile No
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" MaxLength="14" placeholder="+880xxxxxxxxxx"
                                title="Bangladesh Mobile No. +8801xxxxxxxxx" patern="^[\+]880(1[3456789])\d{8}$" required="true"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator30" runat="server"
                                ControlToValidate="txtMobile" ErrorMessage="*" Style="margin: -20px 10px 5px 5px" ForeColor="Red"
                                Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic"
                                CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label">
                            Email</label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:TextBox ID="txtEmail" CssClass="form-control" TextMode="Email" runat="server"
                                ToolTip="Email Address" AutoCompleteType="Email" MaxLength="255" placeholder="Enter Email address"></asp:TextBox>
                            <%--  <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                            ControlToValidate="txtName" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>--%>
                        </div>

                    </div>
                </div>



                <%-- <div class="form-group">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        Previous Passport Expiry Date</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:TextBox ID="txtExpDate" CssClass="form-control Date" date-format="mm/dd/yyyy" MaxLength="10" runat="server"></asp:TextBox>
                    </div>
                    <div class="col-sm-4 col-md-5" style="font-style:italic">(keep blank for new passport)</div>
                </div>
            </div>--%>
                <div class="form-group" runat="server" id="CaptchaDiv">
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label">
                        </label>
                        <div class="col-sm-6 col-md-5">
                            <img src='../Images/loading1.gif' id="ImgChallenge" alt="Captcha" style="border: 1px solid silver; padding: 2px; border-radius: 4px; cursor: pointer"
                                width="135" height="35" title="Another Challenge Image" />
                            <img src="../Images/reload.png" id="ImgChallengeReload" style="cursor: pointer" title="Another Challenge Image"
                                alt="Refresh" width="16" height="16" border="0" />
                        </div>
                    </div>
                    <div class="row" style="margin-top: 5px;">
                        <label class="col-sm-4 control-label bold">
                            Challenge Key</label>
                        <div class="col-sm-3">
                            <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server" MaxLength="5" placeholder="# # # # #"
                                required autocomplete="off" pattern="^\d{5}$" ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                        </div>
                    </div>
                </div>

            </asp:Panel>
            <div class="row">
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnNext" CssClass="form-control btn btn-success" Style="margin-top: 5px" runat="server" Text="Next" OnClick="btnNext_Click" />
                    <asp:HiddenField ID="hidBranchCode" runat="server" />
                    <asp:HiddenField ID="hidLoanAcc" runat="server" />
                      <asp:HiddenField ID="hidPayPurpose" runat="server" />
                </div>
                <%--  <div class="col-sm-4 col-md-3 has-feedback">
                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>--%>
            </div>
            <asp:Panel ID="panelWarning" runat="server" Visible="false">
                <div class="alert alert-danger" role="alert" style="text-align: center;">
                    Customer Loan Information not found. Please provide correct Loan Account No.
                </div>
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnPrevious" CssClass="form-control btn btn-success" runat="server" Text="Back" OnClick="btnPrevious_Click" />
                    <%-- <asp:HiddenField ID="HiddenField1" runat="server" />--%>
                </div>

            </asp:Panel>


            <asp:Panel runat="server" ID="panelLoanInfo" Visible="false">
                <asp:Literal ID="litCSS" runat="server"></asp:Literal>
                <div class="form-group">
                      <div class="row">
                        <label class="col-sm-4 control-label">
                            Account Type
                        </label>
                        <div class="col-md-6 col-sm-7 bold">
                            <asp:Label ID="labelAccType" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Account Name
                        </label>
                        <div class="col-md-6 col-sm-7 ">
                            <asp:Label ID="labelName" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Account No
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelAccNo" runat="server" Text=""></asp:Label>
                             <asp:Label ID="labelFullAccNo" runat="server" Text=""></asp:Label>
                        </div>
                    </div>

                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Type
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelloantype" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Product
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelProduct" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Loan Category
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelCategory" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Branch Name
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelBranch" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Payment Amount
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="lblAmount" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Payment Purpose
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelPayPurpose" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Mobile
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelMobile" runat="server" Text=""></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <label class="col-sm-4 control-label">
                            Email
                        </label>
                        <div class="col-md-6 col-sm-7 has-feedback">
                            <asp:Label ID="labelEmail" runat="server" Text=""></asp:Label>
                        </div>
                    </div>



                    <div class="row">
                        <label class="col-sm-4 control-label"></label>
                        <div>
                            <asp:CheckBox ID="chkAgree" runat="server" ClientIDMode="Static" Text="I have accept all the" />
                            <a class="bold pointer" data-toggle="modal" data-target="#terms">Terms & Conditions</a>
                        </div>
                    </div>
                </div>
                <div class="row" style="margin-top: 5px">
                    <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                        <asp:Button ID="btnPayment" Visible="true" CssClass="form-control btn btn-success" runat="server"
                            Enabled="false" ClientIDMode="Static"
                            Text="Payment" OnClick="btnPayment_Click" />
                    </div>
                    <%--  <div class="col-sm-4 col-md-3 has-feedback bold" style="font-size: 150%">

                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>--%>
                </div>




                <!-- Terms Modal -->
                <div id="terms" class="modal fade" role="dialog">
                    <div class="modal-dialog">

                        <!-- Modal content-->
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                                <h4 class="modal-title">Terms & Conditions</h4>
                            </div>
                            <div class="modal-body">
                                <p>Any discrepancy or error or default arising from the misinformation provided by the client while making payment through internet gateway shall be resolved or settled as per the existing rules and regulations of BHBFC.</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            </div>
                        </div>

                    </div>
                </div>
                <!-- Terms Modal -->

            </asp:Panel>
        </ContentTemplate>

        <Triggers>
            <asp:PostBackTrigger ControlID="btnPayment" />
        </Triggers>
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
