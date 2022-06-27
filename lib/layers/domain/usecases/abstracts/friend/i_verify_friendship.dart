import '../../../helpers/params/friend_params.dart';

abstract class IVerifyFriendship {
  Future<bool> verify(FriendParams params);
}