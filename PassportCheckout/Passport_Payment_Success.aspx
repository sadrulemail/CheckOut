<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Passport_Payment_Success.aspx.cs"
    Inherits="Passport_Payment_Success" MasterPageFile="~/MasterBootstrap.master"
    ValidateRequest="false" Debug="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ContentPlaceHolderID="head" runat="server" ID="content1">
    <title>Trust Bank Checkout (Passport)</title>
    <style>
        .panel-body {
            padding: 0;
        }

        .hidden {
            display: none;
            visibility: hidden;
        }
    </style>
    <meta http-equiv="X-Frame-Options" content="deny" />
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server" ID="content2">
    Trust Bank Checkout (Passport)
</asp:Content>
<asp:Content ContentPlaceHolderID="ContentPlaceHolder2" runat="server" ID="content3">
    <asp:ToolkitScriptManager runat="server" ID="ToolkitScriptManager1" CombineScripts="true"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ToolkitScriptManager>
    <asp:UpdatePanel runat="server" ID="UpdatePanel1">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-2 text-center">
                    <img src="Images/checkout.png" width="100" height="100" border="0" alt="Checkout" />
                </div>
                <div class="col-sm-9 col-md-8">
                    <div>
                        <div class="panel panel-success">
                            <div class="panel-heading">
                                Payment Information
                            </div>
                            <div style="background-color: #F9F9F9" class="panel-body">
                                <div>
                                      <asp:Panel runat="server" ID="PanelError" class="row" Visible="false"  style="padding:20px">
                                        <div class="col-sm-2 text-center">
                                            <img src="Images/sad-icon.png" width="72" height="72" />
                                        </div>
                                        <div class="col-sm-9 col-md-7 text-center">
                                            <asp:Label ID="lblStatus" runat="server" ForeColor="Red" Text=""></asp:Label>
                                        </div>
                                    </asp:Panel>
                                   

                                    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table"
                                        BorderStyle="None" BorderWidth="0" CellPadding="10" DataKeyNames="RefID" DataSourceID="SqlDataSource1"
                                        ForeColor="Black" GridLines="None" ShowHeader="false">
                                        <EmptyDataTemplate>
                                            <div class="row" style="padding:20px">
                                                <div class="col-sm-2 text-center">
                                                    <img src="Images/sad-icon.png" width="72" height="72" />
                                                </div>
                                                <div class="col-sm-9 col-md-7 text-center">
                                                    Sorry, unable to retrieve payment information.
                                                </div>
                                            </div>
                                        </EmptyDataTemplate>
                                        <Columns>
                                            <asp:TemplateField>
                                                <ItemTemplate>
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label class="col-sm-4 bold control-label">
                                                                Reference No.</label>
                                                            <div class="col-sm-4 col-md-3 form-control-static">
                                                                <%# Eval("RefID") %>
                                                            </div>
                                                            <div class="col-sm-4 col-md-3">
                                                                <a class="pointer btn btn-danger btn-block" target="_blank" href='Passport_Payment_Receipt.ashx?RefID=<%# Eval("RefID") %>&key=<%# Eval("KeyCode","{0}") %>'>
                                                                    <div class="glyphicon print-sign btn">
                                                                    </div>
                                                                    Print</a>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="col-sm-4 bold control-label">
                                                                Customer Name</label>
                                                            <div class="col-sm-8 form-control-static">
                                                                <%# Eval("FullName") %>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="col-sm-4 bold control-label">
                                                                Total Amount</label>
                                                            <div class="col-sm-8 form-control-static">
                                                                <%# Eval("Amount","{0:N2} BDT") %>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label class="col-sm-4 bold control-label">
                                                                Email</label>
                                                            <div class="col-sm-8 form-control-static">
                                                                <%# Eval("Email") %>
                                                            </div>
                                                        </div>
                                                        <div class='row <%# (bool)Eval("VisibleReturnToPassportSiteButton") ? "" : "hidden" %>'>
                                                            <div class="col-sm-5 col-sm-offset-4">
                                                                <a class="btn btn-success btn-block" href='<%= ConfigurationSettings.AppSettings["PASSPORT_SUCCESS"] %>?onlineid=<%# Encrypt(Eval("PassportOnlineID")) %>&paymentdate=<%# Encrypt(Eval("PassportPaymentDate","{0:dd/MM/yyyy}")) %>&amount=<%# Encrypt( Eval("Amount")) %>&fullname=<%# Encrypt(Eval("FullName")) %>&payrefno=<%# Encrypt(Eval("RefID")) %>&sid=<%# Eval("SID") %>'>Return to Passport Site</a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:PaymentsDBConnectionString %>"
                                        SelectCommand="s_Payments_Passport_Success" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                                    
                                    
                                  




                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
