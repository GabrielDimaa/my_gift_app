import 'package:desejando_app/layers/data/repositories/i_user_account_repository.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/params/login_params.dart';
import 'package:mocktail/mocktail.dart';

class UserAccountRepositorySpy extends Mock implements IUserAccountRepository {
  final LoginParams? params;
  final UserEntity? entityRequest;
  final UserEntity entityResult;

  UserAccountRepositorySpy({this.params, this.entityRequest, required this.entityResult}) {
    if (params != null) mockAuthWithEmail(entityResult);
    if (entityRequest != null) mockSignUpWithEmail(entityResult);
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
}