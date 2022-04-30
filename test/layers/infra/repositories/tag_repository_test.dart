import 'package:desejando_app/layers/domain/entities/tag_entity.dart';
import 'package:desejando_app/layers/domain/helpers/errors/domain_error.dart';
import 'package:desejando_app/layers/external/helpers/errors/external_error.dart';
import 'package:desejando_app/layers/infra/models/tag_model.dart';
import 'package:desejando_app/layers/infra/repositories/tag_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/entities/entity_extension.dart';
import '../../external/mocks/firebase_tag_datasource_spy.dart';
import '../models/model_factory.dart';

void main() {
  late TagRepository sut;
  late FirebaseTagDataSourceSpy tagDataSourceSpy;

  final List<TagModel> tagsResult = ModelFactory.tags();

  setUp(() {
    tagDataSourceSpy = FirebaseTagDataSourceSpy(datas: tagsResult, get: true);
    sut = TagRepository(tagDataSource: tagDataSourceSpy);
  });

  test("Deve chamar getAll corretamente", () async {
    await sut.getAll();
    verify(() => tagDataSourceSpy.getAll());
  });

  test("Deve chamar getAll e retornar os valores corretamente", () async {
    final List<TagEntity> tags = await sut.getAll();
    expect(tags.equals(tagsResult.map((e) => e.toEntity()).toList()), true);
  });

  test("Deve throw UnexpectedDomainError se ConnectionExternalError", () {
    tagDataSourceSpy.mockGetAllError(error: ConnectionExternalError());
    final Future future = sut.getAll();

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });

  test("Deve throw UnexpectedDomainError", () {
    tagDataSourceSpy.mockGetAllError(error: Exception());
    final Future future = sut.getAll();

    expect(future, throwsA(isA<UnexpectedDomainError>()));
  });
}
