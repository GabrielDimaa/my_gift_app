import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';

import '../../../../monostates/user_global.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_camera.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_gallery.dart';
import '../../../domain/usecases/abstracts/signup/i_check_email_verified.dart';
import '../../../domain/usecases/abstracts/signup/i_send_verification_email.dart';
import '../../../domain/usecases/abstracts/user/i_get_user_logged.dart';
import '../../ui/pages/dashboard/dashboard_page.dart';
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
  final ISignUpEmail _signUpEmail;
  final IFetchImagePickerCamera _fetchImagePickerCamera;
  final IFetchImagePickerGallery _fetchImagePickerGallery;
  final ISendVerificationEmail _sendVerificationEmail;
  final ICheckEmailVerified _checkEmailVerified;
  final IGetUserLogged _getUserLogged;

  GetxSignupPresenter({
    required ISignUpEmail signUpEmail,
    required IFetchImagePickerCamera fetchImagePickerCamera,
    required IFetchImagePickerGallery fetchImagePickerGallery,
    required ISendVerificationEmail sendVerificationEmail,
    required ICheckEmailVerified checkEmailVerified,
    required IGetUserLogged getUserLogged,
  })  : _signUpEmail = signUpEmail,
        _fetchImagePickerCamera = fetchImagePickerCamera,
        _fetchImagePickerGallery = fetchImagePickerGallery,
        _sendVerificationEmail = sendVerificationEmail,
        _checkEmailVerified = checkEmailVerified,
        _getUserLogged = getUserLogged;

  late SignupViewModel _viewModel;

  @override
  SignupViewModel get viewModel => _viewModel;

  @override
  void setViewModel(SignupViewModel value) => _viewModel = value;

  UserEntity? _userEntity;
  Timer? _timerResendEmail;
  int maxSeconds = 60;

  final RxnInt _timerTick = RxnInt(60);

  @override
  int? get timerTick => _timerTick.value;

  final RxBool _resendEmail = RxBool(false);

  void setResendEmail(bool value) => _resendEmail.value = value;

  @override
  bool get resendEmail => _resendEmail.value;

  final RxBool _loadingResendEmail = RxBool(false);

  void setLoadingResendEmail(bool value) => _loadingResendEmail.value = value;

  @override
  bool get loadingResendEmail => _loadingResendEmail.value;

  @override
  void onInit() {
    setViewModel(SignupViewModel());
    super.onInit();
  }

  @override
  Future<void> signup() async {
    try {
      validate();

      _userEntity = await _signUpEmail.signUp(viewModel.toEntity());
      await navigateToConfirmEmail();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
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
        image = await _fetchImagePickerGallery.fetchFromGallery();
      } else {
        image = await _fetchImagePickerCamera.fetchFromCamera();
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
      await _sendVerificationEmail.send(_userEntity!.id!);

      setResendEmail(true);
      startTimerResendEmail();
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      //Apenas para exibição do loading na tela, sem atrapalhar o processo.
      await Future.delayed(const Duration(seconds: 2));
      setLoadingResendEmail(false);
    }
  }

  @override
  Future<void> completeAccount() async {
    try {
      if (_userEntity?.id == null) {
        final UserEntity? user = await _getUserLogged.getUser();
        if (user == null) throw UnexpectedDomainError(R.string.unexpectedError);

        _userEntity = user;
      }
      final bool verified = await _checkEmailVerified.check(_userEntity!.id!);
      if (!verified) throw EmailNotVerifiedDomainError();

      _userEntity!.emailVerified = verified;

      final UserGlobal userGlobal = UserGlobal();
      userGlobal.setUser(_userEntity);

      await navigateToDashboard();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  void validate() async {
    if (viewModel.email == null || viewModel.email!.trim().isEmpty) throw ValidationDomainError(message: R.string.emailNotInformedError);
    if (viewModel.password == null || viewModel.password!.isEmpty) throw ValidationDomainError(message: R.string.passwordNotInformedError);
    if (viewModel.name == null || viewModel.name!.trim().isEmpty) throw ValidationDomainError(message: R.string.nameNotInformedError);
  }

  @override
  Future<void> navigateToLogin() async => await Get.offAll(() => const LoginPage());

  @override
  Future<void> navigateToSignupPassword() async => await Get.to(() => const SignupPasswordPage());

  @override
  Future<void> navigateToSignupPhoto() async => await Get.to(() => const SignupPhotoPage());

  @override
  Future<void> navigateToConfirmEmail() async => await Get.offAll(() => const SignupConfirmEmailPage());

  @override
  Future<void> navigateToDashboard() async => await Get.offAll(() => const DashboardPage());

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
