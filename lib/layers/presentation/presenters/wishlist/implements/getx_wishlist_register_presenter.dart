import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/tag_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wish_entity.dart';
import '../../../../domain/entities/wishlist_entity.dart';
import '../../../../domain/enums/tag_internal.dart';
import '../../../../domain/helpers/errors/domain_error.dart';
import '../../../../domain/usecases/abstracts/tag/i_get_tags.dart';
import '../../../../domain/usecases/abstracts/tag/i_save_tag.dart';
import '../../../../domain/usecases/abstracts/wish/i_delete_wish.dart';
import '../../../../domain/usecases/abstracts/wish/i_get_wishes.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_save_wishlist.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wish_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../abstracts/wishlist_register_presenter.dart';

class GetxWishlistRegisterPresenter extends GetxController with LoadingManager implements WishlistRegisterPresenter {
  final ISaveWishlist saveWishlist;
  final IDeleteWish iDeleteWish;
  final ISaveTag saveTag;
  final IGetTags fetchTags;
  final IGetWishes getWishes;

  GetxWishlistRegisterPresenter({
    required this.saveWishlist,
    required this.iDeleteWish,
    required this.saveTag,
    required this.fetchTags,
    required this.getWishes,
  });

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
  Future<void> init(WishlistViewModel? viewModel) async {
    try {
      setLoading(true);

      if (viewModel?.id != null) {
        setViewModel(viewModel!);
        await fetchWishes();
      }

      await loadTags();
    } finally {
      setLoading(false);
      super.onInit();
    }
  }

  @override
  Future<void> onInit() async {
    setViewModel(WishlistViewModel());
    _tagsViewModel = <TagViewModel>[].obs;
    _user = UserGlobal().getUser()!;
    super.onInit();
  }

  @override
  Future<void> save() async {
    try {
      validate();

      final WishlistEntity wishlistEntity = await saveWishlist.save(_viewModel.toEntity(_user));
      navigateToWishlists(WishlistViewModel.fromEntity(wishlistEntity));
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  void validate() {
    if (_viewModel.description?.isEmpty ?? true) throw ValidationDomainError(message: R.string.descriptionNotInformed);
    if (_viewModel.tag == null) throw ValidationDomainError(message: R.string.tagNotInformed);
  }

  @override
  Future<void> fetchWishes() async {
    if (viewModel.id != null) {
      final List<WishEntity> wishesEntity = await getWishes.get(viewModel.id!);
      viewModel.setWishes(wishesEntity.map((e) => WishViewModel.fromEntity(e)).toList());

      viewModel.wishes.sort((a, b) => a.description.toString().toLowerCase().compareTo(b.description.toString().toLowerCase()));
    }
  }

  @override
  Future<void> deleteWish(WishViewModel wish) async {
    if (wish.id != null) await iDeleteWish.delete(wish.id!);
  }

  @override
  Future<void> loadTags() async {
    _tagsViewModel = <TagViewModel>[].obs;

    TagViewModel tagInitial = TagViewModel.fromEntity(TagInternal.normal.toEntity(_user));
    _tagsViewModel.add(tagInitial);
    if (viewModel.tag == null) viewModel.setTag(tagInitial);

    List<TagEntity> tags = await fetchTags.get(_user.id!);
    _tagsViewModel.addAll(tags.map((entity) => TagViewModel.fromEntity(entity)).toList().obs);

    _tagsViewModel.sort((a, b) => a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase()));
  }

  @override
  Future<void> createTag(TagViewModel viewModel) async {
    if (viewModel.name == null || viewModel.color == null) throw Exception(R.string.nameColorTagError);

    final TagEntity tagEntity = await saveTag.save(viewModel.toEntity(_user));
    tagsViewModel.add(TagViewModel.fromEntity(tagEntity));
  }

  @override
  void navigateToWishlists(WishlistViewModel viewModel) => Get.back(result: viewModel);
}
