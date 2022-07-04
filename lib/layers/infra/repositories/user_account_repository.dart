import 'package:my_gift_app/layers/domain/helpers/params/new_password_params.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/helpers/params/login_params.dart';
import '../../domain/repositories/i_user_account_repository.dart';
import '../datasources/i_user_account_datasource.dart';
import '../helpers/errors/infra_error.dart';
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
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<UserEntity> signUpWithEmail(UserEntity entity) async {
    try {
      final UserModel userModel = await userAccountDataSource.signUpWithEmail(UserModel.fromEntity(entity));
      return userModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> sendVerificationEmail(String userId) async {
    try {
      await userAccountDataSource.sendVerificationEmail(userId);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<bool> checkEmailVerified(String userId) async {
    try {
      return await userAccountDataSource.checkEmailVerified(userId);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<UserEntity?> getUserLogged() async {
    try {
      final UserModel? userModel = await userAccountDataSource.getUserLogged();
      return userModel?.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> logout() async {
    try {
      await userAccountDataSource.logout();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<UserEntity> getUserAccount(String userId) async {
    try {
      final UserModel userModel = await userAccountDataSource.getById(userId);
      return userModel.toEntity();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> updateUserAccount(UserEntity entity) async {
    try {
      await userAccountDataSource.updateUserAccount(UserModel.fromEntity(entity));
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> sendCodeUpdatePassword(String email) async {
    try {
      await userAccountDataSource.sendCodeUpdatePassword(email);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> updatePassword(NewPasswordParams params) async {
    try {
      await userAccountDataSource.updatePassword(params);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }
}
