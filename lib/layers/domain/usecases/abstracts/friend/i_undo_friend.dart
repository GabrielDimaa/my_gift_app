import '../../../helpers/params/friend_params.dart';

abstract class IUndoFriend {
  Future<void> undo(FriendParams params);
}
