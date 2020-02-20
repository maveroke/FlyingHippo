using System;
using FlyingHippo.Services;
using Foundation;

namespace FlyingHippo.iOS.Services
{
    public class NativeSettingsService : INativeSettingsService
    {
        public static string GetAppCenterKey()
        {
            return NSBundle.MainBundle.ObjectForInfoDictionary("AppCenterKey").ToString();
        }

        public Uri GetBaseUrl()
        {
            return new Uri(NSBundle.MainBundle.ObjectForInfoDictionary("BaseUrl").ToString());
        }

        public string GetBuildNumber()
        {
            return NSBundle.MainBundle.ObjectForInfoDictionary("CFBundleShortVersionString").ToString();
        }

        public string GetVersion()
        {
            return NSBundle.MainBundle.ObjectForInfoDictionary("CFBundleVersion").ToString();
        }
    }
}