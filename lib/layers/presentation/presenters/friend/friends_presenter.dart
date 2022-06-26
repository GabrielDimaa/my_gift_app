import '../../helpers/interfaces/i_initialize.dart';
import '../../helpers/interfaces/i_loading.dart';
import '../../helpers/interfaces/i_view_model.dart';
import '../../viewmodels/friends_viewmodel.dart';
import '../../viewmodels/user_viewmodel.dart';

abstract class FriendsPresenter implements IViewModel<FriendsViewModel>, IInitialize<FriendsViewModel>, ILoading {
  Future<void> getFriends();
  Future<void> undoFriend(String friendUserId);
  Future<void> addFriend(UserViewModel person);
  Future<List<UserViewModel>> fetchSearchPersons(String name);
}