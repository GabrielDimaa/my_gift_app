import 'package:flutter/material.dart';

abstract class ErrorDialog {
  static Future<void> show({required BuildContext context, required String content}) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ooops"),
        content: Text(content.replaceAll("Exception: ", "").replaceAll("Exception", "")),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok", style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondary)),
          ),
        ],
      ),
    );
  }
}
