import 'package:desejando_app/layers/domain/entities/user_entity.dart';
import 'package:desejando_app/layers/domain/helpers/domain_error.dart';
import 'package:desejando_app/layers/domain/helpers/login_params.dart';
import 'package:desejando_app/layers/external/helpers/external_error.dart';
import 'package:desejando_app/layers/infra/models/user_model.dart';
import 'package:desejando_app/layers/infra/repositories/login_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/params_factory.dart';
import '../../external/mocks/firebase_login_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late LoginRepository sut;
  late FirebaseLoginDataSourceSpy loginDataSourceSpy;

  final LoginParams loginParams = ParamsFactory.login();
  final UserModel userModel = ModelFactory.user();

  setUp(() {
    loginDataSourceSpy = FirebaseLoginDataSourceSpy(loginParams, userModel);
    sut = LoginRepository(loginDataSource: loginDataSourceSpy);
  });

  test("Deve chamar authWithEmail com valores corretos", () async {
    await sut.authWithEmail(loginParams);
    verify(() => loginDataSourceSpy.authWithEmail(loginParams));
  });

  test("Deve retornar UserEntity com sucesso", () async {
    final UserEntity entity = await sut.authWithEmail(loginParams);
    expect(entity, userModel.toEntity());
  });

  test("Deve throw NotFoundDomainError", () {
    loginDataSourceSpy.mockAuthWithEmailError(NotFoundExternalError());
    final Future future = sut.authWithEmail(loginParams);

    expect(future, throwsA(isA<NotFoundDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se UnexpectedExternalError", () {
    loginDataSourceSpy.mockAuthWithEmailError(UnexpectedExternalError());
    final Future future = sut.authWithEmail(loginParams);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
    loginDataSourceSpy.mockAuthWithEmailError(ConnectionExternalError());
    final Future future = sut.authWithEmail(loginParams);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se CancelledExternalError", () {
    loginDataSourceSpy.mockAuthWithEmailError(CancelledExternalError());
    final Future future = sut.authWithEmail(loginParams);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw UnexpectedDomainError se InternalExternalError", () {
    loginDataSourceSpy.mockAuthWithEmailError(InternalExternalError());
    final Future future = sut.authWithEmail(loginParams);

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
