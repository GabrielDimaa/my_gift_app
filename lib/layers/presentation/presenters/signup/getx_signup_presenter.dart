import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_camera.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_gallery.dart';
import '../../../domain/usecases/abstracts/signup/i_send_verification_email.dart';
import '../../ui/pages/signup/signup_confirm_email_page.dart';
import './signup_presenter.dart';
import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/signup/i_signup_email.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../ui/pages/login/login_page.dart';
import '../../ui/pages/signup/signup_password_page.dart';
import '../../ui/pages/signup/signup_photo_page.dart';
import '../../viewmodels/signup_viewmodel.dart';

class GetxSignupPresenter extends GetxController with LoadingManager implements SignupPresenter {
  final ISignUpEmail signUpEmail;
  final IFetchImagePickerCamera fetchImagePickerCamera;
  final IFetchImagePickerGallery fetchImagePickerGallery;
  final ISendVerificationEmail sendVerificationEmail;

  GetxSignupPresenter({
    required this.signUpEmail,
    required this.fetchImagePickerCamera,
    required this.fetchImagePickerGallery,
    required this.sendVerificationEmail,
  });

  Timer? _timerResendEmail;
  int maxSeconds = 60;
  RxnInt timerTick = RxnInt(60);

  SignupViewModel viewModel = SignupViewModel();
  UserEntity? _userEntity;

  RxBool resendEmail = RxBool(false);
  void setResendEmail(bool value) => resendEmail.value = value;

  RxBool loadingResendEmail = RxBool(false);
  void setLoadingResendEmail(bool value) => loadingResendEmail.value = value;

  @override
  Future<void> signup() async {
    try {
      setLoading(true);

      validate();

      _userEntity = await signUpEmail.signUp(viewModel.toEntity());
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }

    await navigateToConfirmEmail();
  }

  @override
  Future<void> signupWithGoogle() {
    // TODO: implement signupWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> getFromCameraOrGallery({bool isGallery = true}) async {
    try {
      setLoading(true);

      final File? image;
      if (isGallery) {
        image = await fetchImagePickerGallery.fetchFromGallery();
      } else {
        image = await fetchImagePickerCamera.fetchFromCamera();
      }

      if (image == null) throw Exception(R.string.noImageSelected);

      viewModel.setPhoto(image);
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> resendVerificationEmail() async {
    try {
      setLoadingResendEmail(true);

      if (_userEntity?.id == null) throw UnexpectedDomainError(R.string.unexpectedError);
      await sendVerificationEmail.send(_userEntity!.id!);

      setResendEmail(true);
      startTimerResendEmail();
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      setLoadingResendEmail(false);
    }
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

  @override
  Future<void> navigateToConfirmEmail() async => await Get.offAll(() => const SignupConfirmEmailPage());

  void startTimerResendEmail() {
    if (!(_timerResendEmail?.isActive ?? false)) {
      _timerResendEmail = Timer.periodic(const Duration(seconds: 1), (timer) {
        timerTick.value = maxSeconds - timer.tick;
        if (timer.tick >= maxSeconds) {
          timerTick.value = null;
          _timerResendEmail?.cancel();
        }
      });
    }
  }
}
