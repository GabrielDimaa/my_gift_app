import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSpy extends Mock implements SharedPreferences {
  SharedPreferencesSpy.setInt(bool value) {
    mockSetInt(value);
  }

  //region setInt
  When mockSetIntCall() => when(() => setInt(any(), any()));
  void mockSetInt(bool value) => mockSetIntCall().thenAnswer((_) => Future.value(value));
  void mockSetIntError({Exception? error}) => mockSetIntCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
