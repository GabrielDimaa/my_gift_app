import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../layers/domain/usecases/implements/image_picker/fetch_image_picker_camera.dart';
import '../layers/domain/usecases/implements/image_picker/fetch_image_picker_gallery.dart';
import '../layers/domain/usecases/implements/login/login_email.dart';
import '../layers/domain/usecases/implements/signup/check_email_verified.dart';
import '../layers/domain/usecases/implements/signup/send_verification_email.dart';
import '../layers/domain/usecases/implements/signup/signup_email.dart';
import '../layers/domain/usecases/implements/user/get_user_logged.dart';
import '../layers/infra/datasources/firebase_user_account_datasource.dart';
import '../layers/infra/datasources/storage/firebase_storage_datasource.dart';
import '../layers/infra/libraries/image_crop/image_cropper_facade.dart';
import '../layers/infra/libraries/image_picker/image_picker_facade.dart';
import '../layers/infra/repositories/user_account_repository.dart';
import '../layers/infra/services/image_crop_service.dart';
import '../layers/infra/services/image_picker_service.dart';
import '../layers/presentation/presenters/login/getx_login_presenter.dart';
import '../layers/presentation/presenters/signup/getx_signup_presenter.dart';
import '../layers/presentation/presenters/splash/getx_splash_presenter.dart';

class Injection {
  static final Injection _instance = Injection._();

  Injection._();

  factory Injection() {
    return _instance;
  }

  void setup() {
    //region Firebase
    Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut(() => FirebaseFirestore.instance, fenix: true);
    Get.lazyPut(() => FirebaseStorage.instance, fenix: true);
    //endregion

    //region Libraries
    Get.lazyPut(() => ImagePicker(), fenix: true);
    Get.lazyPut(() => ImageCropper(), fenix: true);
    //endregion

    //region DataSources
    Get.lazyPut(() => FirebaseStorageDataSource(firebaseStorage: Get.find<FirebaseStorage>()), fenix: true);
    Get.lazyPut(
      () => FirebaseUserAccountDataSource(
        firebaseAuth: Get.find<FirebaseAuth>(),
        firestore: Get.find<FirebaseFirestore>(),
        firebaseStorageDataSource: Get.find<FirebaseStorageDataSource>(),
      ),
      fenix: true,
    );
    //endregion

    //region Facades
    Get.lazyPut(() => ImagePickerFacade(imagePicker: Get.find<ImagePicker>()), fenix: true);
    Get.lazyPut(() => ImageCropperFacade(imageCropper: Get.find<ImageCropper>()), fenix: true);
    //endregion

    //region Repositories
    Get.lazyPut(() => UserAccountRepository(userAccountDataSource: Get.find<FirebaseUserAccountDataSource>()), fenix: true);
    //endregion

    //region Services
    Get.lazyPut(() => ImagePickerService(imagePickerFacade: Get.find<ImagePickerFacade>()), fenix: true);
    Get.lazyPut(() => ImageCropService(imageCropperFacade: Get.find<ImageCropperFacade>()), fenix: true);
    //endregion

    //region UseCases
    Get.lazyPut(() => LoginEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => SignUpEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(
      () => FetchImagePickerCamera(
        imagePickerService: Get.find<ImagePickerService>(),
        imageCropService: Get.find<ImageCropService>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => FetchImagePickerGallery(
        imagePickerService: Get.find<ImagePickerService>(),
        imageCropService: Get.find<ImageCropService>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => SendVerificationEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => CheckEmailVerified(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => GetUserLogged(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    //endregion

    //region Presenters
    Get.lazyPut(() => GetxLoginPresenter(loginWithEmail: Get.find<LoginEmail>()), fenix: true);
    Get.lazyPut(
      () => GetxSignupPresenter(
        signUpEmail: Get.find<SignUpEmail>(),
        fetchImagePickerCamera: Get.find<FetchImagePickerCamera>(),
        fetchImagePickerGallery: Get.find<FetchImagePickerGallery>(),
        sendVerificationEmail: Get.find<SendVerificationEmail>(),
        checkEmailVerified: Get.find<CheckEmailVerified>(),
        getUserLogged: Get.find<GetUserLogged>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxSplashPresenter(
        getUserLogged: Get.find<GetUserLogged>(),
        checkEmailVerified: Get.find<CheckEmailVerified>(),
        sendVerificationEmail: Get.find<SendVerificationEmail>(),
      ),
    );
    //endregion
  }
}
