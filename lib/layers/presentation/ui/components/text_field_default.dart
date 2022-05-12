import 'package:flutter/material.dart';

class TextFieldDefault extends StatelessWidget {
  final String? label;
  final String hint;

  const TextFieldDefault({Key? key, this.label, required this.hint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 10),
            child: Text(label!),
          ),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
