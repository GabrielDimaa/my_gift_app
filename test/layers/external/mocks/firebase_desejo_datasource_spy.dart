import 'package:desejando_app/layers/infra/datasources/i_desejo_datasource.dart';
import 'package:desejando_app/layers/infra/models/desejo_model.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseDesejoDataSourceSpy extends Mock implements IDesejoDataSource {
  FirebaseDesejoDataSourceSpy(DesejoModel value) {
    mockGetById(value);
  }

  When mockGetByIdCall() => when(() => getById(any()));
  void mockGetById(DesejoModel value) => mockGetByIdCall().thenAnswer((_) => Future.value(value));
  void mockGetByIdError({Exception? error}) => mockGetByIdCall().thenThrow(error ?? Exception("any_message"));
}
