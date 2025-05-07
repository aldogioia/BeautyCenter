import 'package:flutter/material.dart';

import '../../utils/Strings.dart';

class NotificationsModal extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationsModal({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          Text(Strings.notification, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ricevi notifiche",
                  style: TextStyle(
                    fontWeight: FontWeight.w700
                  )
                ),
                Switch(value: value, onChanged: onChanged)
              ]
            )
          )
        ]
      )
    );
  }
}