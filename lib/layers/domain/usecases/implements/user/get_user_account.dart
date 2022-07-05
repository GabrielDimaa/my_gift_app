import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/user/i_get_user_account.dart';

class GetUserAccount implements IGetUserAccount {
  final IUserAccountRepository userAccountRepository;

  GetUserAccount({required this.userAccountRepository});

  @override
  Future<UserEntity> get(String userId) async {
    try {
      return await userAccountRepository.getUserAccount(userId);
    } on UnexpectedError {
      throw StandardError(R.string.dataLoadError);
    }
  }
}
