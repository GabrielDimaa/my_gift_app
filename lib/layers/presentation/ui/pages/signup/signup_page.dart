import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/signup/getx_signup_presenter.dart';
import '../../components/dialogs/error_dialog.dart';
import '../../components/form/text_field_default.dart';
import '../../components/form/validators/input_validators.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../login/widgets/button_login_with_widget.dart';
import '../login/widgets/divider_or_widget.dart';
import '../login/widgets/header_widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GetxSignupPresenter presenter = Get.find<GetxSignupPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const PaddingDefault(),
          child: Column(
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
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        onPressed: () async {
                          try {
                            await presenter.signupWithGoogle();
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
                              label: R.string.name,
                              hint: R.string.nameHint,
                              controller: _nameController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.name,
                              onSaved: presenter.viewModel.setName,
                              validator: InputRequiredValidator().validate,
                            ),
                            const SizedBoxDefault(2),
                            TextFieldDefault(
                              label: R.string.email,
                              hint: R.string.emailHint,
                              controller: _emailController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.emailAddress,
                              onSaved: presenter.viewModel.setEmail,
                              validator: InputEmailValidator().validate,
                              textCapitalization: TextCapitalization.none,
                            ),
                          ],
                        ),
                      ),
                      const SizedBoxDefault(5),
                      ElevatedButton(
                        child: Text(R.string.advance),
                        onPressed: () async => await _advance(),
                      ),
                      const SizedBoxDefault(2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(R.string.alreadyHaveAccount, style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 16)),
                          TextButton(
                            child: Text(R.string.makeLogin, style: const TextStyle(fontSize: 16)),
                            onPressed: () async => await presenter.navigateToLogin(),
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

  Future<void> _advance() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await presenter.navigateToSignupPassword();
    }
  }
}
