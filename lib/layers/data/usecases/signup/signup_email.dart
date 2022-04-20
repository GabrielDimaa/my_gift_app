import '../../../../i18n/resources.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/helpers/errors/domain_error.dart';
import '../../../domain/usecases/signup/i_signup_email.dart';
import '../../repositories/i_signup_repository.dart';

class SignUpEmail implements ISignUpEmail {
  final ISignUpRepository signUpRepository;

  SignUpEmail({required this.signUpRepository});

  @override
  Future<UserEntity> auth(UserEntity entity) async {
    try {
      if ((entity.password?.trim().length ?? 0) < 8) throw PasswordDomainError(message: R.string.shortPasswordError);

      return await signUpRepository.signUpWithEmail(entity);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.signUpError);
    }
  }
}