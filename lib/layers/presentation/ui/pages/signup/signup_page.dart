import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../i18n/resources.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../../components/text_field_default.dart';
import '../widgets/button_login_with_widget.dart';
import '../widgets/divider_or_widget.dart';
import '../widgets/header_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeaderWidget(text: R.string.register),
                      const SizedBoxDefault(4),
                      ButtonLoginWithWidget(
                        text: R.string.signupWithGoogle,
                        icon: SvgPicture.asset(
                          "assets/icons/google.svg",
                          width: 22,
                          height: 22,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          // TODO: Implementar Entrar com o Google
                          // TODO: Ícone do Google
                        },
                      ),
                      const SizedBox(height: 18),
                      const DividerOrWidget(),
                      const SizedBox(height: 18),
                      TextFieldDefault(
                        label: R.string.name,
                        hint: R.string.nameHint,
                      ),
                      const SizedBoxDefault(2),
                      TextFieldDefault(
                        label: R.string.email,
                        hint: R.string.emailHint,
                      ),
                      const SizedBoxDefault(5),
                      ElevatedButton(
                        child: Text(R.string.advance),
                        onPressed: () {
                          // TODO: Implementar Avançar
                        },
                      ),
                      const SizedBoxDefault(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(R.string.alreadyHaveAccount, style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16)),
                          TextButton(
                            child: Text(R.string.makeLogin, style: const TextStyle(fontSize: 16)),
                            onPressed: () {
                              // TODO: Implementar cadastrar-se
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
