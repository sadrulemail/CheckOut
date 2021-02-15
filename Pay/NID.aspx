<%@ Page Title="" Language="C#" MasterPageFile="MasterPay.master" AutoEventWireup="true" CodeFile="NID.aspx.cs" Inherits="NID" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register src="../CommonControl.ascx" tagname="CommonControl" tagprefix="uc1" %>

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
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <div class="col-sm-2">
            <a href="http://www.nidw.gov.bd/" target="_blank">
                <img src="../Images/Marchent/nid.jpg" width="100" height="94" alt="NID" />
            </a>
        </div>
        <div class="col-sm-8" style="padding: 15px 0 0 0;">
            National ID Payment
        </div>
        <div class="col-sm-2 hidden-xs">
            <%--<img src="../Images/Marchent/nid.jpg" width="100" height="100" alt="National ID"/>--%>
            <img src="../Images/checkout.png" width="100" height="100" alt="Checkout" />
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <uc1:commoncontrol ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <%--  <div style="padding: 30px;" class="row col-md-12">--%>

            <div class="form-inline">
                <div class="row">
                    <label class="col-sm-4 control-label">
                        National ID</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:TextBox ID="txtNid" runat="server" CssClass="form-control" MaxLength="17" placeholder="National Id No."></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtCustomer" runat="server"
                            ControlToValidate="txtNid" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>

                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        Correction Type</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:DropDownList ID="ddlCorrection" runat="server" AppendDataBoundItems="True" CssClass="form-control"
                            DataTextField="CorrectionName" DataValueField="CorrectionID" AutoPostBack="True"
                            CausesValidation="false" OnSelectedIndexChanged="ddlCorrection_SelectedIndexChanged">

                            <asp:ListItem Text="Select Type" Value=""></asp:ListItem>
                            <asp:ListItem Text="NID Correction" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Lost/Damage NID" Value="2"></asp:ListItem>

                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorFromYear" runat="server"
                            ControlToValidate="ddlCorrection" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        Service Type</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:DropDownList ID="ddlServiceType" runat="server" AppendDataBoundItems="True" CssClass="form-control"
                            DataTextField="ServicehName" DataValueField="ServiceID" AutoPostBack="False"
                            CausesValidation="false">

                            <%-- <asp:ListItem Text="Select Type" Value="0"></asp:ListItem>--%>
                            <asp:ListItem Text="Regular" Value="R"></asp:ListItem>
                            <asp:ListItem Text="Express" Value="E"></asp:ListItem>

                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorFromMonth" runat="server"
                            ControlToValidate="ddlServiceType" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>

            <div class="form-inline">
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
            <div class="row" style="margin-top: 5px">
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnDuesAmount" CssClass="form-control btn btn-success" runat="server" Text="Next" OnClick="btnDuesAmount_Click" />
                    <asp:HiddenField ID="hidRefID" runat="server" />
                </div>
                <%--  <div class="col-sm-4 col-md-3 has-feedback">
                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>--%>
            </div>

            <div class="row" style="margin-top: 5px">
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnPayment" Visible="false" CssClass="form-control btn btn-success" runat="server" Text="Payment" OnClick="btnPayment_Click" />
                </div>
                <div class="col-sm-4 col-md-3 has-feedback bold" style="font-size:150%">
                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>
            </div>
            <%--     </div>--%>
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
