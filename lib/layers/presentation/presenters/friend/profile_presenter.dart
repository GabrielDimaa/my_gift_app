import '../../helpers/interfaces/i_initialize.dart';
import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';

abstract class ProfilePresenter implements IViewModel<UserViewModel>, IInitialize<UserViewModel>, ILoading {
  bool get verifyIsFriend;
  List<WishlistViewModel> get wishlists;

  Future<void> addFriend();
  Future<void> undoFriend();
  Future<void> verifyFriendShip();
  Future<void> getWishlists();
}