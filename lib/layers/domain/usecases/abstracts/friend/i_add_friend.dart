import '../../../helpers/params/friend_params.dart';

abstract class IAddFriend {
  Future<void> add(FriendParams params);
}
