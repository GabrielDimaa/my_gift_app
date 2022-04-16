import 'package:desejando_app/layers/data/repositories/i_desejo_repository.dart';
import 'package:desejando_app/layers/domain/entities/desejo_entity.dart';
import 'package:mocktail/mocktail.dart';

class DesejoRepositorySpy extends Mock implements IDesejoRepository {
  DesejoRepositorySpy(DesejoEntity data) {
    mockGetById(data);
  }

  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(DesejoEntity value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_error"));
}