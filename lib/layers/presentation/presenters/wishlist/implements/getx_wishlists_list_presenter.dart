import 'package:get/get.dart';

import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wishlist_entity.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_get_wishlists.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../../../viewmodels/wishlists_viewmodel.dart';
import '../abstracts/wishlists_fetch_presenter.dart';

class GetxWishlistsFetchPresenter extends GetxController with LoadingManager implements WishlistsFetchPresenter {
  late WishlistsViewModel _viewModel;
  late UserEntity _userLogged;
  final IGetWishlists getWishlists;

  GetxWishlistsFetchPresenter({required this.getWishlists});

  @override
  WishlistsViewModel get viewModel => _viewModel;

  @override
  Future<void> onInit() async {
    try {
      setLoading(true);

      _viewModel = WishlistsViewModel();
      _userLogged = UserGlobal().getUser()!;
      await fetchWishlists();

      super.onInit();
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> fetchWishlists() async {
    List<WishlistEntity> wishlistsEntities = await getWishlists.get(_userLogged.id!);
    List<WishlistViewModel> wishlistsViewModel = wishlistsEntities.map((entity) => WishlistViewModel.fromEntity(entity)).toList();

    _viewModel.setWishlists(wishlistsViewModel);
  }
}
