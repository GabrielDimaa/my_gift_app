import '../../../helpers/interfaces/i_initialize.dart';
import '../../../helpers/interfaces/i_loading.dart';
import '../../../helpers/interfaces/i_view_model.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';

abstract class WishlistDetailsPresenter implements IViewModel<WishlistViewModel>, IInitialize<WishlistViewModel>, ILoading {
  Future<void> getWishes();
}