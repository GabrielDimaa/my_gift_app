import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../../components/text_field_default.dart';

class SignupPasswordPage extends StatefulWidget {
  const SignupPasswordPage({Key? key}) : super(key: key);

  @override
  _SignupPasswordPageState createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.password),
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBoxDefault(3),
                      TextFieldDefault(
                        label: R.string.password,
                        hint: R.string.passwordHint,
                      ),
                      const SizedBoxDefault(3),
                      TextFieldDefault(
                        label: R.string.confirmPassword,
                        hint: R.string.confirmPasswordHint,
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(R.string.advance),
                onPressed: () {
                  // TODO: Implementar Avançar
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
