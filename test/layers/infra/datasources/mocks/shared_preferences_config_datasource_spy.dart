import 'package:my_gift_app/layers/infra/datasources/i_config_datasource.dart';
import 'package:mocktail/mocktail.dart';

class SharedPreferencesConfigDataSourceSpy extends Mock implements IConfigDataSource {
  SharedPreferencesConfigDataSourceSpy.saveTheme() {
    mockSaveTheme();
  }

  SharedPreferencesConfigDataSourceSpy.getTheme(int? value) {
    mockGetTheme(value);
  }

  SharedPreferencesConfigDataSourceSpy.deleteConfigs() {
    mockDeleteConfigs();
  }

  //region saveTheme
  When mockSaveThemeCall() => when(() => saveTheme(any()));
  void mockSaveTheme() => mockSaveThemeCall().thenAnswer((_) => Future.value());
  void mockSaveThemeError({Exception? error}) => mockSaveThemeCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region getTheme
  When mockGetThemeCall() => when(() => getTheme());
  void mockGetTheme(int? value) => mockGetThemeCall().thenAnswer((_) => Future.value(value));
  void mockGetThemeError({Exception? error}) => mockGetThemeCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region deleteConfigs
  When mockDeleteConfigsCall() => when(() => deleteConfigs());
  void mockDeleteConfigs() => mockDeleteConfigsCall().thenAnswer((_) => Future.value());
  void mockDeleteConfigsError({Exception? error}) => mockDeleteConfigsCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}