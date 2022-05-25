import 'dart:io';

import 'package:get/get.dart';

import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_camera.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_gallery.dart';
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

  GetxSignupPresenter({
    required this.signUpEmail,
    required this.fetchImagePickerCamera,
    required this.fetchImagePickerGallery,
  });

  SignupViewModel viewModel = SignupViewModel();

  @override
  Future<void> signup() async {
    try {
      setLoading(true);

      validate();

      final UserEntity user = await signUpEmail.signUp(viewModel.toEntity());
    } on DomainError catch (e) {
      throw Exception(e.message);
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
