import '../../../viewmodels/wishlists_viewmodel.dart';

abstract class WishlistsFetchPresenter {
  WishlistsViewModel get viewModel;
  Future<void> fetchWishlists();
}