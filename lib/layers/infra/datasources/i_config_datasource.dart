abstract class IConfigDataSource {
  Future<void> saveTheme(int themeMode);
  Future<int?> getTheme();
  Future<void> deleteConfigs();
}