import 'package:desejando_app/layers/domain/usecases/wish/delete_wish.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/mocks/wish_repository_spy.dart';


void main() {
  late DeleteWish sut;
  late WishRepositorySpy wishRepositorySpy;

  final String wishId = faker.guid.guid();

  setUp(() {
    wishRepositorySpy = WishRepositorySpy(delete: true);
    sut = DeleteWish(wishRepository: wishRepositorySpy);
  });

  test("Deve chamar delete com valores corretos", () async {
    await sut.delete(wishId);
    verify(() => wishRepositorySpy.delete(wishId));
  });

  test("Deve throw UnexpectedDomainError", () {
    wishRepositorySpy.mockDeleteError();

    final Future future = sut.delete(wishId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    wishRepositorySpy.mockDeleteError(error: NotFoundDomainError());

    final Future future = sut.delete(wishId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}