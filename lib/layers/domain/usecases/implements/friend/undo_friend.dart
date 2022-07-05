import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../helpers/params/friend_params.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_undo_friend.dart';

class UndoFriend implements IUndoFriend {
  final IFriendRepository friendRepository;

  UndoFriend({required this.friendRepository});

  @override
  Future<void> undo(FriendParams params) async {
    try {
      await friendRepository.undoFriend(params);
    } on UnexpectedError {
      throw StandardError(R.string.undoFriendError);
    }
  }
}
