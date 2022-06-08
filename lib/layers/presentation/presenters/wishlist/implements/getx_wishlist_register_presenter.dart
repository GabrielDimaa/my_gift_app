import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../../../monostates/user_global.dart';
import '../../../../domain/entities/tag_entity.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/entities/wishlist_entity.dart';
import '../../../../domain/enums/tag_internal.dart';
import '../../../../domain/helpers/errors/domain_error.dart';
import '../../../../domain/usecases/abstracts/tag/i_get_tags.dart';
import '../../../../domain/usecases/abstracts/tag/i_save_tag.dart';
import '../../../../domain/usecases/abstracts/wishlist/i_save_wishlist.dart';
import '../../../helpers/mixins/loading_manager.dart';
import '../../../viewmodels/tag_viewmodel.dart';
import '../../../viewmodels/wishlist_viewmodel.dart';
import '../abstracts/wishlist_register_presenter.dart';

class GetxWishlistRegisterPresenter extends GetxController with LoadingManager implements WishlistRegisterPresenter {
  final ISaveWishlist saveWishlist;
  final ISaveTag saveTag;
  final IGetTags fetchTags;

  GetxWishlistRegisterPresenter({required this.saveWishlist, required this.saveTag, required this.fetchTags});

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
  Future<void> onInit() async {
    try {
      setLoading(true);

      setViewModel(WishlistViewModel());
      _tagsViewModel = <TagViewModel>[].obs;
      _user = UserGlobal().getUser()!;

      await loadTags();
    } finally {
      setLoading(false);
      super.onInit();
    }
  }

  @override
  Future<void> save() async {
    try {
      validate();

      final WishlistEntity wishlistEntity = await saveWishlist.save(_viewModel.toEntity());
      navigateToWishlists(WishlistViewModel.fromEntity(wishlistEntity));
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  void validate() {
    if (_viewModel.description?.isEmpty ?? true) throw ValidationDomainError(message: R.string.descriptionWishlistNotInformed);
    if (_viewModel.tag == null) throw ValidationDomainError(message: R.string.tagNotInformed);
  }

  @override
  Future<void> loadTags() async {
    _tagsViewModel = <TagViewModel>[].obs;

    TagViewModel tagInitial = TagViewModel.fromEntity(TagInternal.normal.toEntity());
    _tagsViewModel.add(tagInitial);
    viewModel.setTag(tagInitial);

    List<TagEntity> tags = await fetchTags.get(_user.id!);
    _tagsViewModel.addAll(tags.map((entity) => TagViewModel.fromEntity(entity)).toList().obs);
  }

  @override
  Future<void> createTag(TagViewModel viewModel) async {
    try {
      setLoading(true);

      if (viewModel.name == null || viewModel.color == null) throw Exception(R.string.nameColorTagError);

      final TagEntity tagEntity = await saveTag.save(viewModel.toEntity());
      tagsViewModel.add(TagViewModel.fromEntity(tagEntity));
    } finally {
      setLoading(false);
    }
  }

  @override
  void navigateToWishlists(WishlistViewModel viewModel) => Get.back(result: viewModel);
}
