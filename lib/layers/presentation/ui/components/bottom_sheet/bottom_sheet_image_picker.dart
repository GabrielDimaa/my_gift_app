import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../sized_box_default.dart';
import './bottom_sheet_default.dart';

class BottomSheetImagePicker extends StatelessWidget {
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  const BottomSheetImagePicker({
    Key? key,
    required this.onPressedCamera,
    required this.onPressedGallery,
  }) : super(key: key);

  static Future<void> show({
    required BuildContext context,
    String? title,
    required VoidCallback onPressedCamera,
    required VoidCallback onPressedGallery,
  }) async {
    await BottomSheetDefault.show(
      context: context,
      title: title,
      child: BottomSheetImagePicker(
        onPressedCamera: onPressedCamera,
        onPressedGallery: onPressedGallery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buttonRounded(
          context,
          Icons.photo_camera_outlined,
          R.string.camera,
          onPressedCamera,
        ),
        const SizedBoxDefault.horizontal(),
        _buttonRounded(
          context,
          Icons.image_outlined,
          R.string.gallery,
          onPressedGallery,
        ),
      ],
    );
  }

  Widget _buttonRounded(BuildContext context, IconData icon, String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).colorScheme.background,
        fixedSize: const Size(100, 100),
        elevation: 0,
        shape: const CircleBorder(side: BorderSide(color: Color(0xFF464646), width: 1.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.onBackground),
          Text(text, style: Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
