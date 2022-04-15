import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:desejando_app/layers/infra/models/desejo_model.dart';
import 'package:faker/faker.dart';

abstract class MockDesejoEntity {
  static DesejoEntity desejoEntity() => DesejoEntity(
        id: faker.guid.guid(),
        descricao: faker.lorem.sentence(),
        imagem: faker.internet.httpsUrl(),
        link: faker.internet.httpsUrl(),
        observacao: faker.lorem.sentence(),
        faixaPrecoInicial: 40,
        faixaPrecoFinal: 60,
        dataCriado: DateTime(2022),
        arquivado: faker.randomGenerator.boolean(),
        finalizado: faker.randomGenerator.boolean(),
      );

  static DesejoModel desejoModel() => DesejoModel(
        id: faker.guid.guid(),
        descricao: faker.lorem.sentence(),
        imagem: faker.internet.httpsUrl(),
        link: faker.internet.httpsUrl(),
        observacao: faker.lorem.sentence(),
        faixaPrecoInicial: 40,
        faixaPrecoFinal: 60,
        dataCriado: DateTime(2022),
        arquivado: faker.randomGenerator.boolean(),
        finalizado: faker.randomGenerator.boolean(),
  );
}
