import 'package:get/get.dart';

import '../../../../extensions/string_extension.dart';
import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/signup/i_signup_email.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/signup/signup_password_page.dart';
import '../../ui/pages/signup/signup_photo_page.dart';
import '../../viewmodels/signup_viewmodel.dart';
import './signup_presenter.dart';

class GetxSignupPresenter extends GetxController with LoadingManager implements SignupPresenter {
  final ISignUpEmail signUpEmail;

  GetxSignupPresenter({required this.signUpEmail});

  SignupViewModel viewModel = SignupViewModel();

  @override
  Future<void> signup() async {
    try {
      setLoading(true);

      validate();

      final UserEntity user = await signUpEmail.signUp(viewModel.toEntity());
    } on DomainError catch (e) {
      throw e.message;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> signupWithGoogle() {
    // TODO: implement signupWithGoogle
    throw UnimplementedError();
  }

  @override
  void validate() async {
    if (viewModel.email.value == null || viewModel.email.value!.trim().isEmpty) throw ValidationDomainError(message: R.string.emailNotInformedError);
    if (viewModel.password.value == null || viewModel.password.value!.isEmpty) throw ValidationDomainError(message: R.string.passwordNotInformedError);
    if (viewModel.name.value == null || viewModel.name.value!.trim().isEmpty) throw ValidationDomainError(message: R.string.nameNotInformedError);
  }

  @override
  Future<void> navigateToLogin() async => await Get.off(() => const LoginPage());

  @override
  Future<void> navigateToSignupPassword() async => await Get.to(() => const SignupPasswordPage());

  @override
  Future<void> navigateToSignupPhoto() async => await Get.to(() => const SignupPhotoPage());
}
