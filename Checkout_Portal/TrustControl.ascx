<%@ Control Language="C#" AutoEventWireup="true" CodeFile="TrustControl.ascx.cs" Inherits="TrustControl" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:ScriptManager 
    ID="TrustScriptManager" 
    runat="server"    
    CompositeScript-ScriptMode="Release"
    AsyncPostBackTimeout="360000" 
    ScriptMode="Release" 
    EnableHistory="True" EnableCdn="false"
    EnablePageMethods="True">    
    
</asp:ScriptManager>