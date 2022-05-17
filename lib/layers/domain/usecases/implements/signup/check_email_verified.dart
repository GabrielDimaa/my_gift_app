import '../../../../../i18n/resources.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/signup/i_check_email_verified.dart';

class CheckEmailVerified implements ICheckEmailVerified {
  final IUserAccountRepository userAccountRepository;

  CheckEmailVerified({required this.userAccountRepository});

  @override
  Future<bool> check(String userId) async {
    try {
      return await userAccountRepository.checkEmailVerified(userId);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.checkEmailVerifiedError);
    }
  }
}