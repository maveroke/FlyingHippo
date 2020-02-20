using FlyingHippo.Controls;
using FlyingHippo.ViewModels;
using FlyingHippo.Views;
using Prism.Ioc;

namespace FlyingHippo
{
    public static class Registration
    {
        public static void RegisterDependencies(IContainerRegistry containerRegistry)
        {
            containerRegistry.RegisterForNavigation<ExtendedNavigationPage>("NavigationPage");
            containerRegistry.RegisterForNavigation<MainPage, MainPageViewModel>();
            containerRegistry.RegisterForNavigation<AnotherPage, AnotherPageViewModel>();
        }
    }
}
