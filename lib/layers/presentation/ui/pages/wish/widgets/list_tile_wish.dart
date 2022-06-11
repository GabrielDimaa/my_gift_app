import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../../extensions/double_extension.dart';
import '../../../../viewmodels/wish_viewmodel.dart';
import '../../../components/sized_box_default.dart';
import 'wish_without_image.dart';

class ListTileWish extends StatelessWidget {
  final WishViewModel viewModel;
  final VoidCallback? onTap;

  const ListTileWish({Key? key, required this.viewModel, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(4),
      onTap: onTap,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageWish(viewModel.image),
          const SizedBoxDefault.horizontal(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.description!),
                Text(
                  "${viewModel.priceRangeInitial!.money} - ${viewModel.priceRangeFinal!.money}",
                  style: Theme.of(context).textTheme.caption?.copyWith(fontWeight: FontWeight.w500, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBoxDefault.horizontal(),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }

  Widget _imageWish(String? image) {
    if (image == null) {
      return const WishWithoutImage();
    } else {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: (Uri.tryParse(image)?.isAbsolute ?? false)
            ? Image.network(
                image,
                height: 70,
                width: 70,
              )
            : Image.file(
                File(image),
                height: 70,
                width: 70,
              ),
      );
    }
  }
}
