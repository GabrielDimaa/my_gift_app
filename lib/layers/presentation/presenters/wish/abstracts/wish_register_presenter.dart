import '../../../helpers/enums/price_range.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/wish_viewmodel.dart';

abstract class WishRegisterPresenter implements IViewModel<WishViewModel> {
  PriceRange get priceRangeSelected;
  void setPriceRange(PriceRange? value);

  Future<void> getFromCameraOrGallery({bool isGallery = true});
  Future<void> save();
  void validate({bool ignoreWishlistId});
}
