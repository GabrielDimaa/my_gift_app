import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/signup/i_send_verification_email.dart';

class SendVerificationEmail implements ISendVerificationEmail {
  final IUserAccountRepository userAccountRepository;

  SendVerificationEmail({required this.userAccountRepository});

  @override
  Future<void> send(String userId) async {
    try {
      await userAccountRepository.sendVerificationEmail(userId);
    } on UnexpectedError {
      throw StandardError(R.string.sendVerificationEmailError);
    }
  }
}
