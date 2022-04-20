import 'package:desejando_app/layers/data/repositories/i_signup_repository.dart';
import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:mocktail/mocktail.dart';

class SignUpRepositorySpy extends Mock implements ISignUpRepository {
  final UserEntity entityRequest;
  final UserEntity entityResult;

  SignUpRepositorySpy({required this.entityRequest, required  this.entityResult}) {
    mockSignUpWithEmail(entityResult);
  }

  When mockSignUpWithEmailCall() => when(() => signUpWithEmail(entityRequest));
  void mockSignUpWithEmail(UserEntity data) => mockSignUpWithEmailCall().thenAnswer((_) => Future.value(data));
  void mockSignUpWithEmailError(Exception error) => mockSignUpWithEmailCall().thenThrow(error);
}