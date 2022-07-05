import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/wish/delete_wish.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/wish_repository_spy.dart';


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

  test("Deve throw StandardError se ocorrer um erro inesperado", () {
    wishRepositorySpy.mockDeleteError(error: UnexpectedError());

    final Future future = sut.delete(wishId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    wishRepositorySpy.mockDeleteError(error: StandardError());

    final Future future = sut.delete(wishId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    wishRepositorySpy.mockDeleteError(error: Exception());

    final Future future = sut.delete(wishId);
    expect(future, throwsA(isA<Exception>()));
  });
}