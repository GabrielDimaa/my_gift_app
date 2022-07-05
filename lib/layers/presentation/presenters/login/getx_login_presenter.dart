import 'package:get/get.dart';

import '../../../../exceptions/errors.dart';
import '../../../../i18n/resources.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/abstracts/login/i_login_email.dart';
import '../../ui/pages/dashboard/dashboard_page.dart';
import '../../ui/pages/signup/signup_confirm_email_page.dart';
import '../../ui/pages/signup/signup_page.dart';
import '../../viewmodels/login_viewmodel.dart';
import './login_presenter.dart';

class GetxLoginPresenter extends GetxController implements LoginPresenter {
  final ILoginEmail _loginWithEmail;

  GetxLoginPresenter({required ILoginEmail loginWithEmail}) : _loginWithEmail = loginWithEmail;

  late LoginViewModel _viewModel;

  @override
  LoginViewModel get viewModel => _viewModel;

  @override
  void setViewModel(LoginViewModel value) => _viewModel = value;

  @override
  void onInit() {
    setViewModel(LoginViewModel());
    super.onInit();
  }

  @override
  Future<void> login() async {
    try {
      validate();

      final UserEntity user = await _loginWithEmail.auth(viewModel.toParams());
      final UserGlobal userGlobal = UserGlobal();
      userGlobal.setUser(user);

      await navigateToDashboard();
    } on EmailError {
      await navigateToConfirmEmail();
    }
  }

  @override
  void validate() {
    if (viewModel.email == null || viewModel.email!.trim().isEmpty) throw RequiredError(R.string.emailNotInformedError);
    if (viewModel.password == null || viewModel.password!.isEmpty) throw RequiredError(R.string.passwordNotInformedError);
  }

  @override
  Future<void> loginWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<void> navigateToSignUp() async => await Get.offAll(() => const SignupPage());

  @override
  Future<void> navigateToDashboard() async => await Get.offAll(() => const DashboardPage());

  @override
  Future<void> navigateToConfirmEmail() async => await Get.offAll(() => const SignupConfirmEmailPage());
}
