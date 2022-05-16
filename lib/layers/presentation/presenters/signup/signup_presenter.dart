abstract class SignupPresenter {
  Future<void> signup();
  Future<void> signupWithGoogle();
  Future<void> navigateToLogin();
  Future<void> navigateToSignupPassword();
  Future<void> navigateToSignupPhoto();
}