abstract class LoginPresenter {
  Future<void> login();
  Future<void> loginWithGoogle();
  void validate();
  Future<void> navigateToSignUp();
  Future<void> navigateToDashboard();
  Future<void> navigateToConfirmEmail();
}