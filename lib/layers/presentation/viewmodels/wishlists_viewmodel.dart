import 'package:get/get.dart';

import 'wishlist_viewmodel.dart';

class WishlistsViewModel {
  final RxList<WishlistViewModel> _wishlists = RxList<WishlistViewModel>();

  List<WishlistViewModel> get wishlists => _wishlists;

  void setWishlists(List<WishlistViewModel> value) => _wishlists.value = value;
}
