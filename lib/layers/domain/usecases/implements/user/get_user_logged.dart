import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/user/i_get_user_logged.dart';

class GetUserLogged implements IGetUserLogged {
  final IUserAccountRepository userAccountRepository;

  GetUserLogged({required this.userAccountRepository});

  @override
  Future<UserEntity?> getUser() async {
    try {
      return await userAccountRepository.getUserLogged();
    } on UnexpectedError {
      throw StandardError(R.string.dataLoadError);
    }
  }
}
