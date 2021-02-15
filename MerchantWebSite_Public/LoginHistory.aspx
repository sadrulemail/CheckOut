<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="LoginHistory.aspx.cs" Inherits="ServiceCube.LoginHistory" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="UserControl.ascx" TagName="UserControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
    Login History
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <uc1:UserControl ID="UserControl1" runat="server" />
       <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        <div class="box">
            <div class="box-body">
            <div class="form-inline">
                
                <div class="form-group">
                    <label>Login Date</label>
                    <asp:TextBox ID="txtDateFrom" runat="server" Width="75px" AutoPostBack="false" Watermark="dd/mm/yyyy"
                        CssClass="Date"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>to</label>
                    <asp:TextBox ID="txtDateTo" runat="server" Width="75px" AutoPostBack="false" Watermark="dd/mm/yyyy"
                        CssClass="Date"></asp:TextBox>
                </div>
               
               
         <div class="form-group">
                <asp:Button ID="cmdOK" runat="server" CssClass="btn" Text="Show" />
             </div>
            </div>
        </div>

            </div>
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" EnableViewState="false"
                DataSourceID="SqlDataSource1" GridLines="None" PageSize="30"
                CssClass="table table-responsive table-condensed table-bordered table-hover table-striped search-result-grid"
                AllowPaging="True" AllowSorting="True" PagerSettings-Mode="NumericFirstLast" PagerSettings-Position="TopAndBottom">

                <Columns>
                                

                    <asp:TemplateField HeaderText="Browser" SortExpression="Browser">
                        <ItemTemplate>
                        
                            <div><%# Eval("Browser")%></div>
                        </ItemTemplate>

                        <ItemStyle HorizontalAlign="Left" CssClass="hidden-sm hidden-xs" />
                        <HeaderStyle CssClass="hidden-sm hidden-xs" />
                    </asp:TemplateField>
                     <asp:TemplateField HeaderText="IP" SortExpression="IP">
                        <ItemTemplate>
                        
                            <div><%# Eval("IP")%></div>
                        </ItemTemplate>

                        <ItemStyle HorizontalAlign="Left" CssClass="hidden-sm hidden-xs" />
                        <HeaderStyle CssClass="hidden-sm hidden-xs" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Login Date" SortExpression="DT">
                        <ItemTemplate>
                            <div title='<%# Eval("DT","{0:dddd \ndd, MMMM, yyyy \nh:mm:ss tt}") %>'>
                                <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                <div class="">
                                    <time class="timeago time-small-gray" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                </div>
                            </div>
                        </ItemTemplate>
                        <ItemStyle CssClass="nowrap hidden-xs" />
                        <HeaderStyle CssClass="hidden-xs" />
                    </asp:TemplateField>
                                                           
                </Columns>
                <FooterStyle BackColor="#CCCC99" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Center" CssClass="PagerStyle2" />
                <RowStyle />
               <%-- <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />--%>
            </asp:GridView>
            <div class="row">
                <asp:Literal ID="lblStatus" runat="server"></asp:Literal>
            </div>
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:WebDBConnectionString %>" SelectCommand="s_Login_Log" SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter Name="LoginID" SessionField="USERID" Type="Int32" />
                    <asp:ControlParameter Name="DateFrom" ControlID="txtDateFrom" PropertyName="Text" Type="DateTime" />
                    <asp:ControlParameter Name="DateTo" ControlID="txtDateTo" PropertyName="Text" Type="DateTime" />
                    <asp:Parameter Name="AppID" DefaultValue="3007" />
                </SelectParameters>
            </asp:SqlDataSource>
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
