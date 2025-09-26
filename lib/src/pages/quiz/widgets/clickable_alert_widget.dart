import 'package:flutter/material.dart';

class ClickableAlertWidget extends StatelessWidget {
  final Widget child;

  const ClickableAlertWidget({required this.child, super.key});

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: child,
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAlert(context),
      child: child,
    );
  }
}