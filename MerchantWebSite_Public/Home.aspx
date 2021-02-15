<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="Home.aspx.cs" Inherits="ServiceCube.Home" %>

<%@ Register Src="UserControl.ascx" TagName="UserControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
    <%--<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc2" %>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <%--<uc2:AKControl ID="AKControl1" runat="server" />--%>
    <uc1:UserControl ID="UserControl1" runat="server" />
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
    <div class="row">
        <div class="col-sm-4">

            <%--     <asp:HyperLink ID="lblImage" runat="server" Target="_blank" ToolTip="Visit Merchant Site"></asp:HyperLink>
                    <br />
                    <asp:HyperLink ID="lblMarchentName1" Target="_blank" runat="server" Text="Label"
                        Style="font-weight: bold; color: Black; font-size: 85%" ToolTip="Visit Marchent Site"></asp:HyperLink>--%>

            <div>

                <asp:GridView ID="grdvPayment" runat="server" AllowPaging="true" CssClass="" AutoGenerateColumns="False"
                    BackColor="White" BorderStyle="None" BorderWidth="1px" ShowHeader="false" Width="100%"
                    DataSourceID="SqlDataSource_Logo" PageSize="10" AllowSorting="true" BorderColor="Silver"
                    CellPadding="4" ForeColor="Black" GridLines="Horizontal" PagerSettings-Mode="NumericFirstLast"
                    PagerSettings-Position="Bottom" PagerSettings-PageButtonCount="30">
                    <AlternatingRowStyle />
                    <Columns>
                        <asp:TemplateField HeaderText="Status" SortExpression="Status">
                            <ItemTemplate>
                                <div>
                                <img src='<%# string.Format("https://ibanking.tblbd.com/Checkout/Images/Marchent/{0}",Eval("MarchentLogoURL"))%>' style="max-width:80px;max-height:80px" border="0" />
                                    </div>
                                <%--</br>--%>     
                                <div style="max-width:180px;">        
                                 <asp:HyperLink ID="lblMarchentName1" Target="_blank" runat="server" Text='<%# Eval("MarchentName")%>' NavigateUrl='<%# Eval("MarchentCompanyURL")%>'
                                     Style="font-weight: bold; color: Black; font-size: 85%" ToolTip="Visit Marchent Site"></asp:HyperLink>
                                    </div>     
                            </ItemTemplate>



                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>

                         <asp:TemplateField HeaderText="Status" SortExpression="Status">
                            <ItemTemplate>
                                <%# Eval("MarchentID") %>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center" Font-Bold="true" />
                        </asp:TemplateField>




                    </Columns>
                    <EmptyDataTemplate>
                       <img src="Images/warning.png" width="32" height="32" alt="Warning    " />
                        <p>Sorry, no merchant is tagged in your profile. Please contact with admin.</p>
                    </EmptyDataTemplate>
                    <EmptyDataRowStyle HorizontalAlign="Center" />
                    
                    <RowStyle  HorizontalAlign="Center" VerticalAlign="Top" />
                    <PagerStyle CssClass="PagerStyle1" />

                </asp:GridView>


            </div>

            <asp:SqlDataSource ID="SqlDataSource_Logo" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                SelectCommand="s_Merchant_Icon_Public" SelectCommandType="StoredProcedure">

                <SelectParameters>
                    <asp:SessionParameter Name="UserID" SessionField="USERID" Type="String" />

                </SelectParameters>
            </asp:SqlDataSource>
        </div>
        <div class="col-sm-8">
            <p>Welcome to <%= ConfigurationManager.AppSettings["AppName"] %>. Thank you very mouch for being integrated with Trust Bank Payment Checkout.</p>
          <%--  <p class="bold"><%= ConfigurationManager.AppSettings["AppName"] %> will help you to-</p>
            <ul>
                <li>.</li>
                <li>Receive status and alerts to your inbox directly.</li>
                <li>Use Frequently Asked Questions (FAQ’s Tab) to solve common issues. (on development)</li>
                <li>To receive the latest Updates and News from the <%= ConfigurationManager.AppSettings["AppName"] %> Team.</li>
            </ul>--%>
            <p>For showing payment details, please go to <b> Checkout Payment ->> Payment List.</b></p>
            <p>Thank you for being with <%= ConfigurationManager.AppSettings["AppName"] %> Team.</p>

            <div style="margin-top:30px">

            <a href="MerchantReport.aspx" class="btn btn-default bold">Goto Payment List</a>
                </div>
              <div style="margin-top:20px">

            <a href="CrSummary.aspx" class="btn btn-default bold">Goto Payment Summary</a>
                </div>
        </div>
    </div>
            </ContentTemplate>
        </asp:UpdatePanel>
</asp:Content>
