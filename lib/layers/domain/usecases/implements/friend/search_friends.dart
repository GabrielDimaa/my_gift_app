import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_search_friends.dart';

class SearchFriends implements ISearchFriends {
  final IFriendRepository friendRepository;

  SearchFriends({required this.friendRepository});

  @override
  Future<List<UserEntity>> fetch(String name) async {
    try {
      return await friendRepository.fetchSearchFriends(name);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.addFriendError);
    }
  }
}
