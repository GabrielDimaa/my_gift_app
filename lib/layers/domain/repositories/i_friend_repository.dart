import '../entities/friends_entity.dart';
import '../entities/user_entity.dart';
import '../helpers/params/friend_params.dart';

abstract class IFriendRepository {
  Future<void> addFriend(FriendParams params);
  Future<void> undoFriend(FriendParams params);
  Future<FriendsEntity> getFriends(String userId);
  Future<List<UserEntity>> fetchSearchPersons(String name);
}
