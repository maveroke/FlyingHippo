using System;
using System.Threading.Tasks;
using Prism;
using Prism.AppModel;
using Prism.Commands;
using Prism.Mvvm;
using Prism.Navigation;
using PropertyChanged;

namespace FlyingHippo.ViewModels
{
    [AddINotifyPropertyChangedInterface]
    public class BaseViewModel : BindableBase, IApplicationLifecycleAware, IActiveAware, IInitialize, INavigatedAware, IDestructible, IConfirmNavigation, IConfirmNavigationAsync, IPageLifecycleAware
    {
        private bool _isActive;

        public BaseViewModel(INavigationService navigationService)
        {
            NavigationService = navigationService;
        }

        public event EventHandler IsActiveChanged;

        public INavigationService NavigationService { get; }

        public string Title { get; set; }

        public string TabTitle { get; set; }

        public string TabIcon { get; set; }

        public bool IsBusy { get; set; }

        public bool CanGoBack { get; set; } = true;

        public bool CanLoadMore { get; set; }

        public string Header { get; set; }

        public string Footer { get; set; }

        public bool IsActive
        {
            get => _isActive;
            set => SetProperty(ref _isActive, value, onChanged: OnIsActiveChanged);
        }

        public virtual DelegateCommand GoBack => new DelegateCommand(async () => await GoBackCall());

        public void Busy() => IsBusy = true;

        public void NotBusy() => IsBusy = false;

        public virtual void OnNavigatedTo(INavigationParameters parameters) { }

        public virtual void OnNavigatedFrom(INavigationParameters parameters) { }

        public virtual void Destroy() { }

        public virtual bool CanNavigate(INavigationParameters parameters) => true;

        public virtual Task<bool> CanNavigateAsync(INavigationParameters parameters) =>
            Task.FromResult(CanNavigate(parameters));

        public virtual void OnResume() { }

        public virtual void OnSleep() { }

        public virtual void OnAppearing() { }

        public virtual void OnDisappearing() { }

        public virtual void Initialize(INavigationParameters parameters) { }

        protected virtual void OnIsActive() { }

        protected virtual void OnIsNotActive() { }

        private void OnIsActiveChanged()
        {
            IsActiveChanged?.Invoke(this, EventArgs.Empty);

            if (IsActive)
            {
                OnIsActive();
            }
            else
            {
                OnIsNotActive();
            }
        }

        private Task GoBackCall()
        {
            return NavigationService.GoBackAsync();
        }
    }
}
