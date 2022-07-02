import '../../../../../i18n/resources.dart';
import '../../../entities/user_entity.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_user_account_repository.dart';
import '../../abstracts/user/i_save_user_account.dart';

class SaveUserAccount implements ISaveUserAccount {
  final IUserAccountRepository userAccountRepository;

  SaveUserAccount({required this.userAccountRepository});

  @override
  Future<void> save(UserEntity entity) async {
    try {
      await userAccountRepository.updateUserAccount(entity);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.saveError);
    }
  }
}
