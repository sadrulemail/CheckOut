<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="REB_Upload.aspx.cs" Inherits="REB_Upload" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%--<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>--%>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        function UploadError() {
            $('ctl00_cphMain_lblUploadStatus').html('File Uploading Error. Please try again.');
        }
        function UploadComplete(sender, args) {
            var filename = args.get_fileName();
            var contentType = args.get_contentType();
            var text = "Size of " + filename + " is " + args.get_length() + " bytes";
            if (contentType.length > 0) {
                text += " and content type is '" + contentType + "'.";
            }
            $('#ctl00_cphMain_lblUploadStatus').html('<b>' + filename + '</b> is successfully uploaded.');
            $('#UploadBtn').show('slow');
        }

        function AsyncFileUpload1_StartUpload(sender, args) {
            var filename = args.get_fileName();
            var ext = filename.substring(filename.lastIndexOf(".") + 1);
            if (ext.toLowerCase() == 'zip' || ext.toLowerCase() == 'csv') {
                $('#ctl00_cphMain_lblUploadStatus').html("<b>" + args.get_fileName() + "</b> is uploading...");
            }
            else {
                $('#UploadBtn').hide('Slow');
                $('#ctl00_cphMain_lblUploadStatus').html("Only <b>ZIP & CSV</b> files can be uploaded.");
                throw {
                    name: "Invalid File Type",
                    level: "Error",
                    message: "Only ZIP & CSV files can be uploaded. ",
                    htmlMessage: "Only <b>ZIP & CSV</b> files can be uploaded. "
                }
                return false;
            }
        }
    </script>
    <style type="text/css">
        .Border1
        {
            background-color: #FFFFB5;
            padding: 10px;
            border: solid 1px green;
            width: 200px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
    Upload REB Payment Data
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Label ID="lblError" runat="server" Text=""></asp:Label>
            <asp:HiddenField ID="HidPageID" runat="server" Value="" />
            <asp:HiddenField ID="UploadTempFile" runat="server" Value="" />
            <asp:HiddenField ID="UploadTempFolder" runat="server" Value="" />
            <asp:TabContainer runat="server" ID="tabContainer" CssClass="NewsTab" OnDemand="true"
                ActiveTabIndex="0" Width="900px" OnActiveTabChanged="tabContainer_ActiveTabChanged">
                <asp:TabPanel runat="server" ID="tab1">
                    <HeaderTemplate>
                        REB Upload</HeaderTemplate>
                    <ContentTemplate>
                        <asp:Button ID="cmdClearData" runat="server" Text="Clear Data" OnClick="cmdClearData_Click"
                            Visible="false" />
                        <br />
                        <asp:Panel ID="Panel1" runat="server">
                            <div class="Panel1 ui-corner-all" style="width: 600px; padding: 15px">
                                <b>Select zip file (containing csv):</b>
                                <asp:AsyncFileUpload ToolTip="Select zip file (containing csv)" data-toggle="tooltip"
                                    ID="FileUpload1" runat="server" Width="300px" Style="margin: 10px" OnUploadedComplete="FileUpload1_UploadedComplete"
                                    ThrobberID="myThrobber" OnClientUploadComplete="UploadComplete" OnClientUploadError="UploadError"
                                    OnClientUploadStarted="AsyncFileUpload1_StartUpload" OnUploadedFileError="FileUpload1_UploadedFileError"
                                    UploaderStyle="Traditional" CssClass="AsyncFileUploadField" />
                                <asp:Image ImageUrl="~/Images/ajax-loader.gif" ID="myThrobber" runat="server" />
                                <br />
                                <asp:Label ID="lblUploadStatus" runat="server" Style="font-size: small;" Text="">
                
                                </asp:Label>
                              </div>
                            <div style="display: none; padding-top: 10px" id="UploadBtn">
                                <asp:Button ID="cmdCheck" runat="server" Text="View Files Data" Width="200px" Font-Bold="true"
                                    Height="30px" OnClick="cmdCheck_Click" />
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="Panel2" runat="server">
                            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White"
                                AllowSorting="True" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                                CellPadding="4" DataKeyNames="SL" CssClass="Grid" DataSourceID="SqlDataSource1"
                                Style="font-size: small" AllowPaging="True" ForeColor="Black" GridLines="Vertical">
                                <PagerSettings PageButtonCount="30" Position="TopAndBottom" />
                                <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center"/>
                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" ReadOnly="True" SortExpression="SL" />
                                    <asp:BoundField DataField="SMSBillNo" HeaderText="SMS Bill No" ReadOnly="True" SortExpression="SMSBillNo" />
                                    <asp:BoundField DataField="Book" HeaderText="Book" SortExpression="Book" />
                                    <asp:BoundField DataField="SMSAccountNo" HeaderText="SMS Account No" SortExpression="SMSAccountNo" />
                                    <asp:BoundField DataField="BillMonth" HeaderText="Bill Month" SortExpression="BillMonth" />
                                    <asp:BoundField DataField="BillYear" HeaderText="Bill Year" SortExpression="BillYear" />
                                    <asp:BoundField DataField="BilledDate" HeaderText="Bill Date" SortExpression="BilledDate"
                                        DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="PayDate" HeaderText="Payment Date" SortExpression="PayDate"
                                        DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="Amount" HeaderText="Amount" SortExpression="Amount" ItemStyle-HorizontalAlign="Right"/>
                                    <asp:BoundField DataField="PayDateWithLPC" HeaderText="Pay Date<br>(with LPC)" HtmlEncode="false" SortExpression="PayDateWithLPC"
                                        DataFormatString="{0:dd/MM/yyyy}" />
                                    <asp:BoundField DataField="AmountWithLPC" HeaderText="Amount<br>(with LPC)" HtmlEncode="false" SortExpression="AmountWithLPC" ItemStyle-HorizontalAlign="Right"/>
                                </Columns>
                                <FooterStyle BackColor="#CCCC99" />
                                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                <AlternatingRowStyle BackColor="White" />
                                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                                <SortedAscendingHeaderStyle BackColor="#848384" />
                                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                                <SortedDescendingHeaderStyle BackColor="#575357" />
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                SelectCommand="SELECT * FROM [Temp_REB] where SessionID=@SessionID">
                                <SelectParameters>
                                    <asp:SessionParameter Name="SessionID" SessionField="SessionID" Type="String" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <br />
                            <asp:Label ID="lblTotalRecord" runat="server" Text="Label"></asp:Label>&nbsp;
                            <asp:Label ID="lblAmount" runat="server" Text="Label"></asp:Label>&nbsp;
                            <asp:Label ID="lblAmountWithLPC" runat="server" Text="Label"></asp:Label>
                            <br />
                            <br />
                            <div>
                                <asp:Label ID="lblDuplicateCount" runat="server" Text="" Visible="false"></asp:Label>&nbsp;
                                <asp:CheckBox ID="chkOverride" runat="server" Text="Override Existing Unpaid Bill"
                                    Visible="false" Checked="false" />&nbsp;
                                <asp:Label ID="lblPaidCount" runat="server" Text="" Visible="false"></asp:Label>&nbsp;
                                <asp:CheckBox ID="chkPaid" runat="server" Text="Paid Bill" Visible="false" Checked="false"
                                    Enabled="false" />&nbsp;
                            </div>
                            <asp:Button ID="cmdUpdate" runat="server" Text="Save REB Data" Width="200px" Font-Bold="true"
                                Height="30px" OnClick="cmdUpdate_Click" />
                            <asp:ConfirmButtonExtender ID="cmdUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Are you sure?"
                                Enabled="True" TargetControlID="cmdUpdate">
                            </asp:ConfirmButtonExtender>
                            <br />
                            <br />
                            <asp:Label ID="lblStatus" runat="server"></asp:Label>
                            <br />
                            <br />
                        </asp:Panel>
                    </ContentTemplate>
                </asp:TabPanel>
                <asp:TabPanel runat="server" ID="tab2">
                    <HeaderTemplate>
                        Upload History</HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <div class="Panel1">
                                        <table>
                                            <tr>
                                                <td>
                                                    <b>Date:</b> from
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDateFrom" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"></asp:TextBox>
                                                </td>
                                                <td>
                                                    to
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtDateTo" CssClass="Date" runat="server" Width="85px" AutoPostBack="true"></asp:TextBox>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="dboBranch" runat="server" CausesValidation="false" AutoPostBack="true"
                                                        AppendDataBoundItems="true" DataSourceID="SqlDataSource111" DataTextField="BranchName"
                                                        DataValueField="BID">
                                                        <%--<asp:ListItem Value="*" Text="All"></asp:ListItem>
                                                <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                                <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>--%>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </td>
                                <td>
                                    <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                                        ToolTip="Previous Day" data-toggle='tooltip' CssClass="button-round"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                                    <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                        data-toggle='tooltip' CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                                </td>
                            </tr>
                        </table>
                        
                        <asp:SqlDataSource ID="SqlDataSource111" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                            SelectCommand="SELECT BID,BranchName FROM [Branch] WHERE OrgID=3" SelectCommandType="Text">
                        </asp:SqlDataSource>
                        <asp:GridView ID="GridView2" runat="server" AllowPaging="True" CssClass="Grid" AllowSorting="True"
                            AutoGenerateColumns="False" BackColor="White" PagerSettings-Position="TopAndBottom"
                            PagerSettings-Mode="NumericFirstLast" BorderColor="#DEDFDE" BorderStyle="Solid"
                            BorderWidth="1px" CellPadding="4" PageSize="20" DataKeyNames="ID" DataSourceID="SqlDataSourceDataUploadLog"
                            ForeColor="Black" Style="font-size: small" EnableSortingAndPagingCallbacks="True">
                            <PagerSettings Mode="NumericFirstLast" Position="TopAndBottom" />
                            <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" />
                            <Columns>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <a data-toggle="tooltip" href='REB_ShowBatch.aspx?batch=<%# Eval("Batch") %>&keycode=<%# Eval("keycode") %>'
                                            title="View Items" target="_blank">
                                            <img src='Images/open1.png' width='16' height='16' border='0' />
                                        </a>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <%-- <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                SortExpression="ID" />--%>
                                <%-- <asp:BoundField DataField="Total_Records" HeaderText="Total Records" InsertVisible="False" ReadOnly="True"
                                SortExpression="Total_Records" />--%>
                                <asp:BoundField DataField="Batch" HeaderText="Batch" InsertVisible="False" ReadOnly="True"
                                    SortExpression="Batch" />
                                <asp:TemplateField HeaderText="Uploaded On" SortExpression="InserDT" ItemStyle-Wrap="false"
                                    ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <span data-toggle="tooltip" title='<%# Eval("InserDT", "{0:dddd, <br>d MMMM, yyyy <br>h:mm:ss tt}")%>'>
                                            <%# TrustControl1.ToRecentDateTime(Eval("InserDT"))%></span></ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="About" SortExpression="InserDT" ItemStyle-Wrap="false"
                                    ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <div class='time-small'>
                                            <time class='timeago' datetime='<%# TrustControl1.ToTimeAgo((DateTime)Eval("InserDT"))%>'></time>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="By Emp" SortExpression="InsertBy">
                                    <ItemTemplate>
                                        <%--<uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />--%>
                                        <%# Eval("InsertBy") %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Total_Records" HeaderText="Total Records" SortExpression="Total_Records"
                                    DataFormatString="{0:N0}" />
                            </Columns>
                            <FooterStyle BackColor="#CCCC99" />
                            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle1" />
                            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                            <AlternatingRowStyle BackColor="White" />
                            <EmptyDataTemplate>
                                No Record(s) Found</EmptyDataTemplate>
                        </asp:GridView>
                        <asp:SqlDataSource ID="SqlDataSourceDataUploadLog" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                            SelectCommand="s_REB_Upload_Log" SelectCommandType="StoredProcedure">
                            <SelectParameters>
                                <asp:SessionParameter Name="EmpID" SessionField="USERNAME" Type="String" />
                                <asp:ControlParameter ControlID="txtDateFrom" Type="DateTime" Name="DateFrom" DefaultValue="1/1/1900" />
                                <asp:ControlParameter ControlID="txtDateTo" Type="DateTime" Name="DateTo" DefaultValue="1/1/1900" />
                                <%-- <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="InsertDateTo" DefaultValue="1/1/1900" />--%>
                            </SelectParameters>
                        </asp:SqlDataSource>
                        
                    </ContentTemplate>
                </asp:TabPanel>
            </asp:TabContainer>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground">
            </div>
            <asp:Image ID="WaitImage1" runat="server" alt="" ImageUrl="~/Images/processing.gif"
                CssClass="LoadingImage" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="WaitImage1"
        UseAnimation="false" VerticalSide="Middle">
    </asp:AlwaysVisibleControlExtender>
</asp:Content>
