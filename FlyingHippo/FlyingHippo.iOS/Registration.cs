using FlyingHippo.iOS.Services;
using FlyingHippo.Services;
using Prism;
using Prism.Ioc;

namespace FlyingHippo.iOS
{
    public class Registration : IPlatformInitializer
    {
        public void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.Register<INativeSettingsService, NativeSettingsService>();
        }
    }
}