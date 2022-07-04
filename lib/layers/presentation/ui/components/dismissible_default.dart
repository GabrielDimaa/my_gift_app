import 'package:flutter/material.dart';

class DismissibleDefault<T> extends StatelessWidget {
  final T valueKey;
  final Widget child;
  final void Function(DismissDirection)? onDismissed;
  final Future<bool> Function(DismissDirection)? confirmDismiss;

  const DismissibleDefault({
    Key? key,
    required this.valueKey,
    required this.child,
    this.onDismissed,
    this.confirmDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<T>(valueKey),
      direction: onDismissed != null ? DismissDirection.startToEnd : DismissDirection.none,
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
      child: child,
    );
  }
}
