import 'dart:io';

import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wish_entity.dart';
import '../../../../domain/helpers/errors/domain_error.dart';
import '../../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_camera.dart';
import '../../../../domain/usecases/abstracts/image_picker/i_fetch_image_picker_gallery.dart';
import '../../../../domain/usecases/abstracts/wish/i_delete_wish.dart';
import '../../../../domain/usecases/abstracts/wish/i_save_wish.dart';
import '../../../helpers/enums/price_range.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../abstracts/wish_register_presenter.dart';

class GetxWishRegisterPresenter extends GetxController implements WishRegisterPresenter {
  final IFetchImagePickerCamera _fetchImagePickerCamera;
  final IFetchImagePickerGallery _fetchImagePickerGallery;
  final ISaveWish _saveWish;
  final IDeleteWish _deleteWish;

  GetxWishRegisterPresenter({
    required IFetchImagePickerCamera fetchImagePickerCamera,
    required IFetchImagePickerGallery fetchImagePickerGallery,
    required ISaveWish saveWish,
    required IDeleteWish deleteWish,
  })  : _fetchImagePickerCamera = fetchImagePickerCamera,
        _fetchImagePickerGallery = fetchImagePickerGallery,
        _saveWish = saveWish,
        _deleteWish = deleteWish;

  late WishViewModel _viewModel;
  late UserEntity _user;
  final Rx<PriceRange> _priceRange = Rx<PriceRange>(PriceRange.pr1_100);

  @override
  WishViewModel get viewModel => _viewModel;

  @override
  void setViewModel(WishViewModel value) => _viewModel = value;

  @override
  PriceRange get priceRangeSelected => _priceRange.value;

  @override
  void setPriceRange(PriceRange? value, {bool calculate = true}) {
    if (value != null && value != _priceRange.value) {
      final PriceRange priceRangeOld = _priceRange.value;
      _priceRange.value = value;

      if (calculate) {
        final double differenceOld = priceRangeOld.max - priceRangeOld.min;
        final double differenceNew = value.max - value.min;

        final double multiplierInitial = ((viewModel.priceRangeInitial ?? 0) - priceRangeOld.min) * 10 / differenceOld;
        final double multiplierFinal = ((viewModel.priceRangeFinal ?? 0) - priceRangeOld.max) * 10 / differenceOld;

        viewModel.setPriceRangeInitial(((differenceNew / 10) * multiplierInitial) + _priceRange.value.min);
        viewModel.setPriceRangeFinal(((differenceNew / 10) * multiplierFinal) + _priceRange.value.max);
      }
    }
  }

  @override
  void onInit() {
    setViewModel(WishViewModel());
    _user = UserGlobal().getUser()!;
    super.onInit();
  }

  @override
  Future<void> getFromCameraOrGallery({bool isGallery = true}) async {
    try {
      final File? image;
      if (isGallery) {
        image = await _fetchImagePickerGallery.fetchFromGallery();
      } else {
        image = await _fetchImagePickerCamera.fetchFromCamera();
      }

      if (image == null) throw Exception(R.string.noImageSelected);

      viewModel.setImage(image.path);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> save() async {
    try {
      final WishEntity wishSaved = await _saveWish.save(viewModel.toEntity(_user));
      setViewModel(WishViewModel.fromEntity(wishSaved));
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> delete() async {
    try {
      if (viewModel.id != null) await _deleteWish.delete(viewModel.id!);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  void validate({bool ignoreWishlistId = false}) {
    if (viewModel.description?.isEmpty ?? true) throw Exception(R.string.descriptionNotInformed);
    if (!ignoreWishlistId && viewModel.wishlistId == null) throw Exception(R.string.wishlistLinked);
    if (viewModel.priceRangeInitial == null) throw Exception(R.string.priceNotInformed);
  }
}
