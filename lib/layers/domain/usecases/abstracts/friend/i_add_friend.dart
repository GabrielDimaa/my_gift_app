import '../../../entities/friend_entity.dart';
import '../../../helpers/params/friend_params.dart';

abstract class IAddFriend {
  Future<FriendEntity> add(FriendParams params);
}
