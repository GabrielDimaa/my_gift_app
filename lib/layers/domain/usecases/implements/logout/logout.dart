import '../../../../../i18n/resources.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/logout/i_logout.dart';

class Logout implements ILogout {
  final IUserAccountRepository userAccountRepository;

  Logout({required this.userAccountRepository});

  @override
  Future<void> logout() async {
    try {
      await userAccountRepository.logout();
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.loginError);
    }
  }
}