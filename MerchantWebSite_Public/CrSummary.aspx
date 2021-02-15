<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="CrSummary.aspx.cs" Inherits="ServiceCube.CrSummary" %>

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
                    <asp:DropDownList ID="dblStatus" DataSourceID="SqlDataSourceStatus" runat="server"  CausesValidation="false" DataTextField="Status" DataValueField="StatusID" AutoPostBack="false">
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

           <asp:DetailsView ID="DetailsView1" runat="server" BackColor="White" CssClass="Grid contentGrid"
                                ForeColor="Black" GridLines="Vertical" AutoGenerateRows="False" 
                                DataSourceID="SqlDataSource_Summary" CellPadding="4" >
                                <Fields>
                                 
                                    <asp:TemplateField HeaderText="Marchent Name" HeaderStyle-Wrap="false">
                                        <ItemTemplate>
                                            <%# Eval("MarchentName")%>
                                        </ItemTemplate>
                                           <ItemStyle Font-Bold="true" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Total Amount">
                                        <ItemTemplate>
                                            <%# Eval("Amount","{0:N2}")%>
                                        </ItemTemplate>
                                          <ItemStyle Font-Bold="true" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Fees">
                                        <ItemTemplate>
                                            <%# Eval("Fees","{0:N2}")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Vat Amount">
                                        <ItemTemplate>
                                            <%# Eval("VatAmount","{0:N2}")%>
                                        </ItemTemplate>
                                     
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Service Charge">
                                        <ItemTemplate>
                                            <%# Eval("ServiceCharge","{0:N2}")%>
                                        </ItemTemplate>
                                     
                                    </asp:TemplateField>
                                      <asp:TemplateField HeaderText="Count">
                                        <ItemTemplate>
                                            <%# Eval("TotalNo","{0:N0}")%>
                                        </ItemTemplate>
                                     
                                    </asp:TemplateField>
                                <%--    <asp:TemplateField HeaderText="Interest Amount">
                                        <ItemTemplate>
                                            <%# Eval("InterestAmount")%>
                                        </ItemTemplate>
                                    </asp:TemplateField>--%>

                                 
                                </Fields>
                                <AlternatingRowStyle BackColor="White" />
                                <EditRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                <EmptyDataTemplate>
                                    No Data Found.
                                </EmptyDataTemplate>
                                <EmptyDataRowStyle Height="100px" HorizontalAlign="Center" />
                                <FooterStyle BackColor="#CCCC99" />
                                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                            </asp:DetailsView>
        


    </div>
             <asp:SqlDataSource ID="SqlDataSource_Summary" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
            SelectCommand="s_Checkout_Summary_Public" SelectCommandType="StoredProcedure" OnSelected="SqlDataSource_Summary_Selected">

            <SelectParameters>
              
                <asp:ControlParameter ControlID="txtDateFrom" DbType="Date" Name="DateFrom"
                    DefaultValue="1/1/1900" />
                <asp:ControlParameter ControlID="txtDateTo" DbType="Date" Name="DateTo" DefaultValue="1/1/1900" />
            
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
                        <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="VatVisible" 
                            Type="Boolean" />
                         <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="ServiceChargeVisible" 
                            Type="Boolean" />
                         <asp:Parameter DefaultValue="true" Direction="InputOutput" Name="TotalAmountVisible" 
                            Type="Boolean" />
            </SelectParameters>
        </asp:SqlDataSource>
  <%--  <div style="padding-top: 10px">
        <div>
            <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
        </div>
           <div>
                    <asp:Button ID="cmdExport" runat="server" Text="Export as XLSX"
                        Width="150px" />
                </div>
     

    </div>--%>
            </ContentTemplate>
       <%-- <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
        </Triggers>--%>
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
