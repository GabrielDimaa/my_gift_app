import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/login/i_login_google.dart';

class LoginGoogle implements ILoginGoogle {
  final IUserAccountRepository userAccountRepository;

  LoginGoogle({required this.userAccountRepository});

  @override
  Future<UserEntity?> auth() async {
    try {
      return await userAccountRepository.authWithGoogle();
    } on UnexpectedError {
      throw StandardError(R.string.loginError);
    }
  }
}
