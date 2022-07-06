import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';
import '../../domain/helpers/params/new_password_params.dart';
import '../../domain/repositories/i_user_account_repository.dart';
import '../datasources/i_user_account_datasource.dart';
import '../models/user_model.dart';

class UserAccountRepository implements IUserAccountRepository {
  final IUserAccountDataSource userAccountDataSource;

  UserAccountRepository({required this.userAccountDataSource});

  @override
  Future<UserEntity> authWithEmail(LoginParams params) async {
    final UserModel userModel = await userAccountDataSource.authWithEmail(params);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> signUpWithEmail(UserEntity entity) async {
    final UserModel userModel = await userAccountDataSource.signUpWithEmail(UserModel.fromEntity(entity));
    return userModel.toEntity();
  }

  @override
  Future<UserEntity?> authWithGoogle() async {
    final UserModel? userModel = await userAccountDataSource.authWithGoogle();
    return userModel?.toEntity();
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    await userAccountDataSource.sendVerificationEmail(userId);
  }

  @override
  Future<bool> checkEmailVerified(String userId) async {
    return await userAccountDataSource.checkEmailVerified(userId);
  }

  @override
  Future<UserEntity?> getUserLogged() async {
    final UserModel? userModel = await userAccountDataSource.getUserLogged();
    return userModel?.toEntity();
  }

  @override
  Future<void> logout() async {
    await userAccountDataSource.logout();
  }

  @override
  Future<UserEntity> getUserAccount(String userId) async {
    final UserModel userModel = await userAccountDataSource.getById(userId);
    return userModel.toEntity();
  }

  @override
  Future<void> updateUserAccount(UserEntity entity) async {
    await userAccountDataSource.updateUserAccount(UserModel.fromEntity(entity));
  }

  @override
  Future<void> sendCodeUpdatePassword(String email) async {
    await userAccountDataSource.sendCodeUpdatePassword(email);
  }

  @override
  Future<void> updatePassword(NewPasswordParams params) async {
    await userAccountDataSource.updatePassword(params);
  }
}
