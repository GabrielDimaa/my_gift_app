import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:desejando_app/layers/domain/repositories/i_user_account_repository.dart';
import 'package:mocktail/mocktail.dart';

class UserAccountRepositorySpy extends Mock implements IUserAccountRepository {
  final LoginParams? params;
  final UserEntity? entityRequest;
  final UserEntity entityResult;

  UserAccountRepositorySpy({this.params, this.entityRequest, required this.entityResult}) {
    if (params != null) mockAuthWithEmail(entityResult);
    if (entityRequest != null) mockSignUpWithEmail(entityResult);

    mockSendVerificationEmail(entityResult.id!);
    mockCheckEmailVerified(true);
    mockGetUserLogged(entityResult);
    mockLogout();
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
}