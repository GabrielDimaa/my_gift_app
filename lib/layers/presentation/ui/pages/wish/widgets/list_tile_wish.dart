import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../../../../extensions/double_extension.dart';
import '../../../../viewmodels/wish_viewmodel.dart';
import '../../../components/sized_box_default.dart';
import 'wish_without_image.dart';

class ListTileWish extends StatelessWidget {
  final WishViewModel viewModel;
  final VoidCallback? onTap;
  final void Function(DismissDirection)? onDismissed;
  final Future<bool> Function(DismissDirection)? confirmDismiss;

  const ListTileWish({
    Key? key,
    required this.viewModel,
    required this.onTap,
    this.onDismissed,
    this.confirmDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<WishViewModel>(viewModel),
      direction: DismissDirection.startToEnd,
      onDismissed: onDismissed,
      confirmDismiss: confirmDismiss,
      background: Container(
        color: Colors.redAccent,
        child: const Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
