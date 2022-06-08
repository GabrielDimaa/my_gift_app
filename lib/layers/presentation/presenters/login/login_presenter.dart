import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/login_viewmodel.dart';

abstract class LoginPresenter implements IViewModel<LoginViewModel> {
  Future<void> login();
  Future<void> loginWithGoogle();
  void validate();
  Future<void> navigateToSignUp();
  Future<void> navigateToDashboard();
  Future<void> navigateToConfirmEmail();
}
