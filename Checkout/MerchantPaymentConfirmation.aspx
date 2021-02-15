<%@ Page Title="" Language="C#" MasterPageFile="~/MasterBootstrap.master" AutoEventWireup="true"
    CodeFile="MerchantPaymentConfirmation.aspx.cs" Inherits="MerchantPaymentConfirmation" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>Merchant Payment Confirmation</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Merchant Payment Confirmation
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <div style="padding: 30px;" class="row col-md-12">
        <%--  <div class="Panel1" style="padding: 10px 30px; display: inline-block">
            <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
        </div>--%>
        <div>
            <asp:Label ID="lblBank" runat="server" Text="" CssClass="bold"></asp:Label>
             <asp:HiddenField ID="hidOrderID" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidRefID" runat="server" Value="" EnableViewState="true" />
            <asp:HiddenField ID="hidMerchantID" runat="server" Value="" EnableViewState="true" />
        </div>

        <div class="row">
            <div class="col-sm-2 text-center">
                <asp:HyperLink ID="lblImage" runat="server" Target="_blank" ToolTip="Visit Merchant Site"></asp:HyperLink>
                <br />
                <asp:HyperLink ID="lblMarchentName1" Target="_blank" runat="server" Text="Label"
                    Style="font-weight: bold; color: Black; font-size: 85%" ToolTip="Visit Marchent Site"></asp:HyperLink>
            </div>
            <hr class="visible-xs" />
            <div class="col-sm-8 ">

                <div class='panel <%= getTitleClass() %>'>
                    <div class="panel-heading">
                        Payment Info
                    </div>
                    <asp:DetailsView ID="DetailsViewPayStatus" runat="server" BackColor="White" CssClass="table table-condensed table-hover"
                        HeaderText="" BorderColor="white" BorderStyle="None" ForeColor="Black" GridLines="None"
                        AutoGenerateRows="False" DataSourceID="SqlDataPayStatus" OnDataBound="DetailsViewPayStatus_DataBound">
                        <Fields>
                            <asp:TemplateField HeaderText="" ShowHeader="false">
                                <ItemTemplate>
                                    <div class="row">
                                        <label class="col-sm-3 control-label">
                                            Ref ID</label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static bold">
                                                <%# Eval("RefID") %>
                                            </div>
                                        </div>
                                    </div>
                                
                                    <div class='row <%# Eval("Meta1_Printable").ToString() == "True" ? "" : "hidden" %>'>
                                        <label class="col-sm-3 control-label">
                                            <%# Eval("Meta1_Label") %></label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("Meta1") %>
                                            </div>
                                        </div>
                                    </div>
                                
                                    <div class='row <%# Eval("Meta2_Printable").ToString() == "True" ? "" : "hidden" %>'>
                                        <label class="col-sm-3 control-label">
                                            <%# Eval("Meta2_Label") %></label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("Meta2") %>
                                            </div>
                                        </div>
                                    </div>
                                       <div class='row <%# Eval("Meta3_Printable").ToString() == "True" ? "" : "hidden" %>'>
                                        <label class="col-sm-3 control-label">
                                            <%# Eval("Meta3_Label") %></label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("Meta3") %>
                                            </div>
                                        </div>
                                    </div>
                                <div class='row <%# Eval("Meta4_Printable").ToString() == "True" ? "" : "hidden" %>'>
                                        <label class="col-sm-3 control-label">
                                            <%# Eval("Meta4_Label") %></label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("Meta4") %>
                                            </div>
                                        </div>
                                    </div>
                                     <div class='row <%# Eval("Meta5_Printable").ToString() == "True" ? "" : "hidden" %>'>
                                        <label class="col-sm-3 control-label">
                                            <%# Eval("Meta5_Label") %></label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("Meta5") %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <label class="col-sm-3 control-label">
                                            Total Amount</label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static bold">
                                                <%# Eval("TotalAmount") %>
                                            </div>
                                        </div>
                                    </div>
                                
                                    <div class="row">
                                        <label class="col-sm-3 control-label">
                                            Status</label>
                                        <div class="col-sm-9">
                                            <div class="form-control-static">
                                                <%# Eval("StatusDetails") %>
                                            </div>
                                        </div>
                                    </div>
                                    
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Fields>
                        <EmptyDataTemplate>
                            Payment Not Completed.
                          
                        </EmptyDataTemplate>
                    </asp:DetailsView>
                </div>
            </div>
            <div class="col-sm-2 text-center hidden-xs">
                <img src="Images/checkout.png" width="100" height="100" border="0" alt="Checkout" />
            </div>
        </div>
        <div class="row">
            <div class="col-sm-4 col-md-offset-4 col-sm-offset-4">
                <%--<asp:Button ID="btnPrint" CssClass="form-control btn btn-success" Visible="false" runat="server" Text="Print" onclick="location.href = 'Checkout_Payment_Receipt.ashx?refid=<%# Eval("RefID") %>&key=<%# Eval("keycode")%>&merid=<%# Eval("MarchentID")%>'" />--%>
                <asp:HyperLink ID="hypPrint" runat="server" Text="Print Payment Voucher" CssClass="btn btn-success btn-block"
                    Target="_blank" />
            </div>
        </div>
        <asp:SqlDataSource ID="SqlDataPayStatus" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
            SelectCommand="s_CheckoutMerchantPayConfirm" SelectCommandType="StoredProcedure">
            <SelectParameters>
                <asp:ControlParameter ControlID="hidMerchantID" Name="MerchantID" Type="String" />
                  <asp:ControlParameter ControlID="hidOrderID" Name="OrderID" Type="String" />
                  <asp:ControlParameter ControlID="hidRefID" Name="RefID" Type="String" />
            
            </SelectParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>