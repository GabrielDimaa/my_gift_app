import 'package:my_gift_app/layers/domain/entities/user_entity.dart';
import 'package:my_gift_app/layers/domain/helpers/params/login_params.dart';
import 'package:my_gift_app/layers/domain/helpers/params/new_password_params.dart';
import 'package:my_gift_app/layers/domain/repositories/i_user_account_repository.dart';
import 'package:mocktail/mocktail.dart';

class UserAccountRepositorySpy extends Mock implements IUserAccountRepository {
  final LoginParams? params;
  final UserEntity? entityRequest;
  final UserEntity entityResult;
  final NewPasswordParams? newPasswordParams;

  UserAccountRepositorySpy({this.params, this.entityRequest, required this.entityResult, this.newPasswordParams}) {
    if (params != null) mockAuthWithEmail(entityResult);
    if (entityRequest != null) mockSignUpWithEmail(entityResult);

    mockSendVerificationEmail(entityResult.id!);
    mockCheckEmailVerified(true);
    mockGetUserLogged(entityResult);
    mockLogout();
    mockGetUserAccount(entityResult);
    mockUpdateUserAccount();
    mockSendCodeUpdatePassword();
    if (newPasswordParams != null) mockUpdatePassword();
  }

  //region auth
  When mockAuthWithEmailCall() => when(() => authWithEmail(params!));
  void mockAuthWithEmail(UserEntity data) => mockAuthWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithEmailError(Exception error) => mockAuthWithEmailCall().thenThrow(error);
  //endregion

  //region signup
  When mockSignUpWithEmailCall() => when(() => signUpWithEmail(entityRequest!));
  void mockSignUpWithEmail(UserEntity data) => mockSignUpWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockSignUpWithEmailError(Exception error) => mockSignUpWithEmailCall().thenThrow(error);
  //endregion

  //region sendVerificationEmail
  When mockSendVerificationEmailCall() => when(() => sendVerificationEmail(any()));
  void mockSendVerificationEmail(String data) => mockSendVerificationEmailCall().thenAnswer((_) => Future.value());
  void mockSendVerificationEmailError(Exception error) => mockSendVerificationEmailCall().thenThrow(error);
  //endregion

  //region checkEmailVerified
  When mockCheckEmailVerifiedCall() => when(() => checkEmailVerified(any()));
  void mockCheckEmailVerified(bool data) => mockCheckEmailVerifiedCall().thenAnswer((_) => Future.value(data));
  void mockCheckEmailVerifiedError(Exception error) => mockCheckEmailVerifiedCall().thenThrow(error);
  //endregion

  //region getUserLogged
  When mockGetUserLoggedCall() => when(() => getUserLogged());
  void mockGetUserLogged(UserEntity? data) => mockGetUserLoggedCall().thenAnswer((_) => Future.value(data));
  void mockGetUserLoggedError({Exception? error}) => mockGetUserLoggedCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region logout
  When mockLogoutCall() => when(() => logout());
  void mockLogout() => mockLogoutCall().thenAnswer((_) => Future.value());
  void mockLogoutError({Exception? error}) => mockLogoutCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region getUserAccount
  When mockGetUserAccountCall() => when(() => getUserAccount(any()));
  void mockGetUserAccount(UserEntity data) => mockGetUserAccountCall().thenAnswer((_) => Future.value(data));
  void mockGetUserAccountError({Exception? error}) => mockGetUserAccountCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region updateUserAccount
  When mockUpdateUserAccountCall() => when(() => updateUserAccount(any()));
  void mockUpdateUserAccount() => mockUpdateUserAccountCall().thenAnswer((_) => Future.value());
  void mockUpdateUserAccountError({Exception? error}) => mockUpdateUserAccountCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region sendCodeUpdatePassword
  When mockSendCodeUpdatePasswordCall() => when(() => sendCodeUpdatePassword(any()));
  void mockSendCodeUpdatePassword() => mockSendCodeUpdatePasswordCall().thenAnswer((_) => Future.value());
  void mockSendCodeUpdatePasswordError({Exception? error}) => mockSendCodeUpdatePasswordCall().thenThrow(error ?? Exception("any_error"));
  //endregion

  //region updatePassword
  When mockUpdatePasswordCall() => when(() => updatePassword(any()));
  void mockUpdatePassword() => mockUpdatePasswordCall().thenAnswer((_) => Future.value());
  void mockUpdatePasswordError({Exception? error}) => mockUpdatePasswordCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}