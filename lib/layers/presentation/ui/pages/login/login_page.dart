import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/login/getx_login_presenter.dart';
import '../../../presenters/login/login_presenter.dart';
import '../../components/sized_box_default.dart';
import '../../components/text_field_default.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginPresenter presenter = Get.find<GetxLoginPresenter>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
                      const SizedBoxDefault(2),
                      Text(
                        R.string.login,
                        style: textTheme.headline4,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBoxDefault(4),
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          // TODO: Implementar Entrar com o Google
                          // TODO: Ícone do Google
                        },
                        child: Ink(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFF464646), width: 2),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.facebook),
                              const SizedBoxDefault.horizontal(),
                              Text(R.string.loginWithGoogle, style: textTheme.bodyText1),
                            ],
                          ),
                        ),
                      ),
                      const SizedBoxDefault(2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              R.string.loginOu,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                      const SizedBoxDefault(2),
                      TextFieldDefault(
                        label: R.string.email,
                        hint: R.string.emailHint,
                      ),
                      const SizedBoxDefault(3),
                      TextFieldDefault(
                        label: R.string.password,
                        hint: R.string.passwordHint,
                      ),
                      const SizedBoxDefault(4),
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
                          Text(R.string.doNotHaveAccount, style: textTheme.caption?.copyWith(fontSize: 16)),
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
