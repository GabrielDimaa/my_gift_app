import '../../../../i18n/resources.dart';
import '../../entities/user_entity.dart';
import '../../helpers/errors/domain_error.dart';
import '../../helpers/params/login_params.dart';
import '../../repositories/i_user_account_repository.dart';
import 'i_login_email.dart';

class LoginEmail implements ILoginEmail {
  final IUserAccountRepository userAccountRepository;

  LoginEmail({required this.userAccountRepository});

  @override
  Future<UserEntity> auth(LoginParams params) async {
    try {
      final UserEntity user = await userAccountRepository.authWithEmail(params);
      if (!user.emailVerified) throw EmailNotVerifiedDomainError();

      return user;
    } on DomainError catch(e) {
      if (e is NotFoundDomainError) throw NotFoundDomainError(message: R.string.loginNotFoundError);
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.loginError);
    }
  }
}
