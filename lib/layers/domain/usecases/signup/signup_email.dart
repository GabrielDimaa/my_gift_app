import '../../../../i18n/resources.dart';
import '../../entities/user_entity.dart';
import '../../helpers/errors/domain_error.dart';
import '../../repositories/i_user_account_repository.dart';
import 'i_signup_email.dart';

class SignUpEmail implements ISignUpEmail {
  final IUserAccountRepository userAccountRepository;

  SignUpEmail({required this.userAccountRepository});

  @override
  Future<UserEntity> signUp(UserEntity entity) async {
    try {
      if ((entity.password?.length ?? 0) < 8) throw PasswordDomainError(message: R.string.shortPasswordError);

      return await userAccountRepository.signUpWithEmail(entity);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.signUpError);
    }
  }
}