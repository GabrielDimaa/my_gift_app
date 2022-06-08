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
import '../layers/domain/usecases/implements/tag/get_tags.dart';
import '../layers/domain/usecases/implements/tag/save_tag.dart';
import '../layers/domain/usecases/implements/user/get_user_logged.dart';
import '../layers/domain/usecases/implements/wishlist/get_wishlists.dart';
import '../layers/domain/usecases/implements/wishlist/save_wishlist.dart';
import '../layers/infra/datasources/firebase_tag_datasource.dart';
import '../layers/infra/datasources/firebase_user_account_datasource.dart';
import '../layers/infra/datasources/firebase_wish_datasource.dart';
import '../layers/infra/datasources/firebase_wishlist_datasource.dart';
import '../layers/infra/datasources/storage/firebase_storage_datasource.dart';
import '../layers/infra/libraries/image_crop/image_cropper_facade.dart';
import '../layers/infra/libraries/image_picker/image_picker_facade.dart';
import '../layers/infra/repositories/tag_repository.dart';
import '../layers/infra/repositories/user_account_repository.dart';
import '../layers/infra/repositories/wish_repository.dart';
import '../layers/infra/repositories/wishlist_repository.dart';
import '../layers/infra/services/image_crop_service.dart';
import '../layers/infra/services/image_picker_service.dart';
import '../layers/presentation/presenters/login/getx_login_presenter.dart';
import '../layers/presentation/presenters/signup/getx_signup_presenter.dart';
import '../layers/presentation/presenters/splash/getx_splash_presenter.dart';
import '../layers/presentation/presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../layers/presentation/presenters/wishlist/implements/getx_wishlists_list_presenter.dart';

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
    Get.lazyPut(() => FirebaseWishlistDataSource(firestore: Get.find<FirebaseFirestore>()), fenix: true);
    Get.lazyPut(() => FirebaseTagDataSource(firestore: Get.find<FirebaseFirestore>()), fenix: true);
    Get.lazyPut(() => FirebaseWishDataSource(firestore: Get.find<FirebaseFirestore>()), fenix: true);
    //endregion

    //region Facades
    Get.lazyPut(() => ImagePickerFacade(imagePicker: Get.find<ImagePicker>()), fenix: true);
    Get.lazyPut(() => ImageCropperFacade(imageCropper: Get.find<ImageCropper>()), fenix: true);
    //endregion

    //region Repositories
    Get.lazyPut(() => UserAccountRepository(userAccountDataSource: Get.find<FirebaseUserAccountDataSource>()), fenix: true);
    Get.lazyPut(() => WishlistRepository(wishlistDataSource: Get.find<FirebaseWishlistDataSource>()), fenix: true);
    Get.lazyPut(() => WishRepository(wishDataSource: Get.find<FirebaseWishDataSource>()), fenix: true);
    Get.lazyPut(() => TagRepository(tagDataSource: Get.find<FirebaseTagDataSource>()), fenix: true);
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
    Get.lazyPut(() => GetWishlists(wishlistRepository: Get.find<WishlistRepository>()), fenix: true);
    Get.lazyPut(
      () => SaveWishlist(
        wishlistRepository: Get.find<WishlistRepository>(),
        wishRepository: Get.find<WishRepository>(),
      ),
      fenix: true,
    );
    Get.lazyPut(() => GetTags(tagRepository: Get.find<TagRepository>()), fenix: true);
    Get.lazyPut(() => SaveTag(tagRepository: Get.find<TagRepository>()), fenix: true);
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
    Get.lazyPut(() => GetxWishlistsFetchPresenter(getWishlists: Get.find<GetWishlists>()), fenix: true);
    Get.lazyPut(
      () => GetxWishlistRegisterPresenter(
        saveWishlist: Get.find<SaveWishlist>(),
        saveTag: Get.find<SaveTag>(),
        fetchTags: Get.find<GetTags>(),
      ),
      fenix: true,
    );
    //endregion
  }
}
