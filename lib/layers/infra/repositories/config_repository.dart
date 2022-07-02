import '../../domain/enums/theme_mode.dart';
import '../../domain/repositories/i_config_repository.dart';
import '../datasources/i_config_datasource.dart';
import '../helpers/errors/infra_error.dart';

class ConfigRepository implements IConfigRepository {
  final IConfigDataSource configDataSource;

  ConfigRepository({required this.configDataSource});

  @override
  Future<void> saveTheme(ThemeMode themeMode) async {
    try {
      await configDataSource.saveTheme(themeMode.index);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<ThemeMode?> getTheme() async {
    try {
      final int? themeInt = await configDataSource.getTheme();
      if (themeInt == null) return null;

      return ThemeModeParse.fromIndex(themeInt);
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }

  @override
  Future<void> deleteConfigs() async {
    try {
      await configDataSource.deleteConfigs();
    } on InfraError catch (e) {
      if (e is UnexpectedInfraError) rethrow;
      throw e.toDomainError();
    }
  }
}