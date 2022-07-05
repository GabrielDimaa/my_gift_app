import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../repositories/i_friend_repository.dart';
import '../../abstracts/friend/i_fetch_search_persons.dart';

class FetchSearchPersons implements IFetchSearchPersons {
  final IFriendRepository friendRepository;

  FetchSearchPersons({required this.friendRepository});

  @override
  Future<List<UserEntity>> search(String name) async {
    try {
      return await friendRepository.fetchSearchPersons(name);
    } on UnexpectedError {
      throw StandardError(R.string.fetchFriendError);
    }
  }
}
