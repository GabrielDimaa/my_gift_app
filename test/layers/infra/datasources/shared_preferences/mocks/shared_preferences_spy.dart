import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSpy extends Mock implements SharedPreferences {
  SharedPreferencesSpy.setInt(bool value) {
    mockSetInt(value);
  }

  SharedPreferencesSpy.getInt(int? value) {
    mockGetInt(value);
  }

  SharedPreferencesSpy.remove(bool value) {
    mockRemove(value);
  }

  //region setInt
  When mockSetIntCall() => when(() => setInt(any(), any()));
  void mockSetInt(bool value) => mockSetIntCall().thenAnswer((_) => Future.value(value));
  void mockSetIntError({Exception? error}) => mockSetIntCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region getInt
  When mockGetIntCall() => when(() => getInt(any()));
  void mockGetInt(int? value) => mockGetIntCall().thenReturn(value);
  void mockGetIntError({Exception? error}) => mockGetIntCall().thenThrow(error ?? Exception("any_message"));
  //endregion

  //region remove
  When mockRemoveCall() => when(() => remove(any()));
  void mockRemove(bool value) => mockRemoveCall().thenAnswer((_) => Future.value(value));
  void mockRemoveError({Exception? error}) => mockRemoveCall().thenThrow(error ?? Exception("any_message"));
  //endregion
}
