import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../monostates/user_global.dart';
import '../../../domain/entities/friends_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/helpers/params/friend_params.dart';
import '../../../domain/usecases/abstracts/friend/i_get_friends.dart';
import '../../../domain/usecases/abstracts/friend/i_undo_friend.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/friends_viewmodel.dart';
import 'friends_presenter.dart';

class GetxFriendsPresenter extends GetxController with LoadingManager implements FriendsPresenter {
  final IGetFriends _getFriends;
  final IUndoFriend _undoFriend;

  GetxFriendsPresenter({
    required IGetFriends getFriends,
    required IUndoFriend undoFriend,
  })  : _getFriends = getFriends,
        _undoFriend = undoFriend;

  late FriendsViewModel _viewModel;
  late UserEntity _user;

  @override
  FriendsViewModel get viewModel => _viewModel;

  @override
  void setViewModel(FriendsViewModel value) => _viewModel = value;

  @override
  Future<void> initialize([FriendsViewModel? viewModel]) async {
    try {
      setLoading(true);

      setViewModel(FriendsViewModel(friends: []));
      _user = UserGlobal().getUser()!;

      await getFriends();
    } on DomainError catch (e) {
      throw Exception(e.message);
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<void> getFriends() async {
    try {
      final FriendsEntity friends = await _getFriends.get(_user.id!);
      _viewModel.setFriends(FriendsViewModel.fromEntity(friends).friends);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<void> undoFriend(String friendUserId) async {
    try {
      final FriendParams params = FriendParams(userId: _user.id!, friendUserId: friendUserId);
      await _undoFriend.undo(params);

      _viewModel.friends.removeWhere((friend) => friend.id == friendUserId);
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }
}
