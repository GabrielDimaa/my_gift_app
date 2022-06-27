import 'package:get/get.dart';

import '../../../../i18n/resources.dart';
import '../../../../monostates/user_global.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/wishlist_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/helpers/params/friend_params.dart';
import '../../../domain/usecases/abstracts/friend/i_add_friend.dart';
import '../../../domain/usecases/abstracts/friend/i_undo_friend.dart';
import '../../../domain/usecases/abstracts/friend/i_verify_friendship.dart';
import '../../../domain/usecases/abstracts/wishlist/i_get_wishlists.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../viewmodels/wishlist_viewmodel.dart';
import 'profile_presenter.dart';

class GetxProfilePresenter extends GetxController with LoadingManager implements ProfilePresenter {
  final IAddFriend _addFriend;
  final IUndoFriend _undoFriend;
  final IVerifyFriendship _verifyFriendShip;
  final IGetWishlists _getWishlists;

  GetxProfilePresenter({
    required IAddFriend addFriend,
    required IUndoFriend undoFriend,
    required IVerifyFriendship verifyFriendShip,
    required IGetWishlists getWishlists,
  })  : _addFriend = addFriend,
        _undoFriend = undoFriend,
        _verifyFriendShip = verifyFriendShip,
        _getWishlists = getWishlists;

  late UserViewModel _viewModel;
  late UserEntity _user;

  final RxBool _verifyIsFriend = RxBool(false);
  final RxList<WishlistViewModel> _wishlists = RxList<WishlistViewModel>();

  @override
  UserViewModel get viewModel => _viewModel;

  @override
  void setViewModel(UserViewModel value) => _viewModel = value;

  @override
  bool get verifyIsFriend => _verifyIsFriend.value;

  @override
  List<WishlistViewModel> get wishlists => _wishlists;

  @override
  Future<void> initialize([UserViewModel? viewModel]) async {
    try {
      setLoading(true);

      if (viewModel == null) throw UnexpectedDomainError(R.string.unexpectedError);

      _viewModel = viewModel;
      _user = UserGlobal().getUser()!;

      await getWishlists();
      await verifyFriendShip();
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> addFriend() async {
    try {
      final FriendParams params = FriendParams(userId: _user.id!, friendUserId: _viewModel.id);
      await _addFriend.add(params);

      _verifyIsFriend.value = true;
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> undoFriend() async {
    try {
      final FriendParams params = FriendParams(userId: _user.id!, friendUserId: _viewModel.id);
      await _undoFriend.undo(params);

      _verifyIsFriend.value = false;
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> verifyFriendShip() async {
    try {
      final FriendParams params = FriendParams(userId: _user.id!, friendUserId: _viewModel.id);
      _verifyIsFriend.value = await _verifyFriendShip.verify(params);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> getWishlists() async {
    try {
      final List<WishlistEntity> wishlistsEntity = await _getWishlists.get(_viewModel.id);
      _wishlists.value = wishlistsEntity.map((e) => WishlistViewModel.fromEntity(e)).toList();
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }
}
