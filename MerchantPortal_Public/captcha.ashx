<%@ WebHandler Language="C#" Class="captcha" %>

using System;
using System.Web;
using System.Drawing;
using System.Web.SessionState;

public class captcha : IHttpHandler, IRequiresSessionState
{

   
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "image/jpeg";
        TrustCaptcha captcha = new TrustCaptcha();
        string str = captcha.DrawCaptcha(5);
        if (context.Session[TrustCaptcha.SESSION_CAPTCHA] == null) context.Session.Add(TrustCaptcha.SESSION_CAPTCHA, str);
        else
        {
            context.Session[TrustCaptcha.SESSION_CAPTCHA] = str;
        }
        Bitmap bmp = captcha.Result;
        bmp.Save(context.Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
    }
    
    
    public bool IsReusable {
        get {
            return true;
        }
    }

}