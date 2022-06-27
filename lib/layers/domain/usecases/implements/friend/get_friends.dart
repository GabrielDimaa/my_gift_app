import '../../../../../i18n/resources.dart';
import '../../../entities/friends_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_get_friends.dart';

class GetFriends implements IGetFriends {
  final IFriendRepository friendRepository;

  GetFriends({required this.friendRepository});

  @override
  Future<FriendsEntity> get(String userId) async {
    try {
      return await friendRepository.getFriends(userId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.addFriendError);
    }
  }
}