import 'package:shared_preferences/shared_preferences.dart';

import '../i_config_datasource.dart';
import 'constants/keys.dart';

class SharedPreferencesConfigDataSource implements IConfigDataSource {
  final SharedPreferences sharedPreferences;

  SharedPreferencesConfigDataSource({required this.sharedPreferences});

  @override
  Future<void> saveTheme(int themeMode) async {
    await sharedPreferences.setInt(constantThemeModeKey, themeMode);
  }

  @override
  Future<int?> getTheme() async {
    return sharedPreferences.getInt(constantThemeModeKey);
  }

  @override
  Future<void> deleteConfigs() async {
    await sharedPreferences.remove(constantThemeModeKey);
  }
}
