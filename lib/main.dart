import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'di/injection.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Injection().setup();

  runApp(const AppTheme());
}
