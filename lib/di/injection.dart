import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../layers/domain/usecases/implements/config/get_theme.dart';
import '../layers/domain/usecases/implements/config/save_theme.dart';
import '../layers/domain/usecases/implements/friend/add_friend.dart';
import '../layers/domain/usecases/implements/friend/fetch_search_persons.dart';
import '../layers/domain/usecases/implements/friend/get_friends.dart';
import '../layers/domain/usecases/implements/friend/undo_friend.dart';
import '../layers/domain/usecases/implements/friend/verify_friendship.dart';
import '../layers/domain/usecases/implements/image_picker/fetch_image_picker_camera.dart';
import '../layers/domain/usecases/implements/image_picker/fetch_image_picker_gallery.dart';
import '../layers/domain/usecases/implements/login/login_email.dart';
import '../layers/domain/usecases/implements/login/login_google.dart';
import '../layers/domain/usecases/implements/logout/logout.dart';
import '../layers/domain/usecases/implements/signup/check_email_verified.dart';
import '../layers/domain/usecases/implements/signup/send_verification_email.dart';
import '../layers/domain/usecases/implements/signup/signup_email.dart';
import '../layers/domain/usecases/implements/tag/delete_tag.dart';
import '../layers/domain/usecases/implements/tag/get_tags.dart';
import '../layers/domain/usecases/implements/tag/save_tag.dart';
import '../layers/domain/usecases/implements/user/get_user_account.dart';
import '../layers/domain/usecases/implements/user/get_user_logged.dart';
import '../layers/domain/usecases/implements/user/save_user_account.dart';
import '../layers/domain/usecases/implements/user/send_code_update_password.dart';
import '../layers/domain/usecases/implements/user/update_password.dart';
import '../layers/domain/usecases/implements/wish/delete_wish.dart';
import '../layers/domain/usecases/implements/wish/get_wishes.dart';
import '../layers/domain/usecases/implements/wish/save_wish.dart';
import '../layers/domain/usecases/implements/wishlist/delete_wishlist.dart';
import '../layers/domain/usecases/implements/wishlist/get_wishlists.dart';
import '../layers/domain/usecases/implements/wishlist/save_wishlist.dart';
import '../layers/infra/datasources/firebase/firebase_friend_datasource.dart';
import '../layers/infra/datasources/firebase/firebase_tag_datasource.dart';
import '../layers/infra/datasources/firebase/firebase_user_account_datasource.dart';
import '../layers/infra/datasources/firebase/firebase_wish_datasource.dart';
import '../layers/infra/datasources/firebase/firebase_wishlist_datasource.dart';
import '../layers/infra/datasources/firebase/storage/firebase_storage_datasource.dart';
import '../layers/infra/datasources/shared_preferences/shared_preferences_config_datasource.dart';
import '../layers/infra/libraries/image_crop/image_cropper_facade.dart';
import '../layers/infra/libraries/image_picker/image_picker_facade.dart';
import '../layers/infra/repositories/config_repository.dart';
import '../layers/infra/repositories/friend_repository.dart';
import '../layers/infra/repositories/tag_repository.dart';
import '../layers/infra/repositories/user_account_repository.dart';
import '../layers/infra/repositories/wish_repository.dart';
import '../layers/infra/repositories/wishlist_repository.dart';
import '../layers/infra/services/image_crop_service.dart';
import '../layers/infra/services/image_picker_service.dart';
import '../layers/presentation/presenters/config/getx_config_presenter.dart';
import '../layers/presentation/presenters/friend/getx_friends_presenter.dart';
import '../layers/presentation/presenters/friend/getx_profile_presenter.dart';
import '../layers/presentation/presenters/login/getx_login_presenter.dart';
import '../layers/presentation/presenters/signup/getx_signup_presenter.dart';
import '../layers/presentation/presenters/splash/getx_splash_presenter.dart';
import '../layers/presentation/presenters/tag/getx_tags_fetch_presenter.dart';
import '../layers/presentation/presenters/user/getx_reset_password_presenter.dart';
import '../layers/presentation/presenters/user/getx_user_edit_profile_presenter.dart';
import '../layers/presentation/presenters/wish/getx_wish_register_presenter.dart';
import '../layers/presentation/presenters/wishlist/implements/getx_wishlist_details_presenter.dart';
import '../layers/presentation/presenters/wishlist/implements/getx_wishlist_register_presenter.dart';
import '../layers/presentation/presenters/wishlist/implements/getx_wishlists_fetch_presenter.dart';

class Injection {
  static final Injection _instance = Injection._();

  Injection._();

  factory Injection() {
    return _instance;
  }

  Future<void> setup() async {
    //region Firebase
    Get.lazyPut(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut(() => FirebaseFirestore.instance, fenix: true);
    Get.lazyPut(() => FirebaseStorage.instance, fenix: true);
    //endregion

    //region Libraries
    Get.lazyPut(() => ImagePicker(), fenix: true);
    Get.lazyPut(() => ImageCropper(), fenix: true);
    Get.lazyPut(() => GoogleSignIn(), fenix: true);
    await Get.putAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
    //endregion

    //region DataSources
    Get.lazyPut(() => FirebaseStorageDataSource(firebaseStorage: Get.find<FirebaseStorage>()), fenix: true);
    Get.lazyPut(
      () => FirebaseUserAccountDataSource(
        firebaseAuth: Get.find<FirebaseAuth>(),
        firestore: Get.find<FirebaseFirestore>(),
        firebaseStorageDataSource: Get.find<FirebaseStorageDataSource>(),
        googleSignIn: Get.find<GoogleSignIn>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => FirebaseWishlistDataSource(
        firestore: Get.find<FirebaseFirestore>(),
        storage: Get.find<FirebaseStorageDataSource>(),
        userDataSource: Get.find<FirebaseUserAccountDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => FirebaseTagDataSource(
        firestore: Get.find<FirebaseFirestore>(),
        userDataSource: Get.find<FirebaseUserAccountDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => FirebaseWishDataSource(
        firestore: Get.find<FirebaseFirestore>(),
        userDataSource: Get.find<FirebaseUserAccountDataSource>(),
        storageDataSource: Get.find<FirebaseStorageDataSource>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => FirebaseFriendDataSource(
        firestore: Get.find<FirebaseFirestore>(),
        userDataSource: Get.find<FirebaseUserAccountDataSource>(),
      ),
      fenix: true,
    );

    Get.lazyPut(() => SharedPreferencesConfigDataSource(sharedPreferences: Get.find<SharedPreferences>()), fenix: true);
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
    Get.lazyPut(() => FriendRepository(friendDataSource: Get.find<FirebaseFriendDataSource>()), fenix: true);
    Get.lazyPut(() => ConfigRepository(configDataSource: Get.find<SharedPreferencesConfigDataSource>()), fenix: true);
    //endregion

    //region Services
    Get.lazyPut(() => ImagePickerService(imagePickerFacade: Get.find<ImagePickerFacade>()), fenix: true);
    Get.lazyPut(() => ImageCropService(imageCropperFacade: Get.find<ImageCropperFacade>()), fenix: true);
    //endregion

    //region UseCases
    Get.lazyPut(() => LoginEmail(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => LoginGoogle(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => Logout(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
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
    Get.lazyPut(() => SaveWishlist(wishlistRepository: Get.find<WishlistRepository>()), fenix: true);
    Get.lazyPut(() => DeleteWishlist(wishlistRepository: Get.find<WishlistRepository>()), fenix: true);
    Get.lazyPut(() => GetWishes(wishRepository: Get.find<WishRepository>()), fenix: true);
    Get.lazyPut(() => SaveWish(wishRepository: Get.find<WishRepository>()), fenix: true);
    Get.lazyPut(() => DeleteWish(wishRepository: Get.find<WishRepository>()), fenix: true);
    Get.lazyPut(() => GetTags(tagRepository: Get.find<TagRepository>()), fenix: true);
    Get.lazyPut(() => SaveTag(tagRepository: Get.find<TagRepository>()), fenix: true);
    Get.lazyPut(() => DeleteTag(tagRepository: Get.find<TagRepository>()), fenix: true);
    Get.lazyPut(() => GetFriends(friendRepository: Get.find<FriendRepository>()), fenix: true);
    Get.lazyPut(() => UndoFriend(friendRepository: Get.find<FriendRepository>()), fenix: true);
    Get.lazyPut(() => AddFriend(friendRepository: Get.find<FriendRepository>()), fenix: true);
    Get.lazyPut(() => FetchSearchPersons(friendRepository: Get.find<FriendRepository>()), fenix: true);
    Get.lazyPut(() => VerifyFriendship(friendRepository: Get.find<FriendRepository>()), fenix: true);
    Get.lazyPut(() => SaveTheme(configRepository: Get.find<ConfigRepository>()), fenix: true);
    Get.lazyPut(() => GetTheme(configRepository: Get.find<ConfigRepository>()), fenix: true);
    Get.lazyPut(() => GetUserAccount(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => SaveUserAccount(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => UpdatePassword(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    Get.lazyPut(() => SendCodeUpdatePassword(userAccountRepository: Get.find<UserAccountRepository>()), fenix: true);
    //endregion

    //region Presenters
    Get.lazyPut(
      () => GetxLoginPresenter(
        loginWithEmail: Get.find<LoginEmail>(),
        loginWithGoogle: Get.find<LoginGoogle>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxConfigPresenter(
        logout: Get.find<Logout>(),
        getTheme: Get.find<GetTheme>(),
        saveTheme: Get.find<SaveTheme>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxSignupPresenter(
        signUpEmail: Get.find<SignUpEmail>(),
        fetchImagePickerCamera: Get.find<FetchImagePickerCamera>(),
        fetchImagePickerGallery: Get.find<FetchImagePickerGallery>(),
        sendVerificationEmail: Get.find<SendVerificationEmail>(),
        checkEmailVerified: Get.find<CheckEmailVerified>(),
        getUserLogged: Get.find<GetUserLogged>(),
        loginWithGoogle: Get.find<LoginGoogle>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxSplashPresenter(
        getUserLogged: Get.find<GetUserLogged>(),
        checkEmailVerified: Get.find<CheckEmailVerified>(),
        sendVerificationEmail: Get.find<SendVerificationEmail>(),
        getTheme: Get.find<GetTheme>(),
      ),
    );
    Get.lazyPut(() => GetxWishlistsFetchPresenter(getWishlists: Get.find<GetWishlists>()), fenix: true);
    Get.lazyPut(
      () => GetxWishlistRegisterPresenter(
        saveWishlist: Get.find<SaveWishlist>(),
        deleteWishlist: Get.find<DeleteWishlist>(),
        deleteWish: Get.find<DeleteWish>(),
        saveTag: Get.find<SaveTag>(),
        getTags: Get.find<GetTags>(),
        getWishes: Get.find<GetWishes>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxWishRegisterPresenter(
          fetchImagePickerCamera: Get.find<FetchImagePickerCamera>(), fetchImagePickerGallery: Get.find<FetchImagePickerGallery>(), saveWish: Get.find<SaveWish>(), deleteWish: Get.find<DeleteWish>()),
      fenix: true,
    );
    Get.lazyPut(() => GetxWishlistDetailsPresenter(getWishes: Get.find<GetWishes>()), fenix: true);
    Get.lazyPut(
      () => GetxFriendsPresenter(
        getFriends: Get.find<GetFriends>(),
        undoFriend: Get.find<UndoFriend>(),
        addFriend: Get.find<AddFriend>(),
        fetchSearchPersons: Get.find<FetchSearchPersons>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxProfilePresenter(
        addFriend: Get.find<AddFriend>(),
        undoFriend: Get.find<UndoFriend>(),
        verifyFriendShip: Get.find<VerifyFriendship>(),
        getWishlists: Get.find<GetWishlists>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxUserEditProfilePresenter(
        getUserAccount: Get.find<GetUserAccount>(),
        saveUserAccount: Get.find<SaveUserAccount>(),
        fetchImagePickerCamera: Get.find<FetchImagePickerCamera>(),
        fetchImagePickerGallery: Get.find<FetchImagePickerGallery>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxResetPasswordPresenter(
        updatePassword: Get.find<UpdatePassword>(),
        sendCodeUpdatePassword: Get.find<SendCodeUpdatePassword>(),
      ),
      fenix: true,
    );
    Get.lazyPut(
      () => GetxTagsFetchPresenter(
        getTags: Get.find<GetTags>(),
        saveTag: Get.find<SaveTag>(),
        deleteTag: Get.find<DeleteTag>(),
      ),
      fenix: true,
    );
    //endregion
  }
}
