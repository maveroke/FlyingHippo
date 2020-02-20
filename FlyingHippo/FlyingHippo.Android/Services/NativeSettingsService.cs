using System;
using Android.App;
using Android.Content.PM;
using FlyingHippo.Services;

namespace FlyingHippo.Droid.Services
{
    public class NativeSettingsService : INativeSettingsService
    {
        private readonly Uri _baseUrl;

        private readonly string _buildNumber;

        private readonly string _version;

        public NativeSettingsService()
        {
            var packageInfo = Application.Context.PackageManager.GetPackageInfo(Application.Context.PackageName, 0);
            var appInfo = Application.Context.PackageManager.GetApplicationInfo(Application.Context.PackageName, PackageInfoFlags.MetaData);
            var data = appInfo.MetaData;
            _baseUrl = new Uri(data.GetString("BaseUrl"));
            _buildNumber = packageInfo.VersionName;
            _version = packageInfo.VersionCode.ToString();
        }

        public static string GetAppCenterKey()
        {
            var appInfo = Application.Context.PackageManager.GetApplicationInfo(Application.Context.PackageName, PackageInfoFlags.MetaData);
            var test = appInfo.MetaData;
            return test.GetString("AppCenterKey");
        }

        public Uri GetBaseUrl()
        {
            return _baseUrl;
        }

        public string GetBuildNumber()
        {
            return _buildNumber;
        }

        public string GetVersion()
        {
            return _version;
        }
    }
}
