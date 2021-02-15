<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CR.aspx.cs" Inherits="CR" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="Branch.ascx" TagName="Branch" TagPrefix="uc3" %>
<%@ Register Assembly="CrystalDecisions.Web, Version=13.0.2000.0, Culture=neutral, PublicKeyToken=692fbea5521e1304"
    Namespace="CrystalDecisions.Web" TagPrefix="CR" %>



<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <CR:CrystalReportSource ID="CrystalReportSource1" runat="server">
                <Report FileName="Reports\Test.rpt">
                    
                   
                </Report>
            </CR:CrystalReportSource>
     <CR:CrystalReportViewer ID="CrystalReportViewer1" runat="server" ReportSourceID="CrystalReportSource1"
                ShowAllPageIds="True" EnableDrillDown="False" DisplayStatusbar="false" HasCrystalLogo="False"
                ToolPanelView="None" HasToggleGroupTreeButton="False" HasDrilldownTabs="False"
                HasToggleParameterPanelButton="False" AutoDataBind="True" ReuseParameterValuesOnRefresh="True"
                EnableParameterPrompt="False" />

        
            
    </div>
    </form>
</body>
</html>
