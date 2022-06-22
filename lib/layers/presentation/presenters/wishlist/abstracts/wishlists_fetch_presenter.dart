import '../../../helpers/interfaces/i_initialize.dart';
import '../../../helpers/interfaces/i_loading.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/wishlists_viewmodel.dart';

abstract class WishlistsFetchPresenter implements IViewModel<WishlistsViewModel>, IInitialize<WishlistsViewModel>, ILoading {
  Future<void> fetchWishlists();
}
