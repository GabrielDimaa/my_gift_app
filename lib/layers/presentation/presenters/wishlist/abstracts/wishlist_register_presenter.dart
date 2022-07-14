import '../../../helpers/interfaces/i_initialize.dart';
import '../../../helpers/interfaces/i_loading.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';

abstract class WishlistRegisterPresenter implements IViewModel<WishlistViewModel>, IInitialize<WishlistViewModel>, ILoading {
  bool get hasChanged;
  void setHasChanged(bool value);

  List<TagViewModel> get tagsViewModel;

  Future<void> save();
  Future<void> delete();
  void validate();
  Future<void> fetchWishes();
  Future<void> deleteWish(WishViewModel wish);
  Future<void> loadTags();
  Future<void> createTag(TagViewModel viewModel);
}
