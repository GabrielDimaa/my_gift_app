import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../helpers/params/friend_params.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_verify_friendship.dart';

class VerifyFriendship implements IVerifyFriendship {
  final IFriendRepository friendRepository;

  VerifyFriendship({required this.friendRepository});

  @override
  Future<bool> verify(FriendParams params) async {
    try {
      return await friendRepository.verifyFriendship(params);
    } on UnexpectedError {
      throw StandardError(R.string.getProfileError);
    }
  }
}