<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Passport_Payment_Receipt.aspx.cs"
    MasterPageFile="~/MasterBootstrap.master" Inherits="Passport_Payment_Receipt_Aspx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>Passport Payment Receipt</title>
    <link href="CSS/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="scripts/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="scripts/jquery.alerts.js" type="text/javascript"></script>
    <script src="scripts/jquery.watermark.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            jQueryInit();
        });
        function pageLoad(sender, args) {
            if (args.get_isPartialLoad()) jQueryInit();
        }
        function jQueryInit() {
            $(document).ready(function () {

                // Prevent the backspace key from navigating back.
                $(document).unbind('keydown').bind('keydown', function (event) {
                    var doPrevent = false;
                    if (event.keyCode === 8) {
                        var d = event.srcElement || event.target;
                        //alert();
                        if ((d.tagName.toUpperCase() === 'INPUT' && (
                    d.type.toUpperCase() === 'TEXT'
                    || d.type.toUpperCase() === 'PASSWORD'))
                    || d.tagName.toUpperCase() === 'TEXTAREA'
                    || $(d).hasClass("editable")
                    ) {
                            doPrevent = d.readOnly
                    || d.disabled;
                        }
                        else {
                            doPrevent = true;
                        }
                    }
                    if (doPrevent) {
                        event.preventDefault();
                    }
                });
            });

            $('input:text[placeholder]').each(function () {
                $(this).watermark($(this).attr('placeholder'));
            });
            
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

            //Disable All Combo
            $("select option[value='']").attr('disabled', true);

            $('#ctl00_ContentPlaceHolder2_dboPaidThrough_0,#ctl00_ContentPlaceHolder2_dboPaidThrough_1').change(function () {
                if ($(this).val() === "ITCL") {
                    $('#TR_MM').hide();
                    $('#TR_ITCL').show();
                    $('#ctl00_ContentPlaceHolder2_txtMobile').removeAttr('required').val('');
                    $('#ctl00_ContentPlaceHolder2_txtCardNumber').attr('required', 'true');
                }
                else if ($(this).val() === "MM") {
                    $('#TR_MM').show();
                    $('#TR_ITCL').hide();
                    $('#ctl00_ContentPlaceHolder2_txtCardNumber').removeAttr('required').val('');
                    $('#ctl00_ContentPlaceHolder2_txtMobile').attr('required', 'true');
                }
            });

            var selectedVal = $('input[name=ctl00$ContentPlaceHolder2$dboPaidThrough]:checked').val();
            if (selectedVal == 'ITCL') {
                $('#TR_MM').hide();
                $('#TR_ITCL').show();
                $('#ctl00_ContentPlaceHolder2_txtMobile').removeAttr('required').val('');
                $('#ctl00_ContentPlaceHolder2_txtCardNumber').attr('required', 'true');
            }
            else if (selectedVal == 'MM') {
                $('#TR_MM').show();
                $('#TR_ITCL').hide();
                $('#ctl00_ContentPlaceHolder2_txtCardNumber').removeAttr('required').val('');
                $('#ctl00_ContentPlaceHolder2_txtMobile').attr('required', 'true');
            }
        }    
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Trust Bank Checkout
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-2 text-center">
                    <img src="Images/checkout.png" width="100" height="100" border="0" alt="Checkout" />
                </div>
                <div class="col-sm-9 col-md-8">
                    <div>
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                Passport Payment Receipt
                            </div>
                            <div style="background-color:#F9F9F9" class="panel-body">
                                <div class="col-sm-2 text-center hidden-xs">
                                    <img src="Images/Receipt.png" width="42" height="50" />
                                </div>
                                <div class="col-sm-10">
                                    <div class="courier" style="margin-bottom:15px;">
                                        Enter the following information to download your Passport Payment Receipt
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label bold">
                                            Paid Through</label>
                                        <div class="col-sm-8">
                                            <asp:RadioButtonList ID="dboPaidThrough" runat="server" AutoPostBack="false" 
                                                    RepeatDirection="Vertical"
                                                    RepeatLayout="Flow" 
                                                    style="font-weight:normal"
                                                    >
                                                <asp:ListItem Text="Branch/ Mobile Money/ Paypoint" Value="MM" Selected="True"></asp:ListItem>
                                                <asp:ListItem Text="Q-Cash Card" Value="ITCL"></asp:ListItem>
                                            </asp:RadioButtonList>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label bold">
                                            Reference No.</label>
                                        <div class="col-sm-5">
                                            <asp:TextBox ID="txtRefID" runat="server" CssClass="form-control" title="Passport Reference No. (3xxxxxxxxxxxxx)"
                                                pattern="^([3])[a-zA-Z0-9]{13}$" placeholder="3xxxxxxxxxxxxx" MaxLength="14"
                                                required></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-group" id="TR_MM">
                                        <label class="col-sm-4 control-label bold">
                                            Mobile Number</label>
                                        <div class="col-sm-5">
                                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" title="Mobile No. (8801xxxxxxxxx)"
                                                pattern="^8801\d{9}$" placeholder="8801xxxxxxxxx" MaxLength="13" required></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-group" id="TR_ITCL"> 
                                        <label class="col-sm-4 control-label bold">
                                            Card Number</label>
                                        <div class="col-sm-5">
                                            <asp:TextBox ID="txtCardNumber" CssClass="form-control" runat="server" title="Card Number"
                                                placeholder="" MaxLength="50" required></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label">
                                            </label>
                                        <div class="col-sm-6 col-md-5">
                                            <img src='Images/loading1.gif' id="ImgChallenge" alt="Captcha" style="border: 1px solid silver;
                                                padding: 2px; border-radius: 4px; cursor: pointer" width="135" height="35" title="Another Challenge Image" />
                                            <img src="Images/reload.png" id="ImgChallengeReload" style="cursor: pointer" title="Another Challenge Image"
                                                alt="Refresh" width="16" height="16" border="0" />
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label class="col-sm-4 control-label bold">
                                             Challenge Key</label>
                                        <div class="col-sm-5">
                                            <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server" MaxLength="5"
                                                required autocomplete="off" pattern="^\d{5}$" ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        
                                        <div class="col-sm-4 col-sm-offset-4" >
                                            <asp:Button ID="cmd" CssClass="btn btn-success btn-block" runat="server" Text="Print" OnClick="cmd_Click" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
