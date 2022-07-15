import 'package:flutter_test/flutter_test.dart';
import 'package:my_gift_app/firebase_options.dart';

void main() {
  test("Verifica se as configurações do firebase são a de produção", () {
    expect(DefaultFirebaseOptions.isProd, true);
  });
}