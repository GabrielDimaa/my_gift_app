import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../domain/entities/wish_entity.dart';
import '../../../../domain/helpers/errors/domain_error.dart';
import '../../../../domain/usecases/abstracts/wish/i_get_wishes.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../abstracts/wishlist_details_presenter.dart';

class GetxWishlistDetailsPresenter extends GetxController with LoadingManager implements WishlistDetailsPresenter {
  final IGetWishes _getWishes;

  GetxWishlistDetailsPresenter({required IGetWishes getWishes}) : _getWishes = getWishes;

  final Rx<WishlistViewModel> _viewModel = Rx<WishlistViewModel>(WishlistViewModel());

  @override
  WishlistViewModel get viewModel => _viewModel.value;

  @override
  void setViewModel(WishlistViewModel value) => _viewModel.value = value;

  @override
  Future<void> initialize([WishlistViewModel? viewModel]) async {
    try {
      setLoading(true);

      if (viewModel == null) throw Exception(R.string.unexpectedError);
      setViewModel(viewModel);

      await getWishes();
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> getWishes() async {
    try {
      final List<WishEntity> wishesEntity = await _getWishes.get(viewModel.id!);
      viewModel.setWishes(wishesEntity.map((e) => WishViewModel.fromEntity(e)).toList());

      viewModel.wishes.sort((a, b) => a.description.toString().toLowerCase().compareTo(b.description.toString().toLowerCase()));
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }
}
