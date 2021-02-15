<%@ Page Title="" Language="C#" MasterPageFile="MasterPay.master" AutoEventWireup="true" CodeFile="Bgsl.aspx.cs" Inherits="Pay_Bgsl" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register src="../CommonControl.ascx" tagname="CommonControl" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>BGDSL Payment</title>
    <script type="text/javascript">
        function RefreshPage() {
            window.location.reload()
        }
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
            <a href="http://www.bgdcl.org.bd/" target="_blank">
                <img src="../Images/Marchent/bgdcl.jpg" width="120" height="80"  alt="bgdcl" />
            </a>
        </div>
        <div class="col-sm-8">
            Bakhrabad Gas Distribution Company Limited (BGDCL) Payment
        </div>
        <div class="col-sm-2 hidden-xs">
            <img src="../Images/checkout.png" width="100" height="100" alt="Checkout" />
        </div>
    </div>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
      <uc1:commoncontrol ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <%--<div style="padding: 30px;" class="row col-md-12">--%>

            <div class="form-inline">
                <div class="row">

                    <label class="col-sm-4 control-label">
                        Customer Code</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:TextBox ID="txtCustomer" runat="server" CssClass="form-control" MaxLength="18" placeholder="xx-x-xxxxx"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtCustomer" runat="server" ValidationGroup="grpDueAmnt"
                            ControlToValidate="txtCustomer" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>

                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        From Year</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:DropDownList ID="ddlFromYear" CssClass="form-control" runat="server"></asp:DropDownList>

                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorFromYear" runat="server" ValidationGroup="grpDueAmnt"
                            ControlToValidate="ddlFromYear" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        From Month</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <%--    <asp:TextBox ID="txtFromMonth" runat="server" CssClass="form-control" MaxLength="2" Width="100px"></asp:TextBox>--%>
                        <asp:DropDownList ID="ddlFromMonth" runat="server" AppendDataBoundItems="True" CssClass="form-control"
                            DataTextField="FromMonthName" DataValueField="FromMonthID" AutoPostBack="False"
                            CausesValidation="false">

                            <asp:ListItem Text="Select Month" Value=""></asp:ListItem>
                            <asp:ListItem Text="January" Value="01"></asp:ListItem>
                            <asp:ListItem Text="February" Value="02"></asp:ListItem>
                            <asp:ListItem Text="March" Value="03"></asp:ListItem>
                            <asp:ListItem Text="April" Value="04"></asp:ListItem>
                            <asp:ListItem Text="May" Value="05"></asp:ListItem>
                            <asp:ListItem Text="June" Value="06"></asp:ListItem>
                            <asp:ListItem Text="July" Value="07"></asp:ListItem>
                            <asp:ListItem Text="August" Value="08"></asp:ListItem>
                            <asp:ListItem Text="September" Value="09"></asp:ListItem>
                            <asp:ListItem Text="October" Value="10"></asp:ListItem>
                            <asp:ListItem Text="November" Value="11"></asp:ListItem>
                            <asp:ListItem Text="December" Value="12"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorFromMonth" runat="server" ValidationGroup="grpDueAmnt"
                            ControlToValidate="ddlFromMonth" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        End Year</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <asp:DropDownList ID="ddlEndYear" CssClass="form-control" runat="server"></asp:DropDownList>

                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorEndYear" runat="server" ValidationGroup="grpDueAmnt"
                            ControlToValidate="ddlEndYear" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <div class="form-inline">
                <div class="row" style="margin-top: 5px;">
                    <label class="col-sm-4 control-label">
                        End Month</label>
                    <div class="col-sm-4 col-md-3 has-feedback">
                        <%--    <asp:TextBox ID="txtEndMonth" runat="server" CssClass="form-control" MaxLength="2" Width="100px"></asp:TextBox>--%>
                        <asp:DropDownList ID="ddlEndMonth" runat="server" AppendDataBoundItems="True" CssClass="form-control"
                            DataTextField="EndMonthName" DataValueField="EndMonthID" AutoPostBack="False"
                            CausesValidation="false">

                            <asp:ListItem Text="Select Month" Value=""></asp:ListItem>
                            <asp:ListItem Text="January" Value="01"></asp:ListItem>
                            <asp:ListItem Text="February" Value="02"></asp:ListItem>
                            <asp:ListItem Text="March" Value="03"></asp:ListItem>
                            <asp:ListItem Text="April" Value="04"></asp:ListItem>
                            <asp:ListItem Text="May" Value="05"></asp:ListItem>
                            <asp:ListItem Text="June" Value="06"></asp:ListItem>
                            <asp:ListItem Text="July" Value="07"></asp:ListItem>
                            <asp:ListItem Text="August" Value="08"></asp:ListItem>
                            <asp:ListItem Text="September" Value="09"></asp:ListItem>
                            <asp:ListItem Text="October" Value="10"></asp:ListItem>
                            <asp:ListItem Text="November" Value="11"></asp:ListItem>
                            <asp:ListItem Text="December" Value="12"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidatorEndMonth" runat="server" ValidationGroup="grpDueAmnt"
                            ControlToValidate="ddlEndMonth" ErrorMessage="*" Style="margin: 5px" ForeColor="Red"
                            Font-Size="25px" Font-Bold="true" SetFocusOnError="True" Display="Dynamic" class="form-control-feedback"></asp:RequiredFieldValidator>
                    </div>
                </div>
            </div>
            <asp:Panel ID="PanelChalKey" runat="server" CssClass="form-inline">

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
                        <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server" MaxLength="5" placeholder="# # # # #" ValidationGroup="grpDueAmnt"
                            required autocomplete="off" pattern="^\d{5}$" ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                    </div>
                </div>
            </asp:Panel>

            <div class="row" style="margin-top: 5px;">

                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnDuesAmount" CssClass="form-control btn btn-success" runat="server" Text="Next" OnClick="btnDuesAmount_Click" ValidationGroup="grpDueAmnt" />

                    <asp:HiddenField ID="hidRefID" runat="server" />
                </div>
               <%-- <div class="col-sm-4 col-md-3 has-feedback">
                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>--%>
            </div>
            <div class="row" style="margin-top: 5px;">
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnPayment" Visible="false" CssClass="form-control btn btn-success" runat="server" Text="Payment" OnClick="btnPayment_Click" />
                </div>
                 <div class="col-sm-4 col-md-3 has-feedback">
                    <asp:Label ID="lblDueAmount" runat="server" Text=""></asp:Label>
                </div>
            </div>
          <%--  <div class="row" style="margin-top: 5px;">
                <div class="col-sm-4 col-md-3 has-feedback col-md-offset-4 col-sm-offset-4">
                    <asp:Button ID="btnReset" CssClass="form-control btn btn-success" runat="server" Text="Reset" OnClientClick="RefreshPage()" />
                </div>
            </div>--%>
            <%--  </div>--%>
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
