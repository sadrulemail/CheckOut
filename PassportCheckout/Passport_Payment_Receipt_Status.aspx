<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Passport_Payment_Receipt_Status.aspx.cs"
    MasterPageFile="~/MasterBootstrap.master" Inherits="Passport_Payment_Receipt_Status" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>Passport Payment Receipt</title>
    <link href="CSS/jquery.alerts.css" rel="stylesheet" type="text/css" />
    <script src="script/jquery-1.7.2.min.js" type="text/javascript"></script>
    <script src="script/jquery.alerts.js" type="text/javascript"></script>
    <script src="script/jquery.timeago.js" type="text/javascript"></script>
    <script src="script/jquery.watermark.min.js" type="text/javascript"></script>
    <style type="text/css">
        th
        {
            text-align: center;
        }
    </style>
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


                $("time.timeago").timeago();
            });
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
                                Passport Payment Receipt Status (Checked from Passport Office)
                            </div>
                            <asp:Panel ID="PaymentReceiptStatus" runat="server">
                                <div style="background-color: #F9F9F9" class="panel-body">
                                    <div class="col-sm-2 text-center hidden-xs">
                                        <img src="Images/Receipt.png" width="42" height="50" />
                                    </div>
                                    <div class="col-sm-10">
                                        <div class="courier" style="margin-bottom: 15px;">
                                            Enter the following information to download your Passport Payment Receipt Status
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
                                            <div class="col-sm-4 col-sm-offset-4">
                                                <asp:Button ID="cmd" CssClass="btn btn-success btn-block" runat="server" Text="Check"
                                                    OnClick="cmd_Click" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>
                            <asp:Panel runat="server" CssClass="panel" ID="PanelResult" Visible="false">
                       
                                <div class="col-md-7">
                               
                                        <asp:DetailsView ID="DetailsView1" runat="server" BackColor="White" CssClass="table table-striped table-bordered table-condensed table-hover"
                                            HeaderText="" BorderColor="white" BorderStyle="None" ForeColor="Black" GridLines="None"
                                            AutoGenerateRows="False" DataSourceID="SqlDataSource1">
                                            <Fields>
                                                <asp:TemplateField HeaderText="" ShowHeader="false">
                                                    <ItemTemplate>
                                                        <div class="row">
                                                            <label class="col-sm-3 control-label">
                                                                Ref ID</label>
                                                            <div class="col-sm-9">
                                                                <div class="bold form-control-static">
                                                                    <%# Eval("RefID")%>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Name" ShowHeader="false">
                                                    <ItemTemplate>
                                                        <div class="row">
                                                            <label class="col-sm-3 control-label">
                                                                Status</label>
                                                            <div class="col-sm-9">
                                                                <div class="form-control-static">
                                                                    <%# Eval("StatusName")%>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Fields>
                                            <EmptyDataTemplate>
                                                Referance no. not Found.
                                            </EmptyDataTemplate>
                                        </asp:DetailsView>
                                    </div>
                             <%--   </div>--%>
                                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                    SelectCommand="SELECT p.RefID,s.Status StatusName FROM    [PaymentsDB].[dbo].[v_Payments_Passport_Total_Details] AS P
                                     LEFT JOIN dbo.Status_Passport AS S ON P.Status = S.StatusID
                                    WHERE   RefID = @RefID">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="txtRefID" Name="RefID" PropertyName="Text" />
                                    </SelectParameters>
                                </asp:SqlDataSource>
                                <div style="clear:left"></div>
                             <%-- <div class="row">--%>
                                <div class="table table-responsive">
                                  
                                    <asp:GridView ID="GridView_CheckPayment_Log" runat="server" AutoGenerateColumns="False"
                                        HeaderStyle-HorizontalAlign="Center" DataKeyNames="ID" DataSourceID="SqlDataSource_CheckPayment_Log"
                                        ForeColor="Black" CssClass="table table-striped table-bordered table-condensed table-responsive table-hover">
                                        <AlternatingRowStyle />
                                        <Columns>
                                            <asp:BoundField DataField="SL" HeaderText="#" SortExpression="SL" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="Reasons" HeaderText="Reasons" SortExpression="Reasons" />
                                            <asp:BoundField DataField="EID" HeaderText="EID" SortExpression="EID" ItemStyle-HorizontalAlign="Center" />
                                            <asp:BoundField DataField="PassportEnrolmentDate" HeaderText="Enrolment Date" SortExpression="PassportEnrolmentDate"
                                                DataFormatString="{0:dd/MM/yyyy}" ItemStyle-HorizontalAlign="Center" Visible="false" />
                                            <asp:BoundField DataField="Msg" HeaderText="Response" SortExpression="Msg" ItemStyle-HorizontalAlign="Center"
                                                Visible="false" />
                                            <asp:TemplateField HeaderText="Enrolment Date" SortExpression="DT">
                                                <ItemTemplate>
                                                    <div title='<%# Eval("DT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                                        <%# Common.ToRecentDateTime(Eval("DT"))%>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                                <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="About" SortExpression="DT">
                                                <ItemTemplate>
                                                    <div class='time-small'>
                                                        <time class='timeago' datetime='<%# Eval("DT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                    </div>
                                                </ItemTemplate>
                                                <ItemStyle HorizontalAlign="Center" />
                                            </asp:TemplateField>
                                        </Columns>
                                        <FooterStyle BackColor="#CCCC99" />
                                        <HeaderStyle Font-Bold="True" />
                                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                        <RowStyle />
                                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                        <SortedAscendingCellStyle BackColor="#FBFBF2" />
                                        <SortedAscendingHeaderStyle BackColor="#848384" />
                                        <SortedDescendingCellStyle BackColor="#EAEAD3" />
                                        <SortedDescendingHeaderStyle BackColor="#575357" />
                                      <%--  <EmptyDataTemplate>
                                            No Data Found.
                                        </EmptyDataTemplate>--%>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource_CheckPayment_Log" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Passport_CheckPayment_Log" SelectCommandType="StoredProcedure">
                                        <SelectParameters>
                                            <%--<asp:QueryStringParameter Name="RefID" QueryStringField="refid" Type="String" />--%>
                                            <asp:ControlParameter ControlID="txtRefID" Name="RefID" PropertyName="Text" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </div>
                              <%--  </div>--%>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-4">
                                        <asp:Button ID="btnCheckAgain" CssClass="btn btn-success btn-block" runat="server"
                                            Text="Check Again" OnClick="btnCheckAgain_Click" />
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
