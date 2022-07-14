import '../../helpers/enums/price_range.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/wish_viewmodel.dart';

abstract class WishRegisterPresenter implements IViewModel<WishViewModel> {
  bool get hasChanged;
  void setHasChanged(bool value);

  PriceRange get priceRangeSelected;
  void setPriceRange(PriceRange? value, {bool calculate = true});

  Future<void> getFromCameraOrGallery({bool isGallery = true});
  Future<void> save();
  Future<void> delete();
  void validate({bool ignoreWishlistId});
}
