import '../../helpers/interfaces/i_initialize.dart';

abstract class SplashPresenter implements IInitialize {
  Future<void> navigateToDashboard();
  Future<void> navigateToLogin();
  Future<void> navigateToConfirmEmail();
}
