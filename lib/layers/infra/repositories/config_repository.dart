import '../../domain/enums/theme_mode.dart';
import '../../domain/repositories/i_config_repository.dart';
import '../datasources/i_config_datasource.dart';

class ConfigRepository implements IConfigRepository {
  final IConfigDataSource configDataSource;

  ConfigRepository({required this.configDataSource});

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    await configDataSource.saveTheme(themeMode.index);
  }

  @override
  Future<ThemeMode?> getTheme() async {
    final int? themeInt = await configDataSource.getTheme();
    if (themeInt == null) return null;

    return ThemeModeParse.fromIndex(themeInt);
  }

  @override
  Future<void> deleteConfigs() async {
    await configDataSource.deleteConfigs();
  }
}
