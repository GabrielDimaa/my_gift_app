import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/login/getx_login_presenter.dart';
import '../../../presenters/login/login_presenter.dart';
import '../../components/sized_box_default.dart';
import '../../components/text_field_default.dart';
import '../widgets/button_login_with_widget.dart';
import '../widgets/divider_or_widget.dart';
import '../widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //final LoginPresenter presenter = Get.find<GetxLoginPresenter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      HeaderWidget(text: R.string.login),
                      const SizedBoxDefault(4),
                      ButtonLoginWithWidget(
                        text: R.string.loginWithGoogle,
                        icon: Icons.facebook,
                        onPressed: () {
                          // TODO: Implementar Entrar com o Google
                          // TODO: Ícone do Google
                        },
                      ),
                      const SizedBox(height: 18),
                      const DividerOrWidget(),
                      const SizedBox(height: 18),
                      TextFieldDefault(
                        label: R.string.email,
                        hint: R.string.emailHint,
                      ),
                      const SizedBoxDefault(2),
                      TextFieldDefault(
                        label: R.string.password,
                        hint: R.string.passwordHint,
                      ),
                      const SizedBoxDefault(5),
                      ElevatedButton(
                        child: Text(R.string.enter),
                        onPressed: () {
                          // TODO: Implementar Entrar
                        },
                      ),
                      const SizedBoxDefault(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(R.string.doNotHaveAccount, style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16)),
                          TextButton(
                            child: Text(R.string.register, style: const TextStyle(fontSize: 16)),
                            onPressed: () {
                              // TODO: Implementar cadastrar-se
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
