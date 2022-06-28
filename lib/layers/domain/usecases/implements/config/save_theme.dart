import '../../../../../i18n/resources.dart';
import '../../../enums/theme_mode.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_config_repository.dart';
import '../../abstracts/config/i_save_theme.dart';

class SaveTheme implements ISaveTheme {
  final IConfigRepository configRepository;

  SaveTheme({required this.configRepository});

  @override
  Future<void> save(ThemeMode themeMode) async {
    try {
      await configRepository.saveTheme(themeMode);
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.saveError);
    }
  }
}
