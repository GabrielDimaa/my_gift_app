import '../../../helpers/interfaces/i_loading.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';

abstract class WishlistDetailsPresenter implements IViewModel<WishlistViewModel>, ILoading {
  Future<void> load(WishlistViewModel viewModel);
  Future<void> getWishes();
}