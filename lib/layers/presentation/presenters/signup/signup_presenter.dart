import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/signup_viewmodel.dart';

abstract class SignupPresenter implements IViewModel<SignupViewModel>, ILoading {
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

  int? get timerTick;
  bool get resendEmail;
  bool get loadingResendEmail;
  void startTimerResendEmail();
}
