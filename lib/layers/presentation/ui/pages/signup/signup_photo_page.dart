import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../../components/app_bar/app_bar_default.dart';
import '../../components/padding/padding_default.dart';
import '../../components/sized_box_default.dart';

class SignupPhotoPage extends StatefulWidget {
  const SignupPhotoPage({Key? key}) : super(key: key);

  @override
  _SignupPhotoPageState createState() => _SignupPhotoPageState();
}

class _SignupPhotoPageState extends State<SignupPhotoPage> {
  double get radius => 18;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDefault(title: R.string.photo),
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
                      InkWell(
                        onTap: () {
                          // TODO: Implementar foto
                        },
                        borderRadius: BorderRadius.circular(radius),
                        child: Ink(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(radius),
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          child: DottedBorder(
                            color: Theme.of(context).colorScheme.onBackground,
                            strokeWidth: 2,
                            dashPattern: const [6, 5],
                            borderType: BorderType.RRect,
                            radius: Radius.circular(radius),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person_pin_outlined, size: 60),
                                const SizedBoxDefault(2),
                                Text(R.string.addPhotoProfile, textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: Text(R.string.createAccount),
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
