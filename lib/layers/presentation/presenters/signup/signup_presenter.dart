abstract class SignupPresenter {
  Future<void> signup();
  Future<void> signupWithGoogle();
  Future<void> getFromCameraOrGallery({bool isGallery = true});
  Future<void> resendVerificationEmail();
  Future<void> completeAccount();
  void validate();
  Future<void> navigateToLogin();
  Future<void> navigateToSignupPassword();
  Future<void> navigateToSignupPhoto();
  Future<void> navigateToConfirmEmail();
  Future<void> navigateToDashboard();
}