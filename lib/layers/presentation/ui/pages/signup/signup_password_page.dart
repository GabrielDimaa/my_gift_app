import 'package:desejando_app/layers/presentation/ui/components/form/validators/input_validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../i18n/resources.dart';
import '../../../presenters/signup/getx_signup_presenter.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';
import '../../components/form/text_field_default.dart';

class SignupPasswordPage extends StatefulWidget {
  const SignupPasswordPage({Key? key}) : super(key: key);

  @override
  _SignupPasswordPageState createState() => _SignupPasswordPageState();
}

class _SignupPasswordPageState extends State<SignupPasswordPage> {
  final GetxSignupPresenter _presenter = Get.find<GetxSignupPresenter>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

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
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFieldDefault(
                              label: R.string.password,
                              hint: R.string.passwordHint,
                              controller: _passwordController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.visiblePassword,
                              onSaved: _presenter.viewModel.setPassword,
                              validator: InputPasswordValidator().validate,
                            ),
                            const SizedBoxDefault(3),
                            TextFieldDefault(
                              label: R.string.confirmPassword,
                              hint: R.string.confirmPasswordHint,
                              controller: _confirmPasswordController,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.visiblePassword,
                              onSaved: _presenter.viewModel.setConfirmPassword,
                              validator: InputConfirmPasswordValidator(_passwordController.text).validate,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(R.string.advance),
                onPressed: () async => await _advance(),
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
      await _presenter.navigateToSignupPhoto();
    }
  }
}
