import 'package:flutter/material.dart';

import '../../../components/sized_box_default.dart';

class HeaderWidget extends StatelessWidget {
  final String text;

  const HeaderWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBoxDefault(2),
        Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
