abstract class SignupPresenter {
  Future<void> signup();
  Future<void> signupWithGoogle();
  void validate();
  Future<void> navigateToLogin();
  Future<void> navigateToSignupPassword();
  Future<void> navigateToSignupPhoto();
}