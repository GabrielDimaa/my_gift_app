import '../../../helpers/interfaces/i_loading.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';

abstract class WishlistRegisterPresenter implements IViewModel<WishlistViewModel>, ILoading {
  List<TagViewModel> get tagsViewModel;

  Future<void> init(WishlistViewModel? viewModel);

  Future<void> save();
  void validate();
  Future<void> fetchWishes();
  Future<void> deleteWish(WishViewModel wish);
  Future<void> loadTags();
  Future<void> createTag(TagViewModel viewModel);
  void navigateToWishlists(WishlistViewModel viewModel);
}
