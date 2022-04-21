import '../../data/repositories/i_user_account_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';
import '../../external/helpers/errors/external_error.dart';
import '../datasources/i_user_account_datasource.dart';
import '../models/user_model.dart';

class UserAccountRepository implements IUserAccountRepository {
  final IUserAccountDataSource userAccountDataSource;

  UserAccountRepository({required this.userAccountDataSource});

  @override
  Future<UserEntity> authWithEmail(LoginParams params) async {
    try {
      final UserModel userModel = await userAccountDataSource.authWithEmail(params);
      return userModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(UserEntity entity) async {
    try {
      final UserModel userModel = await userAccountDataSource.signUpWithEmail(UserModel.fromEntity(entity));
      return userModel.toEntity();
    } on ExternalError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedExternalError().toDomainError();
    }
  }
}