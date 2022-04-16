import 'package:desejando_app/layers/data/repositories/i_login_repository.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/login_params.dart';
import 'package:mocktail/mocktail.dart';

class LoginRepositorySpy extends Mock implements ILoginRepository {
  final LoginParams params;

  LoginRepositorySpy({required this.params, required UserEntity entity}) {
    mockAuthWithEmail(entity);
  }

  When mockAuthWithEmailCall() => when(() => authWithEmail(params));
  void mockAuthWithEmail(UserEntity data) => mockAuthWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockAuthWithEmailError(Exception error) => mockAuthWithEmailCall().thenThrow(error);
}