import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../helpers/params/friend_params.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_add_friend.dart';

class AddFriend implements IAddFriend {
  final IFriendRepository friendRepository;

  AddFriend({required this.friendRepository});

  @override
  Future<void> add(FriendParams params) async {
    try {
      await friendRepository.addFriend(params);
    } on UnexpectedError {
      throw StandardError(R.string.addFriendError);
    }
  }
}
