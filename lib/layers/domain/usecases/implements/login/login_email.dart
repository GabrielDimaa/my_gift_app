import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../helpers/params/login_params.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/login/i_login_email.dart';

class LoginEmail implements ILoginEmail {
  final IUserAccountRepository userAccountRepository;

  LoginEmail({required this.userAccountRepository});

  @override
  Future<UserEntity> auth(LoginParams params) async {
    try {
      final UserEntity user = await userAccountRepository.authWithEmail(params);
      if (!user.emailVerified) throw EmailError(R.string.emailNotVerifiedError);

      return user;
    } on UnexpectedError {
      throw StandardError(R.string.loginError);
    }
  }
}
