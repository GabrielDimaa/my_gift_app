import '../../../i18n/resources.dart';
import '../../data/repositories/i_login_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/errors/domain_error.dart';
import '../../domain/helpers/params/login_params.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_login_datasource.dart';
import '../models/user_model.dart';

class LoginRepository implements ILoginRepository {
  final ILoginDataSource loginDataSource;

  LoginRepository({required this.loginDataSource});

  @override
  Future<UserEntity> authWithEmail(LoginParams params) async {
    try {
      final UserModel userModel = await loginDataSource.authWithEmail(params);
      return userModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedDomainError(R.string.loginError);
    }
  }
}