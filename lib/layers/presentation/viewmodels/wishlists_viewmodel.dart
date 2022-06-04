import 'package:get/get.dart';

import 'wishlist_viewmodel.dart';

class WishlistsViewModel {
  RxList<WishlistViewModel> wishlists = RxList<WishlistViewModel>();

  void setWishlists(List<WishlistViewModel>? value) => wishlists.value = value ?? [];
}
