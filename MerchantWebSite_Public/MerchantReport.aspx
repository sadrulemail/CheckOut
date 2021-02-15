<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="MerchantReport.aspx.cs" Inherits="ServiceCube.MerchantReport" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="UserControl.ascx" TagName="UserControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
    <%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc2" %>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <uc2:AKControl ID="AKControl1" runat="server" />
    <uc1:UserControl ID="UserControl1" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="box">
                <div class="box-body">
                    <div class="form-inline">
                        <div class="form-group">
                            <label>Ref No.</label>
                            <asp:TextBox ID="txtRefID" runat="server" Watermark="Ref No." MaxLength="14" CssClass="form-control"
                                Width="180px"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Order ID</label>
                            <asp:TextBox ID="txtOrderID" runat="server" Watermark="Order No." MaxLength="50" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Date</label>
                            <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="false" Watermark="dd/mm/yyyy"
                                CssClass="Date"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>to</label>
                            <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="false" Watermark="dd/mm/yyyy"
                                CssClass="Date"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>Merchant</label>
                            <asp:DropDownList ID="ddlMerchant" runat="server" AppendDataBoundItems="True"
                                CssClass="form-control" DataSourceID="DataSourceMerchantPermission"
                                DataTextField="MerchantID" DataValueField="MerchantID" AutoPostBack="true"
                                CausesValidation="false" OnSelectedIndexChanged="ddlMerchant_SelectedIndexChanged">
                            </asp:DropDownList>
                            <asp:SqlDataSource ID="DataSourceMerchantPermission" runat="server"
                                ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                SelectCommand="s_Checkout_Merchant_Permission" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter Name="UserID" SessionField="USERID" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                        </div>
                        <div class="form-group">
                            <label>Payment Status</label>
                            <asp:DropDownList ID="dblStatus" DataSourceID="SqlDataSourceStatus" runat="server" CausesValidation="false" DataTextField="Status" DataValueField="StatusID" AutoPostBack="false">
                                <%--  <asp:ListItem Value="-1" AppendDataBoundItems="false" Text="All"></asp:ListItem>--%>
                            </asp:DropDownList>
                            <%--  <asp:SqlDataSource ID="SqlDataSourceStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                        SelectCommand="SELECT StatusID, Status FROM [PaymentsDB].[dbo].[Status_Checkout]"></asp:SqlDataSource>--%>

                            <asp:SqlDataSource ID="SqlDataSourceStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                SelectCommand="s_Pay_Status_Merchant_Wise" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:ControlParameter ControlID="ddlMerchant" PropertyName="SelectedValue" Name="MerchantID" />
                                </SelectParameters>

                            </asp:SqlDataSource>
                        </div>
                        <div class="form-group">
                            <label>Verified</label>
                            <asp:DropDownList ID="ddlVerified" runat="server" CausesValidation="false" AutoPostBack="true">
                                <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Used</label>
                            <asp:DropDownList ID="ddlUsed" runat="server" CausesValidation="false" AutoPostBack="true">
                                <asp:ListItem Value="-1" Text="All"></asp:ListItem>
                                <asp:ListItem Value="1" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="0" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="form-group">
                            <label>Channel Type</label>
                            <asp:DropDownList ID="dblType" runat="server" CausesValidation="false" AutoPostBack="true">
                                <asp:ListItem Value="*" Text="All"></asp:ListItem>
                                <asp:ListItem Value="MB" Text="Mobile Banking"></asp:ListItem>
                                <asp:ListItem Value="ITCL" Text="Card Online"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="cmdOK" runat="server" CssClass="btn" Text="Show" OnClick="cmdOK_Click" />

                    </div>
                </div>
            </div>

            <div>

                <asp:GridView ID="grdvPayment" runat="server" AllowPaging="True" CssClass="Grid" AutoGenerateColumns="False"
                    BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px"
                    DataSourceID="SqlDataSource_Payment" PageSize="10" AllowSorting="true"
                    CellPadding="4" DataKeyNames="RefID" ForeColor="Black" GridLines="Vertical" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="TopAndBottom" PagerSettings-PageButtonCount="30" OnDataBound="grdvPayment_DataBound">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" SortExpression="OrderID" />
                        <asp:BoundField DataField="RefID" HeaderText="Ref Id" SortExpression="RefID" />
                        <%--    <asp:BoundField DataField="FullName" HeaderText="Name" SortExpression="FullName" />--%>
                        <asp:TemplateField HeaderText="Name / Email" SortExpression="FullName">
                            <ItemTemplate>
                                <%# Eval("FullName","<div title='Name' style='font-weight:bold'>{0}</div>")%>
                                <%# Eval("Email","<div title='Email'>{0}</div>")%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="Amount" HeaderText="Total Amount" SortExpression="Amount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="Fees" HeaderText="Fees" SortExpression="Fees"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="VatAmount" HeaderText="Vat" SortExpression="VatAmount"
                            DataFormatString="{0:N2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="ServiceCharge" HeaderText="Service Charge"
                            ItemStyle-HorizontalAlign="Right" SortExpression="ServiceCharge" />

                        <asp:BoundField DataField="MarchentID" HeaderText="Merchant" SortExpression="MarchentID" />
                        <%--     <asp:BoundField DataField="FullName" HeaderText="Name" SortExpression="FullName" />--%>
                        <asp:BoundField DataField="Type" HeaderText="Pay Type" SortExpression="Type" />
                        <asp:TemplateField HeaderText="Trn Date" SortExpression="TrnDate">
                            <ItemTemplate>
                                <%# Eval("TrnDate","{0:dd/MM/yyyy}") %>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" Font-Bold="true" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Payment Date" SortExpression="PaidDT">
                            <ItemTemplate>
                                <div title='<%# Eval("PaidDT","{0:dddd, dd MMMM yyyy, h:mm:ss tt}") %>'>
                                    <%# AKControl1.ToRecentDateTime(Eval("PaidDT"))%>
                                    <div class='time-small'>
                                        <time class='timeago' datetime='<%# Eval("PaidDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <ItemStyle Wrap="false" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status" SortExpression="Status">
                            <ItemTemplate>

                                <%# Eval("icon").ToString() == "" ? Eval("StatusName") : "<img src='Images/" + Eval("icon") + "' title='" + Eval("StatusName") +"' width='20' />"%>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Verified" SortExpression="Verified">
                            <ItemTemplate>
                                <%# Eval("Verified").ToString() == "True" ? "<img src='Images/verified.png' title='Verified' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Used" SortExpression="Used">
                            <ItemTemplate>

                                <%# Eval("Used").ToString() == "True" ? "<img src='Images/verified.png' title='Used' width='20' />" : "" %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                    </Columns>
                    <EmptyDataTemplate>
                        No Payment Data Found
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle />
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                    <RowStyle BackColor="#F7F7DE" HorizontalAlign="Center" VerticalAlign="Top" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />


                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource_Payment" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                    SelectCommand="s_Checkout_Payment_View_Public" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Payment_Selected">

                    <SelectParameters>
                        <asp:ControlParameter ControlID="txtRefID" DbType="String" Name="RefID" DefaultValue="*" />
                        <asp:ControlParameter ControlID="txtOrderID" DbType="String" Name="OrderID" DefaultValue="*" />
                        <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom"
                            DefaultValue="1/1/1900" />
                        <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" DefaultValue="1/1/1900" />

                        <%--  <asp:ControlParameter ControlID="dblType" Name="Type" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />--%>
                        <asp:ControlParameter ControlID="dblStatus" Name="Status" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlUsed" Name="Used" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlVerified" Name="Verified" PropertyName="SelectedValue"
                            DefaultValue="-1" Type="Int32" />
                        <asp:ControlParameter ControlID="ddlMerchant" Name="MarchentType" PropertyName="SelectedValue"
                            Type="String" />
                        <asp:ControlParameter ControlID="dblType" Name="ChannelType" PropertyName="SelectedValue"
                            DefaultValue="*" Type="String" />
                        <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int16" />
                        <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="UsedVisible" 
                            Type="Boolean" />
                            <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="VerifiedVisible" 
                            Type="Boolean" />
                         <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="VatVisible" 
                            Type="Boolean" />
                         <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="ServiceChargeVisible" 
                            Type="Boolean" />
                         <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="TotalAmountVisible" 
                            Type="Boolean" />

                    </SelectParameters>
                </asp:SqlDataSource>

            </div>
            <div style="padding-top: 10px">
                <div>
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </div>
                <div>
                    <asp:Button ID="cmdExport" runat="server" Text="Export as XLSX" OnClick="cmdExport_Click"
                        Width="150px" />
                </div>
                <div>
                </div>

            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
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
