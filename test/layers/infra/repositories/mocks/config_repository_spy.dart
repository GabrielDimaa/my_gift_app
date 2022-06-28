import 'package:desejando_app/layers/domain/repositories/i_config_repository.dart';
import 'package:mocktail/mocktail.dart';

class ConfigRepositorySpy extends Mock implements IConfigRepository {
  ConfigRepositorySpy.saveTheme() {
    mockSaveTheme();
  }

  //region addFriend
  When mockSaveThemeCall() => when(() => saveTheme(any()));
  void mockSaveTheme() => mockSaveThemeCall().thenAnswer((_) => Future.value());
  void mockSaveThemeError({Exception? error}) => mockSaveThemeCall().thenThrow(error ?? Exception("any_error"));
  //endregion
}
