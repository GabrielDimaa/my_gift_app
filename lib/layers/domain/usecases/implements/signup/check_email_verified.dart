import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/signup/i_check_email_verified.dart';

class CheckEmailVerified implements ICheckEmailVerified {
  final IUserAccountRepository userAccountRepository;

  CheckEmailVerified({required this.userAccountRepository});

  @override
  Future<bool> check(String userId) async {
    try {
      return await userAccountRepository.checkEmailVerified(userId);
    } on UnexpectedError {
      throw StandardError(R.string.checkEmailVerifiedError);
    }
  }
}