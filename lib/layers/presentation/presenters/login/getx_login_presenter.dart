import 'package:get/get.dart';

import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/helpers/params/login_params.dart';
import '../../../domain/usecases/abstracts/login/i_login_email.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../ui/pages/signup/signup_page.dart';
import '../../viewmodels/login_viewmodel.dart';
import './login_presenter.dart';

class GetxLoginPresenter extends GetxController with LoadingManager implements LoginPresenter {
  final ILoginEmail loginWithEmail;

  GetxLoginPresenter({required this.loginWithEmail});

  LoginViewModel viewModel = LoginViewModel();

  @override
  Future<void> login() async {
    try {
      setLoading(true);

      validate();

      final LoginParams params = LoginParams(email: viewModel.email.value!.trim(), password: viewModel.password.value!);
      final UserEntity user = await loginWithEmail.auth(params);
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  void validate() {
    if (viewModel.email.value == null || viewModel.email.value!.trim().isEmpty) throw ValidationDomainError(message: R.string.emailNotInformedError);
    if (viewModel.password.value == null || viewModel.password.value!.isEmpty) throw ValidationDomainError(message: R.string.passwordNotInformedError);
  }

  @override
  Future<void> loginWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<void> navigateToSignUp() async {
    await Get.off(() => const SignupPage());
  }
}