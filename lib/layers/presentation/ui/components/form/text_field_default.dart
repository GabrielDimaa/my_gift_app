import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldDefault extends StatelessWidget {
  final String? label;
  final String hint;
  final TextEditingController controller;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool? enabled;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final int? minLines;
  final int? maxLines;

  const TextFieldDefault({
    Key? key,
    this.label,
    required this.hint,
    required this.controller,
    this.onSaved,
    this.validator,
    this.enabled,
    this.inputFormatters,
    this.obscureText = false,
    this.textInputAction,
    this.keyboardType,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.sentences,
    this.minLines,
    this.maxLines,
  }) : super(key: key);

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
          controller: controller,
          onSaved: (String? value) {
            onSaved?.call((value?.isEmpty ?? true) ? null : value);
          },
          validator: validator,
          enabled: enabled,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hint,
          ),
          minLines: minLines,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
