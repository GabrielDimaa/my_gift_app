import 'package:desejando_app/layers/data/usecases/tag/delete_tag.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../infra/mocks/tag_repository_spy.dart';

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

  test("Deve throw UnexpectedDomainError", () {
    tagRepositorySpy.mockDeleteError();

    final Future future = sut.delete(tagId);
    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw NotFoundDomainError", () {
    tagRepositorySpy.mockDeleteError(error: NotFoundDomainError());

    final Future future = sut.delete(tagId);
    expect(future, throwsA(isA<NotFoundDomainError>()));
  });
}