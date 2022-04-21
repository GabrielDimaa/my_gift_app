import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/helpers/params/login_params.dart';
import '../../../domain/usecases/login/i_login_email.dart';
import '../../repositories/i_user_account_repository.dart';

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
      if (e is UnexpectedDomainError) throw UnexpectedDomainError(R.string.loginError);

      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.loginError);
    }
  }
}