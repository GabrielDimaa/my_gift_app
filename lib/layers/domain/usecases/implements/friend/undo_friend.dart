import '../../../../../i18n/resources.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_undo_friend.dart';

class UndoFriend implements IUndoFriend {
  final IFriendRepository friendRepository;

  UndoFriend({required this.friendRepository});

  @override
  Future<void> undo(String friendUserId) async {
    try {
      return await friendRepository.undoFriend(friendUserId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.undoFriendError);
    }
  }
}
