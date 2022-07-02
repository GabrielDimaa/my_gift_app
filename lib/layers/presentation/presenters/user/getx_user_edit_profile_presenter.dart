import 'dart:io';

import 'package:get/get.dart';

import '../../../../i18n/resources.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_camera.dart';
import '../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_gallery.dart';
import '../../../domain/usecases/abstracts/user/i_get_user_account.dart';
import '../../../domain/usecases/abstracts/user/i_save_user_account.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'user_edit_profile_presenter.dart';

class GetxUserEditProfilePresenter extends GetxController with LoadingManager implements UserEditProfilePresenter {
  final IGetUserAccount _getUserAccount;
  final ISaveUserAccount _saveUserAccount;
  final IFetchImagePickerCamera _fetchImagePickerCamera;
  final IFetchImagePickerGallery _fetchImagePickerGallery;

  GetxUserEditProfilePresenter({
    required IGetUserAccount getUserAccount,
    required ISaveUserAccount saveUserAccount,
    required IFetchImagePickerCamera fetchImagePickerCamera,
    required IFetchImagePickerGallery fetchImagePickerGallery,
  })  : _getUserAccount = getUserAccount,
        _saveUserAccount = saveUserAccount,
        _fetchImagePickerCamera = fetchImagePickerCamera,
        _fetchImagePickerGallery = fetchImagePickerGallery;

  late UserViewModel _viewModel;

  @override
  UserViewModel get viewModel => _viewModel;

  @override
  void setViewModel(UserViewModel value) => _viewModel = value;

  @override
  Future<void> initialize([UserViewModel? viewModel]) async {
    try {
      setLoading(true);

      final UserEntity user = UserGlobal().getUser()!;
      setViewModel(UserViewModel.fromEntity(user));

      final UserViewModel userViewModel = await _getUser(user.id!);
      setViewModel(userViewModel);
    } on DomainError catch (e) {
      throw e.message;
    } finally {
      setLoading(false);
    }
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

      viewModel.setPhoto(image.path);
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> save() async {
    try {
      validate();

      final UserEntity user = _viewModel.toEntity();
      await _saveUserAccount.save(user);

      UserGlobal().setUser(user);
    } on DomainError catch (e) {
      throw e.message;
    }
  }

  @override
  void validate() {
    if (_viewModel.name.isEmpty) throw ValidationDomainError(message: R.string.nameNotInformedError);
    if (_viewModel.email.isEmpty) throw ValidationDomainError(message: R.string.emailNotInformedError);
  }

  Future<UserViewModel> _getUser(String userId) async {
    try {
      final UserEntity userEntity = await _getUserAccount.get(userId);
      return UserViewModel.fromEntity(userEntity);
    } on DomainError catch (e) {
      throw e.message;
    }
  }
}
