import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/signup/i_signup_email.dart';

class SignUpEmail implements ISignUpEmail {
  final IUserAccountRepository userAccountRepository;

  SignUpEmail({required this.userAccountRepository});

  @override
  Future<UserEntity> signUp(UserEntity entity) async {
    try {
      if ((entity.password?.length ?? 0) < 8) throw StandardError(R.string.shortPasswordError);

      return await userAccountRepository.signUpWithEmail(entity);
    } on UnexpectedError {
      throw StandardError(R.string.signUpError);
    }
  }
}
