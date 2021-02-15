<%@ Page Title="" Language="C#" MasterPageFile="~/Master.master" AutoEventWireup="true"
    CodeFile="REB_Download.aspx.cs" Inherits="REB_Download" %>

<%@ Register Src="AKControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainTitle" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:SqlDataSource ID="SqlDataSourceReExport" runat="server" ConnectionString="<%$ ConnectionStrings:CardDataConnectionString %>"
        SelectCommand="sp_ExportToITCL_Offline_CSV" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter QueryStringField="branches" Name="BranchCodes" Type="String"
                DefaultValue="*" />
            <asp:QueryStringParameter QueryStringField="batch" Name="BatchID" Type="Int32" DefaultValue="" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:CardDataConnectionString %>"
        SelectCommand="sp_ExportToITCL_Offline_xlsx" SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter QueryStringField="branches" Name="BranchCodes" Type="String"
                DefaultValue="*" />
            <asp:QueryStringParameter QueryStringField="batch" Name="BatchID" Type="Int32"  />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>