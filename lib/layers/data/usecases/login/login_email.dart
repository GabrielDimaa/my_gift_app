import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/domain_error.dart';
import '../../../domain/helpers/login_params.dart';
import '../../../domain/usecases/login/i_login_email.dart';
import '../../repositories/i_login_repository.dart';

class LoginEmail implements ILoginEmail {
  final ILoginRepository loginRepository;

  LoginEmail({required this.loginRepository});

  @override
  Future<UserEntity> auth(LoginParams params) async {
    try {
      final UserEntity user = await loginRepository.authWithEmail(params);

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