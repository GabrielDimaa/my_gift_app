import 'package:get/get.dart';

import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wishlist_entity.dart';
import '../../../../domain/helpers/errors/domain_error.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_get_wishlists.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../../viewmodels/wishlists_viewmodel.dart';
import '../abstracts/wishlists_fetch_presenter.dart';

class GetxWishlistsFetchPresenter extends GetxController with LoadingManager implements WishlistsFetchPresenter {
  final IGetWishlists _getWishlists;

  GetxWishlistsFetchPresenter({required IGetWishlists getWishlists}) : _getWishlists = getWishlists;

  late WishlistsViewModel _viewModel;
  late UserEntity _userLogged;

  @override
  WishlistsViewModel get viewModel => _viewModel;

  @override
  void setViewModel(WishlistsViewModel value) => _viewModel = value;

  @override
  Future<void> initialize([WishlistsViewModel? viewModel]) async {
    try {
      setLoading(true);

      setViewModel(WishlistsViewModel());
      _userLogged = UserGlobal().getUser()!;
      await fetchWishlists();
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> fetchWishlists() async {
    try {
      List<WishlistEntity> wishlistsEntities = await _getWishlists.get(_userLogged.id!);
      List<WishlistViewModel> wishlistsViewModel = wishlistsEntities.map((entity) => WishlistViewModel.fromEntity(entity)).toList();

      _viewModel.setWishlists(wishlistsViewModel);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }
}
