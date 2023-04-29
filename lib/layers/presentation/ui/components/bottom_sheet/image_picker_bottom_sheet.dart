import 'package:flutter/material.dart';

import '../../../../../i18n/resources.dart';
import '../sized_box_default.dart';
import './bottom_sheet_default.dart';

class ImagePickerBottomSheet extends StatelessWidget {
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  const ImagePickerBottomSheet({
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
      child: ImagePickerBottomSheet(
        onPressedCamera: onPressedCamera,
        onPressedGallery: onPressedGallery,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
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
      ),
    );
  }

  Widget _buttonRounded(BuildContext context, IconData icon, String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.background,
        fixedSize: const Size(90, 90),
        elevation: 0,
        shape: const CircleBorder(side: BorderSide(color: Color(0xFF464646), width: 1.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 30, color: Theme.of(context).colorScheme.onBackground),
          Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
