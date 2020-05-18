using System.Threading.Tasks;
using FlyingHippo.Services;
using Prism.Commands;
using Prism.Navigation;

namespace FlyingHippo.ViewModels
{
    public class MainPageViewModel : BaseViewModel
    {
        private readonly INativeSettingsService _nativeSettings;

        public MainPageViewModel(INavigationService navigationService, INativeSettingsService nativeSettings)
            : base(navigationService)
        { 
            _nativeSettings = nativeSettings;
            Title = "Build Demo";
            BuildNumber = $"Version: {_nativeSettings.GetBuildNumber()} ({_nativeSettings.GetVersion()})";
        }

        public string BuildNumber { get; set; }

        public DelegateCommand NavigateToAnotherPageCommand => new DelegateCommand(async () => await NavigateToAnotherPage());

        private async Task NavigateToAnotherPage()
        {
            await NavigationService.NavigateAsync("AnotherPage");
        }
    }
}
