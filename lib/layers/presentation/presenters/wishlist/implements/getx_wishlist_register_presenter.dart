import 'package:get/get.dart';

import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/tag_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wish_entity.dart';
import '../../../../domain/entities/wishlist_entity.dart';
import '../../../../domain/enums/tag_internal.dart';
import '../../../../domain/usecases/abstracts/tag/i_get_tags.dart';
import '../../../../domain/usecases/abstracts/tag/i_save_tag.dart';
import '../../../../domain/usecases/abstracts/wish/i_delete_wish.dart';
import '../../../../domain/usecases/abstracts/wish/i_get_wishes.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_delete_wishlist.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_save_wishlist.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../abstracts/wishlist_register_presenter.dart';

class GetxWishlistRegisterPresenter extends GetxController with LoadingManager implements WishlistRegisterPresenter {
  final ISaveWishlist _saveWishlist;
  final IDeleteWishlist _deleteWishlist;
  final IDeleteWish _deleteWish;
  final ISaveTag _saveTag;
  final IGetTags _getTags;
  final IGetWishes _getWishes;

  GetxWishlistRegisterPresenter({
    required ISaveWishlist saveWishlist,
    required IDeleteWishlist deleteWishlist,
    required IDeleteWish deleteWish,
    required ISaveTag saveTag,
    required IGetTags getTags,
    required IGetWishes getWishes,
  })  : _saveWishlist = saveWishlist,
        _deleteWishlist = deleteWishlist,
        _deleteWish = deleteWish,
        _saveTag = saveTag,
        _getTags = getTags,
        _getWishes = getWishes;

  late WishlistViewModel _viewModel;
  late RxList<TagViewModel> _tagsViewModel;
  late UserEntity _user;

  @override
  WishlistViewModel get viewModel => _viewModel;

  @override
  void setViewModel(WishlistViewModel value) => _viewModel = value;

  @override
  List<TagViewModel> get tagsViewModel => _tagsViewModel;

  @override
  Future<void> initialize([WishlistViewModel? viewModel]) async {
    try {
      setLoading(true);

      setViewModel(WishlistViewModel());
      _tagsViewModel = <TagViewModel>[].obs;
      _user = UserGlobal().getUser()!;

      if (viewModel?.id != null) {
        setViewModel(viewModel!);
        await fetchWishes();
      }

      await loadTags();
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> save() async {
    validate();

    final WishlistEntity wishlistEntity = await _saveWishlist.save(_viewModel.toEntity(_user));
    setViewModel(WishlistViewModel.fromEntity(wishlistEntity));
  }

  @override
  Future<void> delete() async {
    if (viewModel.id != null) await _deleteWishlist.delete(viewModel.id!);
  }

  @override
  void validate() {
    if (_viewModel.description?.isEmpty ?? true) throw StandardError(R.string.descriptionNotInformed);
    if (_viewModel.tag == null) throw StandardError(R.string.tagNotInformed);
  }

  @override
  Future<void> fetchWishes() async {
    if (viewModel.id != null) {
      final List<WishEntity> wishesEntity = await _getWishes.get(viewModel.id!);
      viewModel.setWishes(wishesEntity.map((e) => WishViewModel.fromEntity(e)).toList());

      viewModel.wishes.sort((a, b) => a.description.toString().toLowerCase().compareTo(b.description.toString().toLowerCase()));
    }
  }

  @override
  Future<void> deleteWish(WishViewModel wish) async {
    if (wish.id != null) await _deleteWish.delete(wish.id!);
  }

  @override
  Future<void> loadTags() async {
    _tagsViewModel = <TagViewModel>[].obs;

    TagViewModel tagInitial = TagViewModel.fromEntity(TagInternal.normal.toEntity(_user));
    _tagsViewModel.add(tagInitial);
    if (viewModel.tag == null) viewModel.setTag(tagInitial);

    List<TagEntity> tags = await _getTags.get(_user.id!);
    _tagsViewModel.addAll(tags.map((entity) => TagViewModel.fromEntity(entity)).toList().obs);

    _tagsViewModel.sort((a, b) => a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase()));
  }

  @override
  Future<void> createTag(TagViewModel viewModel) async {
    if (viewModel.name == null || viewModel.color == null) throw Exception(R.string.nameColorTagError);

    final TagEntity tagEntity = await _saveTag.save(viewModel.toEntity(_user));
    tagsViewModel.add(TagViewModel.fromEntity(tagEntity));
  }
}
