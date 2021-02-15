<%@ Page Title="" Language="C#" MasterPageFile="~/Master.Master" AutoEventWireup="true"
    CodeFile="Users.aspx.cs" Inherits="Users" %>

<%@ Register Src="AKControl.ascx" TagName="AKControl" TagPrefix="uc1" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<script type="text/javascript">
    function AddEmail1(Comment) {
        var obj = document.getElementById('ctl00_cphMain_DetailsView1_txtEmail');
        obj.value += Comment;
    }       
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTitle" runat="server">
    User Management
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphMain" runat="server">
    <uc1:AKControl ID="AKControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Button ID="cmdShowAll" runat="server" CausesValidation="false"
                OnClick="cmdShowAll_Click" Text="Show All"></asp:Button>
            <asp:Button ID="cmdAddNew" runat="server" CausesValidation="false"
                OnClick="cmdAddNew_Click" Text="Add New"></asp:Button>
            <hr />
            <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
                <asp:View ID="View1" runat="server">
                    <asp:GridView ID="GridView1" CssClass="Grid" runat="server" AllowPaging="True" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="Solid"
                        BorderWidth="1px" CellPadding="4" DataSourceID="SqlDataSource1" ForeColor="Black"
                        GridLines="Both" PageSize="20" OnRowCommand="GridView1_RowCommand" Width="100%"
                        PagerSettings-Position="TopAndBottom">
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <Columns>
                            <asp:CheckBoxField DataField="Active" HeaderText="#" SortExpression="Active" />
                            <asp:TemplateField HeaderText="Username" SortExpression="UserName" ItemStyle-Wrap="false">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" Font-Bold="true" CommandName="OPEN" CssClass="HypID"
                                        CommandArgument='<%# Eval("UserName") %>' runat="server" Text='<%# Eval("UserName") %>'></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FullName" HeaderText="Full Name" SortExpression="FullName"
                                ItemStyle-Wrap="false" />
                            <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
                            <asp:BoundField DataField="Address" HeaderText="Address" SortExpression="Address" />
                            <asp:TemplateField HeaderText="Roles" SortExpression="UserRole">
                                <ItemTemplate>
                                    <%# Eval("UserRole").ToString().Replace(",", "<br>")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="CreateDT" HeaderText="CreateDT" SortExpression="CreateDT" />
                            <asp:BoundField DataField="ModifyDT" HeaderText="ModifyDT" SortExpression="ModifyDT" />
                            <asp:BoundField DataField="ModifyBy" HeaderText="ModifyBy" SortExpression="ModifyBy" />
                            <asp:BoundField DataField="LastLoginDT" HeaderText="LastLoginDT" SortExpression="LastLoginDT" />
                        </Columns>
                        <FooterStyle BackColor="#CCCC99" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                        <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:GridView>
                    <br />
                    <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
                </asp:View>
                <asp:View ID="View2" runat="server">
                    <asp:DetailsView CssClass="Grid" ID="DetailsView1" runat="server" BackColor="White"
                        BorderColor="#DEDFDE" BorderStyle="Solid" BorderWidth="1px" CellPadding="4" DataSourceID="SqlDataSource2"
                        ForeColor="Black" GridLines="Vertical" AutoGenerateRows="False" OnDataBound="DetailsView1_DataBound">
                        <FooterStyle BackColor="#CCCC99" />
                        <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                        <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" CssClass="PagerStyle" />
                        <Fields>
                            <asp:TemplateField HeaderText="Username" SortExpression="UserName">
                                <EditItemTemplate>
                                    <span class="LargeFont">
                                        <%# Eval("UserName") %></span>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="txtUserName" runat="server" Text='<%# Bind("UserName") %>' MaxLength="20"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtUserName"
                                        ErrorMessage="*"></asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <span class="LargeFont">
                                        <%# Eval("UserName") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Full Name" SortExpression="FullName">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" MaxLength="100" Text='<%# Bind("FullName") %>'
                                        Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox2"
                                        ErrorMessage="*">*</asp:RequiredFieldValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" MaxLength="100" Text='<%# Bind("FullName") %>'
                                        Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox2"
                                        ErrorMessage="*">*</asp:RequiredFieldValidator>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# Bind("FullName") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Email" SortExpression="Email">
                                <EditItemTemplate>
                                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="100" Text='<%# Bind("Email") %>'
                                        Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEmail"
                                        ErrorMessage="*">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                        ErrorMessage="Invalid Email Address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="100" Text='<%# Bind("Email") %>'
                                        Width="300px"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtEmail"
                                        ErrorMessage="*">*</asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                                        ErrorMessage="Invalid Email Address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        <span title="Add @trustbanklimited.com"
                                                        onclick="javascript:AddEmail1('@trustbanklimited.com')" style="cursor: pointer">
                                                        <img src="Images/tbl.jpg" border="0" /></span>
                                </InsertItemTemplate>
                                
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# Bind("Email") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Address" SortExpression="Address">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Address") %>' TextMode="MultiLine"
                                        Height="50px" Width="300px"></asp:TextBox>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("Address") %>' TextMode="MultiLine"
                                        Height="50px" Width="300px"></asp:TextBox>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# Bind("Address") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="User Roles" SortExpression="UserRole">
                                <EditItemTemplate>
                                    <asp:CheckBoxList ID="chkRoles" runat="server" DataSourceID="SqlDataSourceRoles"
                                        DataTextField="DescriptionHTML" DataValueField="UserRole">
                                    </asp:CheckBoxList>
                                    <asp:SqlDataSource ID="SqlDataSourceRoles" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                                        SelectCommand="SELECT * FROM v_Roles"></asp:SqlDataSource>
                                    <asp:HiddenField ID="HidUserRoles" runat="server" Value='<%# Eval("UserRole") %>' />
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:CheckBoxList ID="chkRoles" runat="server" DataSourceID="SqlDataSourceRoles"
                                        DataTextField="DescriptionHTML" DataValueField="UserRole">
                                    </asp:CheckBoxList>
                                    <asp:SqlDataSource ID="SqlDataSourceRoles" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                                        SelectCommand="SELECT * FROM v_Roles"></asp:SqlDataSource>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="lblUserRoles" runat="server" Text='<%# Eval("UserRole").ToString().Replace(",", "<br>") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" SortExpression="Active">
                                <EditItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Text="Active" />
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Text="Active" />
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:CheckBox ID="CheckBox1" runat="server" Checked='<%# Bind("Active") %>' Enabled="false"
                                        Text="Active" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <EditItemTemplate>
                                    <asp:Button ID="cmdUpdate" runat="server" CausesValidation="true" CommandName="Update"
                                        Text="Update User" Width="120px"></asp:Button>
                                    <asp:ConfirmButtonExtender ID="cmdUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                        Enabled="True" TargetControlID="cmdUpdate">
                                    </asp:ConfirmButtonExtender>
                                </EditItemTemplate>
                                <InsertItemTemplate>
                                    <asp:Button ID="cmdInsert" runat="server" CausesValidation="true" CommandName="Insert"
                                        Text="Add User" Width="120px"></asp:Button>
                                    <asp:ConfirmButtonExtender ID="cmdInsert_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Add User?"
                                        Enabled="True" TargetControlID="cmdInsert">
                                    </asp:ConfirmButtonExtender>
                                </InsertItemTemplate>
                                <ItemTemplate>
                                    <asp:Button ID="cmdEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                        Text="Edit" Width="80px"></asp:Button>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Fields>
                        <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                        <AlternatingRowStyle BackColor="White" />
                    </asp:DetailsView>
                    <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                        SelectCommand="SELECT * FROM [Users] WHERE [Username] = @UserName" InsertCommand="s_user_add"
                        InsertCommandType="StoredProcedure" UpdateCommand="s_user_edit" UpdateCommandType="StoredProcedure"
                        OnInserted="SqlDataSource2_Inserted" ProviderName="<%$ ConnectionStrings:MainConnectionString.ProviderName %>"
                        OnUpdated="SqlDataSource2_Updated" OnInserting="SqlDataSource2_Inserting" OnUpdating="SqlDataSource2_Updating">
                        <SelectParameters>
                            <asp:ControlParameter Name="UserName" ControlID="HiddenField1" PropertyName="Value" />
                        </SelectParameters>
                        <UpdateParameters>
                            <asp:ControlParameter ControlID="HiddenField1" Name="UserName" PropertyName="Value"
                                Type="String" />
                            <asp:Parameter Name="FullName" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="Address" Type="String" />
                            <asp:Parameter Name="UserRole" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:SessionParameter Name="ModifyBy" SessionField="USERNAME" Type="String" />
                            <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" Size="200" DefaultValue="" />
                        </UpdateParameters>
                        <InsertParameters>
                            <asp:Parameter Name="UserName" Type="String" />
                            <asp:Parameter Name="FullName" Type="String" />
                            <asp:Parameter Name="Email" Type="String" />
                            <asp:Parameter Name="Address" Type="String" />
                            <asp:Parameter Name="UserRole" Type="String" />
                            <asp:Parameter Name="Active" Type="Boolean" />
                            <asp:SessionParameter Name="ModifyBy" SessionField="USERNAME" Type="String" />
                            <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" Size="200" DefaultValue="" />
                        </InsertParameters>
                    </asp:SqlDataSource>
                    <asp:HiddenField ID="HiddenField1" runat="server" Value="" />
                </asp:View>
            </asp:MultiView>
            <br />
            <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConnectionString %>"
                SelectCommand="SELECT * FROM [Users] ORDER BY [FullName]" OnSelected="SqlDataSource1_Selected">
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
