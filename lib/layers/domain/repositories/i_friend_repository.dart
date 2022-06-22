import '../entities/friend_entity.dart';
import '../helpers/params/friend_params.dart';

abstract class IFriendRepository {
  Future<FriendEntity> addFriend(FriendParams params);
}
