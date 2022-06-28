import 'package:desejando_app/layers/infra/datasources/i_config_datasource.dart';
import 'package:mocktail/mocktail.dart';

class SharedPreferencesConfigDataSourceSpy extends Mock implements IConfigDataSource {
  SharedPreferencesConfigDataSourceSpy.saveTheme() {
    mockSaveTheme();
  }

  //region saveTheme
  When mockSaveThemeCall() => when(() => saveTheme(any()));
  void mockSaveTheme() => mockSaveThemeCall().thenAnswer((_) => Future.value());
  void mockSaveThemeError({Exception? error}) => mockSaveThemeCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}