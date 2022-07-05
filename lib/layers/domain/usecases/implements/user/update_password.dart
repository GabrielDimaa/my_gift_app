import '../../../../../exceptions/errors.dart';
import '../../../../../i18n/resources.dart';
import '../../../helpers/params/new_password_params.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/user/i_update_password.dart';

class UpdatePassword implements IUpdatePassword {
  final IUserAccountRepository userAccountRepository;

  UpdatePassword({required this.userAccountRepository});

  @override
  Future<void> update(NewPasswordParams params) async {
    try {
      if (params.newPassword.length < 8) throw StandardError(R.string.shortPasswordError);

      await userAccountRepository.updatePassword(params);
    } on UnexpectedError {
      throw StandardError(R.string.saveError);
    }
  }
}
