import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';
import '../../domain/repositories/i_user_account_repository.dart';
import '../datasources/i_user_account_datasource.dart';
import '../errors/infra_error.dart';
import '../models/user_model.dart';

class UserAccountRepository implements IUserAccountRepository {
  final IUserAccountDataSource userAccountDataSource;

  UserAccountRepository({required this.userAccountDataSource});

  @override
  Future<UserEntity> authWithEmail(LoginParams params) async {
    try {
      final UserModel userModel = await userAccountDataSource.authWithEmail(params);
      return userModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(UserEntity entity) async {
    try {
      final UserModel userModel = await userAccountDataSource.signUpWithEmail(UserModel.fromEntity(entity));
      return userModel.toEntity();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    try {
      await userAccountDataSource.sendVerificationEmail();
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }

  @override
  Future<bool> checkEmailVerified(String userId) async {
    try {
      return await userAccountDataSource.checkEmailVerified(userId);
    } on InfraError catch (e) {
      throw e.toDomainError();
    } catch (e) {
      throw UnexpectedInfraError().toDomainError();
    }
  }
}
