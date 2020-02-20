using Prism.Navigation;

namespace FlyingHippo.ViewModels
{
    public class AnotherPageViewModel : BaseViewModel
    {
        public AnotherPageViewModel(INavigationService navigationService)
            : base(navigationService)
        {
            Title = "Another Page!";
        }
    }
}
