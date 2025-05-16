import 'package:beauty_center_frontend/security/secure_storage.dart';
import 'package:flutter/material.dart';

import '../../utils/Strings.dart';

class NotificationModalBottomSheet extends StatefulWidget {
  const NotificationModalBottomSheet({
    super.key,
    required this.enabled
  });

  final bool enabled;

  @override
  State<NotificationModalBottomSheet> createState() => _NotificationModalBottomSheetState();
}

class _NotificationModalBottomSheetState extends State<NotificationModalBottomSheet> {
  late bool _enabled;


  @override
  void initState() {
    _enabled = widget.enabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        spacing: 25,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(Strings.notifications, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.left),

          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(Strings.receive_notifications),

              Switch(
                value: _enabled,
                onChanged: (value) async {
                  setState(() => _enabled = !_enabled);
                  await SecureStorage.saveNotificationsEnabled(_enabled);
                }
              )
            ]
          )
        ]
      )
    );
  }
}
