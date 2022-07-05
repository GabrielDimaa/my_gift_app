import 'package:my_gift_app/exceptions/errors.dart';
import 'package:my_gift_app/layers/domain/usecases/implements/tag/delete_tag.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/repositories/mocks/tag_repository_spy.dart';

void main() {
  late DeleteTag sut;
  late TagRepositorySpy tagRepositorySpy;

  final String tagId = faker.guid.guid();

  setUp(() {
    tagRepositorySpy = TagRepositorySpy(delete: true);
    sut = DeleteTag(tagRepository: tagRepositorySpy);
  });

  test("Deve chamar delete com valores corretos", () async {
    await sut.delete(tagId);
    verify(() => tagRepositorySpy.delete(tagId));
  });

  test("Deve throw StandardError", () {
    tagRepositorySpy.mockDeleteError(error: UnexpectedError());

    final Future future = sut.delete(tagId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw StandardError", () {
    tagRepositorySpy.mockDeleteError(error: StandardError());

    final Future future = sut.delete(tagId);
    expect(future, throwsA(isA<StandardError>()));
  });

  test("Deve throw Exception", () {
    tagRepositorySpy.mockDeleteError(error: Exception());

    final Future future = sut.delete(tagId);
    expect(future, throwsA(isA<Exception>()));
  });
}