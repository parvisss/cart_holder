import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showCustomDialog(
              context: context,
              title: 'Hello',
              content: 'This is a custom dialog.',
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            );
          },
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }
}

void showCustomDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onPressed,
  String buttonText = 'OK',
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
