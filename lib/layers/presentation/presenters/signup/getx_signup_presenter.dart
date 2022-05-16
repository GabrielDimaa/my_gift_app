import 'package:desejando_app/layers/presentation/ui/pages/signup/signup_password_page.dart';
import 'package:desejando_app/layers/presentation/ui/pages/signup/signup_photo_page.dart';
import 'package:get/get.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/signup/i_signup_email.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../ui/pages/login/login_page.dart';
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
  Future<void> navigateToLogin() async => await Get.off(() => const LoginPage());

  @override
  Future<void> navigateToSignupPassword() async => await Get.to(() => const SignupPasswordPage());

  @override
  Future<void> navigateToSignupPhoto() async => await Get.to(() => const SignupPhotoPage());
}
