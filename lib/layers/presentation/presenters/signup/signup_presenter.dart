abstract class SignupPresenter {
  Future<void> signup();
  Future<void> signupWithGoogle();
  Future<void> getFromCameraOrGallery({bool isGallery = true});
  void validate();
  Future<void> navigateToLogin();
  Future<void> navigateToSignupPassword();
  Future<void> navigateToSignupPhoto();
}