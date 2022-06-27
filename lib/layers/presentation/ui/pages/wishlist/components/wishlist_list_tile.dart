import 'package:flutter/material.dart';

import '../../../../viewmodels/wishlist_viewmodel.dart';

class WishlistListTile extends StatefulWidget {
  final WishlistViewModel viewModel;
  final VoidCallback onTap;

  const WishlistListTile({
    Key? key,
    required this.viewModel,
    required this.onTap,
  }) : super(key: key);

  @override
  State<WishlistListTile> createState() => _WishlistListTileState();
}

class _WishlistListTileState extends State<WishlistListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      contentPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
      title: Text(widget.viewModel.description!),
      subtitle: Text(
        widget.viewModel.tag?.name ?? "",
        style: TextStyle(
          color: Color(widget.viewModel.tag?.color ?? 0),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 32,
      ),
    );
  }
}
