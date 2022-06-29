import '../../../../../i18n/resources.dart';
import '../../../enums/theme_mode.dart';
import '../../../helpers/errors/domain_error.dart';
import '../../../repositories/i_config_repository.dart';
import '../../abstracts/config/i_get_theme.dart';

class GetTheme implements IGetTheme {
  final IConfigRepository configRepository;

  GetTheme({required this.configRepository});

  @override
  Future<ThemeMode?> get() async {
    try {
      return await configRepository.getTheme();
    } on DomainError {
      rethrow;
    } catch (e) {
      throw UnexpectedDomainError(R.string.getError);
    }
  }
}
