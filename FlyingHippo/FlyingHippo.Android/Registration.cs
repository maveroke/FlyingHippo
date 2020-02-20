using FlyingHippo.Droid.Services;
using FlyingHippo.Services;
using Prism;
using Prism.Ioc;

namespace FlyingHippo.Droid
{
    public class Registration : IPlatformInitializer
    {
        public void RegisterTypes(IContainerRegistry containerRegistry)
        {
            containerRegistry.Register<INativeSettingsService, NativeSettingsService>();
        }
    }
}