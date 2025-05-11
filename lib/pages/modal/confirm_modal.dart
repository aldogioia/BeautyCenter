import 'package:flutter/material.dart';

class ConfirmModal extends StatelessWidget {
  final String text1;
  final String text2;
  final IconData icon;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmModal({
    super.key,
    required this.text1,
    required this.text2,
    required this.icon,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          GestureDetector(
            onTap: onConfirm,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text1,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red
                    )
                  ),
                  Icon(icon, color: Colors.red)
                ]
              )
            )
          ),
          GestureDetector(
            onTap: onCancel,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text2,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    )
                  ),
                  Icon(Icons.sentiment_satisfied_rounded)
                ]
              )
            )
          )
        ]
      )
    );
  }
}