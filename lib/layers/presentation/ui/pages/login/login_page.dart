import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/login/getx_login_presenter.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../../components/form/text_field_default.dart';
import '../widgets/button_login_with_widget.dart';
import '../widgets/divider_or_widget.dart';
import '../widgets/header_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GetxLoginPresenter _presenter = Get.find<GetxLoginPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                      HeaderWidget(text: R.string.login),
                      const SizedBoxDefault(4),
                      ButtonLoginWithWidget(
                        text: R.string.loginWithGoogle,
                        icon: SvgPicture.asset(
                          "assets/icons/google.svg",
                          width: 22,
                          height: 22,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () async {
                          try {
                            await _presenter.loginWithGoogle();
                          } catch (e) {
                            ErrorDialog.show(context: context, content: e.toString());
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      const DividerOrWidget(),
                      const SizedBox(height: 18),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFieldDefault(
                              label: R.string.email,
                              hint: R.string.emailHint,
                              controller: _emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: _presenter.viewModel.setEmail,
                              validator: InputEmailValidator().validate,
                            ),
                            const SizedBoxDefault(2),
                            TextFieldDefault(
                              label: R.string.password,
                              hint: R.string.passwordHint,
                              controller: _passwordController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              onSaved: _presenter.viewModel.setPassword,
                              validator: InputRequiredValidator().validate,
                            ),
                          ],
                        ),
                      ),
                      const SizedBoxDefault(5),
                      ElevatedButton(
                        child: Text(R.string.enter),
                        onPressed: () async => await _login(),
                      ),
                      const SizedBoxDefault(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(R.string.doNotHaveAccount, style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16)),
                          TextButton(
                            child: Text(R.string.register, style: const TextStyle(fontSize: 16)),
                            onPressed: () async => await _presenter.navigateToSignUp(),
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

  Future<void> _login() async {
    if (_presenter.loading) return;

    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        await _presenter.login();
      }
    } catch(e) {
      ErrorDialog.show(context: context, content: e.toString());
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
