<%@ Page Title="Titas Payment Report" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="Titas_Report.aspx.cs" Inherits="Titas_Report" Culture="en-NZ" UICulture="en-NZ" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        html, body {
            background-color: #eee;
        }
        /*.Grid thead tr{
            background-image:none;
            padding:2px 3px;
            text-align:center;
            white-space:nowrap;
            background-color:darkslategray;
            border:1px solid darkslategray;
            color:white;
            font-weight:bold;
        }
        .Grid td{
            padding:2px 3px;
            font-stretch:condensed !important;
        }*/
        .footer-row {
            font-size: 120%;
            background-color: antiquewhite;
        }

        .red-back {
            background-color: red !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="hidden-print">
        Titas Payment Report
    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div style="display: inline-block" class="hidden-print">
                <table>
                    <tr>
                        <td class="Panel1">
                            <table>
                                <tr>
                                    <td>
                                        <asp:TextBox ID="txtRefID" runat="server" Watermark="ref no/order id/mobile" MaxLength="50"
                                            Width="150px"></asp:TextBox>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtTrnsID" runat="server" Watermark="payment id" MaxLength="50"
                                            Width="145px"></asp:TextBox>
                                    </td>

                                    <td>
                                        <b>Date:</b>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateFrom_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <td>to
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="true" Watermark="dd/mm/yyyy"
                                            OnTextChanged="txtDateTo_TextChanged" CssClass="Date"></asp:TextBox>
                                    </td>
                                    <%--<td>
                                        <b>Type:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dblType" runat="server" CausesValidation="false" AutoPostBack="true">
                                            <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                            <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                            <asp:ListItem Value="MB_OFF" Text="Mobile Banking(Off Line)"></asp:ListItem>
                                            <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>--%>



                                    <td>
                                        <b>Status:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="dblStatus" runat="server" CausesValidation="false" AutoPostBack="true" OnSelectedIndexChanged="dblStatus_SelectedIndexChanged">
                                            <asp:ListItem Value="1" Text="PAID"></asp:ListItem>
                                            <asp:ListItem Value="9" Text="CANCELED"></asp:ListItem>


                                        </asp:DropDownList>

                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td>
                                        <b>Branch:</b>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                            DataSourceID="SqlDataSourceBranch" DataTextField="BranchName" DataValueField="BranchID"
                                            OnDataBound="cboBranch_DataBound" OnSelectedIndexChanged="cboBranch_SelectedIndexChanged">
                                            <asp:ListItem Value="-1">All Branch</asp:ListItem>
                                            <asp:ListItem Value="1">Head Office</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                            SelectCommand="                                           
                                            SELECT [BranchID], [BranchName] FROM [ViewBranchOnly] with (nolock) order by BranchName"></asp:SqlDataSource>
                                    </td>
                                    <td class="bold">Zone:</td>
                                    <td>
                                        <asp:DropDownList ID="cboZones" runat="server" AppendDataBoundItems="True" AutoPostBack="true"
                                            DataSourceID="SqlDataSourceTitasZone" DataTextField="Name" DataValueField="ID" 
                                            OnSelectedIndexChanged="cboZones_SelectedIndexChanged">
                                            <asp:ListItem Value="-1">All Zones</asp:ListItem>
                                        </asp:DropDownList>
                                        <asp:SqlDataSource ID="SqlDataSourceTitasZone" runat="server" 
                                            ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                            SelectCommand="s_TitasZones" SelectCommandType="StoredProcedure">
                                            <SelectParameters>
                                                <asp:ControlParameter ControlID="dboType" Name="isMetered" PropertyName="SelectedValue"
                                                    Type="Boolean" />
                                            </SelectParameters>
                                        </asp:SqlDataSource>
                                    </td>

                                    <td style="padding-left: 10px">
                                        <asp:Button ID="cmdOK" runat="server" Text="Show" OnClick="cmdOK_Click" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td>
                            <asp:LinkButton ID="cmdPreviousDay" runat="server" OnClick="cmdPreviousDay_Click"
                                ToolTip="Previous Day" CssClass="button-round"><img src="Images/Previous.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                            <asp:LinkButton ID="cmdNextDay" runat="server" OnClick="cmdNextDay_Click" ToolTip="Next Day"
                                CssClass="button-round"><img src="Images/Next.gif" width="32px" height="32px" border="0" /></asp:LinkButton>
                        </td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td>
                            <asp:RadioButtonList ID="dboType" runat="server" AutoPostBack="true" EnableViewState="true"
                                RepeatDirection="Horizontal" ui="buttonset" OnSelectedIndexChanged="dboType_SelectedIndexChanged">
                                <asp:ListItem Value="false" Selected="True" Text="NON-METERED"></asp:ListItem>
                                <asp:ListItem Value="true" Text="METERED"></asp:ListItem>
                            </asp:RadioButtonList>

                            <asp:RadioButtonList ID="dboReportType" runat="server" AutoPostBack="true" EnableViewState="true"
                                RepeatDirection="Horizontal" ui="buttonset" OnSelectedIndexChanged="dboReportType_SelectedIndexChanged">

                                <asp:ListItem Value="2" Selected="True" Text="Zone wise Details"></asp:ListItem>
                                <asp:ListItem Value="6" Text="Zone wise Summary"></asp:ListItem>
                                <asp:ListItem Value="4" Text="Branch Collection Summary"></asp:ListItem>
                                <asp:ListItem Value="3" Text="Branch wise Summary"></asp:ListItem>

                                <asp:ListItem Value="5" Text="Date wise Summary"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Branch wise Details"></asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="padding-bottom: 7px; vertical-align: bottom"><a onclick="window.print()" style="cursor: pointer" class="bold" title="Print...">
                            <img alt="" src="Images/printer-icon.png" width="24" height="24" /></a></td>
                    </tr>
                </table>
            </div>
            <div style="padding-top: 10px" class="hidden-print">
                <div>
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </div>

            </div>
            <asp:Panel runat="server" ID="PanelPrint" Visible="false" BackColor="White" CssClass="report-panel">
                <table width="100%">
                    <tr>
                        <td valign="top">
                            <img src="Images/tbl_logo.png" height="32" alt="" /></td>
                        <td align="center" valign="top">
                            <h3 class="center" style="font-stretch: condensed">
                                <asp:Literal ID="litReportTitle" runat="server"></asp:Literal></h3>
                            <div class="center">
                                <asp:Literal ID="litReportTitle2" runat="server"></asp:Literal>
                            </div>
                        </td>
                        <td align="right" valign="top">
                            <img src="Images/titaslogo.jpg" width="55" height="55" alt="" /></td>
                    </tr>
                </table>
                <div id="report-body">
                    <asp:Literal ID="litReport" runat="server" Text="No Data Found."></asp:Literal>
                </div>
                <div id="report-footer"></div>
            </asp:Panel>


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
