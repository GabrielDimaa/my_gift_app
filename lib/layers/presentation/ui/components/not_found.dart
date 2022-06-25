import 'package:desejando_app/layers/presentation/ui/components/sized_box_default.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NotFound extends StatelessWidget {
  final String message;

  const NotFound({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        AspectRatio(
          aspectRatio: 2 / 1,
          child: SvgPicture.asset("assets/images/not_found.svg"),
        ),
        const SizedBoxDefault(2),
        Text(
          message,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
