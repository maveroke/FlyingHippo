using System;
namespace FlyingHippo.Services
{
    public interface INativeSettingsService
    {
        Uri GetBaseUrl();
        string GetVersion();
        string GetBuildNumber();
    }
}
