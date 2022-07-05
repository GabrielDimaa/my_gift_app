import 'dart:async';

import 'package:get/get.dart';

import '../../../../exceptions/errors.dart';
import '../../../../i18n/resources.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/helpers/params/new_password_params.dart';
import '../../../domain/usecases/abstracts/user/i_send_code_update_password.dart';
import '../../../domain/usecases/abstracts/user/i_update_password.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/reset_password_viewmodel.dart';
import 'reset_password_presenter.dart';

class GetxResetPasswordPresenter extends GetxController with LoadingManager implements ResetPasswordPresenter {
  final ISendCodeUpdatePassword _sendCodeUpdatePassword;
  final IUpdatePassword _updatePassword;

  GetxResetPasswordPresenter({
    required ISendCodeUpdatePassword sendCodeUpdatePassword,
    required IUpdatePassword updatePassword,
  })  : _sendCodeUpdatePassword = sendCodeUpdatePassword,
        _updatePassword = updatePassword;

  late ResetPasswordViewModel _viewModel;
  final RxnInt _timerTick = RxnInt(60);
  final RxBool _loadingResendEmail = RxBool(false);
  final RxBool _resendEmail = RxBool(false);
  bool _logged = false;
  Timer? _timerResendEmail;
  int maxSeconds = 60;

  @override
  ResetPasswordViewModel get viewModel => _viewModel;

  @override
  void setViewModel(ResetPasswordViewModel value) => _viewModel = value;

  @override
  int? get timerTick => _timerTick.value;

  @override
  bool get loadingResendEmail => _loadingResendEmail.value;

  @override
  bool get resendEmail => _resendEmail.value;

  @override
  bool get logged => _logged;

  @override
  void setLogged(bool value) => _logged = value;

  @override
  Future<void> initialize([viewModel]) async {
    try {
      setLoading(true);

      setViewModel(ResetPasswordViewModel());

      if (_logged) {
        final String email = UserGlobal().getUser()!.email;
        _viewModel.setEmail(email);
      }
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> sendCode() async {
    if (_viewModel.email == null) throw Exception(R.string.emailNotInformedError);
    await _sendCodeUpdatePassword.send(_viewModel.email!);

    startTimerResendEmail();
  }

  @override
  Future<void> resendCode() async {
    try {
      _loadingResendEmail.value = true;

      await sendCode();

      _resendEmail.value = true;
      startTimerResendEmail();
    } finally {
      //Apenas para exibição do loading na tela, sem atrapalhar o processo.
      await Future.delayed(const Duration(seconds: 2));
      _loadingResendEmail.value = false;
    }
  }

  @override
  Future<void> updatePassword() async {
    validate();

    final NewPasswordParams params = NewPasswordParams(newPassword: _viewModel.newPassword!, code: _viewModel.code!);
    await _updatePassword.update(params);
  }

  @override
  void validate() {
    if (_viewModel.code?.isEmpty ?? true) throw RequiredError(R.string.codeNotInformedError);
    if (_viewModel.newPassword?.isEmpty ?? true) throw RequiredError(R.string.passwordNotInformedError);
  }

  @override
  void startTimerResendEmail() {
    if (!(_timerResendEmail?.isActive ?? false)) {
      _timerResendEmail = Timer.periodic(const Duration(seconds: 1), (timer) {
        _timerTick.value = maxSeconds - timer.tick;
        if (timer.tick >= maxSeconds) {
          _timerTick.value = null;
          _timerResendEmail?.cancel();
        }
      });
    }
  }
}
