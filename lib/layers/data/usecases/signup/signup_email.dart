import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/signup/i_signup_email.dart';
import '../../repositories/i_user_account_repository.dart';

class SignUpEmail implements ISignUpEmail {
  final IUserAccountRepository userAccountRepository;

  SignUpEmail({required this.userAccountRepository});

  @override
  Future<UserEntity> signUp(UserEntity entity) async {
    try {
      if ((entity.password?.trim().length ?? 0) < 8) throw PasswordDomainError(message: R.string.shortPasswordError);

      return await userAccountRepository.signUpWithEmail(entity);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.signUpError);
    }
  }
}