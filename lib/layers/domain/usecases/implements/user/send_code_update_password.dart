import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/user/i_send_code_update_password.dart';

class SendCodeUpdatePassword implements ISendCodeUpdatePassword {
  final IUserAccountRepository userAccountRepository;

  SendCodeUpdatePassword({required this.userAccountRepository});

  @override
  Future<void> send(String email) async {
    try {
      await userAccountRepository.sendCodeUpdatePassword(email);
    } on UnexpectedError {
      throw StandardError(R.string.sendCodeError);
    }
  }
}
