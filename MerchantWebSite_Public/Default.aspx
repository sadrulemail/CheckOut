<%@ Page Title="" Language="C#" MasterPageFile="~/TrustBank.master" AutoEventWireup="True"
    CodeFile="Default.aspx.cs" Inherits="ServiceCube.DefaultPage" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="CommonControl.ascx" TagName="CommonControl" TagPrefix="uc1" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <%= ConfigurationManager.AppSettings["AppName"] %>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <asp:ScriptManager ID="TrustScriptManager" runat="server"
        ScriptMode="Release" EnablePartialRendering="true">
    </asp:ScriptManager>
    <style type="text/css">
        .row-pad-top {
            padding-top: 10px;
        }
    </style>
    <script type="text/javascript">
      // This is called with the results from from FB.getLoginStatus().
      function statusChangeCallback(response) {
        //console.log('statusChangeCallback');
        //console.log(response);
        // The response object is returned with a status field that lets the
        // app know the current login status of the person.
        // Full docs on the response object can be found in the documentation
        // for FB.getLoginStatus().
        if (response.status === 'connected') {
            // Logged into your app and Facebook.
            //console.log(response);
            console.log(response.authResponse.accessToken);
            testAPI(response);
        } else if (response.status === 'not_authorized') {
          // The person is logged into Facebook, but not your app.
          document.getElementById('status').innerHTML = '';
        } else {
          // The person is not logged into Facebook, so we're not sure if
          // they are logged into this app or not.
          document.getElementById('status').innerHTML = '';
        }
      }

      // This function is called when someone finishes with the Login
      // Button.  See the onlogin handler attached to it in the sample
      // code below.
      function checkLoginState() {
        FB.getLoginStatus(function(response) {
          statusChangeCallback(response);
        });
      }

      window.fbAsyncInit = function() {
      FB.init({
          appId: '<%= ConfigurationManager.AppSettings["FacebookAppId"] %>',
          cookie     : true,  // enable cookies to allow the server to access 
                            // the session
          xfbml      : true,  // parse social plugins on this page
          version    : 'v2.5' // use version 2.2
      });

      // Now that we've initialized the JavaScript SDK, we call 
      // FB.getLoginStatus().  This function gets the state of the
      // person visiting this page and can return one of three states to
      // the callback you provide.  They can be:
      //
      // 1. Logged into your app ('connected')
      // 2. Logged into Facebook, but not your app ('not_authorized')
      // 3. Not logged into Facebook and can't tell if they are logged into
      //    your app or not.
      //
      // These three cases are handled in the callback function.

      FB.getLoginStatus(function(response) {
        statusChangeCallback(response);
      });

      };

      // Load the SDK asynchronously
      (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "https://connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));

      // Here we run a very simple test of the Graph API after login is
      // successful.  See statusChangeCallback() for when this call is made.
      function testAPI() {
        //console.log('Fetching your info...');
        FB.api('/me', function(response) {
          //console.log('Successful login for: ' + response.name);
          document.getElementById('status').innerHTML =
            'Welcome, ' + response.name + ' ';
            //console.log(response.authResponse);
        });
      }
    </script>
    <uc1:CommonControl ID="CommonControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="row">
                <div class="col-sm-5" style="max-width: 320px">
                    <div class="panel panel-info" style="background: #f3f3f3">
                        <div class="panel-body" style="padding: 0 25px">
                            <div class="row bold row-pad-top">
                                Trust Bank Web User ID
                            </div>
                            <div class="form-group has-feedback">
                                <asp:TextBox ID="txtLoginId" CssClass="form-control" runat="server" 
                                    MaxLength="255" AutoCompleteType="Email" placeholder="email address"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtLoginId" runat="server" ControlToValidate="txtLoginId"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>
                            <div class="row bold">
                                Password
                            </div>
                            <div class="form-group has-feedback">
                                <asp:TextBox ID="txtPassword" TextMode="Password" CssClass="form-control" runat="server"
                                    MaxLength="255" placeholder="password"
                                    required></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtPassword"
                                    ErrorMessage="*" Style="margin: 5px" ForeColor="Red" Font-Size="25px" Font-Bold="true" SetFocusOnError="True" CssClass="form-control-feedback"></asp:RequiredFieldValidator>
                            </div>

                            <div class="row bold">
                                Challenge Key
                            </div>
                            <div class="row">
                                <div class="col-xs-4" style="padding: 0; margin-right: 10px">
                                    <asp:TextBox ID="txtCaptcha" CssClass="form-control" runat="server"
                                        MaxLength="5" required placeholder="#####" autocomplete="off" pattern="^\d{5}$"
                                        ToolTip="Enter Challenge Key Numbers"></asp:TextBox>
                                </div>
                                <div style="padding: 0">
                                    <img src='Images/loading1.gif' id="ImgChallenge" alt="Captcha" style="border: 1px solid silver; padding: 2px; border-radius: 4px; cursor: pointer"
                                        width="130" height="35" title="Another Challenge Image" />

                                    <img src="Images/reload.png" id="ImgChallengeReload" style="cursor: pointer" title="Another Challenge Image"
                                        alt="Refresh" width="16" height="16" border="0" />
                                </div>
                            </div>

                            <div class="row" style="padding-top: 20px">
                                <div class="col-sm-5 col-md-6" style="padding: 0">
                                    <asp:Button ID="cmdSubmit" CssClass="btn btn-success btn-block" runat="server" Text="Login"
                                        OnClick="cmd_Click" clientid="cmdSubmit" />
                                </div>
                                <div class="col-sm-7 col-md-6" style="padding-top: 10px">
                                    <a class="bold" href='../webuser/ForgetPassword.aspx?appid=<%= ConfigurationManager.AppSettings["WebAppID"] %>' style="font-size: 85%" target="_blank">Forget Password?</a>
                                </div>
                            </div>
                            <div class="row" >
                                <fb:login-button 
                                    scope="public_profile,email,user_birthday,public_profile,user_photos" 
                                    data-size="large" 
                                    onlogin="checkLoginState();" > 
                                </fb:login-button>
                                <div id="status">
                                </div>
                            </div>
                            <div class="row" style="padding-top: 30px; padding-bottom: 15px; font-size: 95%">
                                Please enter your Trust Bank Web User ID and Password to log in. 
                                If you do not have Trust Bank Web User account, please click on
                                <a class="bold" href='../webuser/Signup.aspx?appid=<%= ConfigurationManager.AppSettings["WebAppID"] %>' target="_blank">Create Now</a>

                            </div>
                        </div>
                    </div>
                </div>
                <br />
                <div class="col-sm-7">
                    <img src="images/checkout.png" class="img-responsive center-block" style="max-width:300px" />
                </div>
            </div>
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
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
