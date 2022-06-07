import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';

abstract class WishlistRegisterPresenter {
  WishlistViewModel get viewModel;
  void setViewModel(WishlistViewModel value);

  List<TagViewModel> get tagsViewModel;

  Future<void> save();
  Future<void> loadTags();
  Future<void> createTag(TagViewModel viewModel);
}
