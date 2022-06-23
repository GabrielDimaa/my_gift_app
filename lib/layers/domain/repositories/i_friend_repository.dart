import '../entities/friend_entity.dart';
import '../entities/user_entity.dart';
import '../helpers/params/friend_params.dart';

abstract class IFriendRepository {
  Future<FriendEntity> addFriend(FriendParams params);
  Future<void> undoFriend(String friendUserId, String processorUserId);
  Future<List<FriendEntity>> getFriends(String processorUserId);
  Future<List<UserEntity>> fetchSearchFriends(String name);
}
