import '../../helpers/interfaces/i_initialize.dart';
import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/reset_password_viewmodel.dart';

abstract class ResetPasswordPresenter implements IInitialize, IViewModel<ResetPasswordViewModel>, ILoading {
  bool get logged;
  void setLogged(bool value);

  Future<void> sendCode();
  Future<void> resendCode();
  Future<void> updatePassword();
  void validate();

  int? get timerTick;
  bool get resendEmail;
  bool get loadingResendEmail;
  void startTimerResendEmail();
}