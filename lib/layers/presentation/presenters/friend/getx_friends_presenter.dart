import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../../monostates/user_global.dart';
import '../../../domain/entities/friends_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/helpers/params/friend_params.dart';
import '../../../domain/usecases/abstracts/friend/i_add_friend.dart';
import '../../../domain/usecases/abstracts/friend/i_fetch_search_persons.dart';
import '../../../domain/usecases/abstracts/friend/i_get_friends.dart';
import '../../../domain/usecases/abstracts/friend/i_undo_friend.dart';
import '../../helpers/mixins/loading_manager.dart';
import '../../viewmodels/friends_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';
import 'friends_presenter.dart';

class GetxFriendsPresenter extends GetxController with LoadingManager implements FriendsPresenter {
  final IGetFriends _getFriends;
  final IUndoFriend _undoFriend;
  final IAddFriend _addFriend;
  final IFetchSearchPersons _fetchSearchPersons;

  GetxFriendsPresenter({
    required IGetFriends getFriends,
    required IUndoFriend undoFriend,
    required IAddFriend addFriend,
    required IFetchSearchPersons fetchSearchPersons,
  })  : _getFriends = getFriends,
        _undoFriend = undoFriend,
        _addFriend = addFriend,
        _fetchSearchPersons = fetchSearchPersons;

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

  @override
  Future<void> addFriend(UserViewModel person) async {
    try {
      final FriendParams params = FriendParams(userId: _user.id!, friendUserId: person.id);
      await _addFriend.add(params);

      _viewModel.friends.add(person);
      _viewModel.friends.sort((a, b) => a.name.toString().toLowerCase().compareTo(b.name.toString().toLowerCase()));
    } on DomainError catch (e) {
      throw Exception(e.message);
    }
  }

  @override
  Future<List<UserViewModel>> fetchSearchPersons(String name) async {
    final List<UserEntity> persons = await _fetchSearchPersons.search(name);
    persons.removeWhere((e) => e.id == _user.id);
    return persons.map((entity) => UserViewModel.fromEntity(entity)).toList();
  }
}
