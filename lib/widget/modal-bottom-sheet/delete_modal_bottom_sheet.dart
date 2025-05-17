import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../utils/strings.dart';

class DeleteModalBottomSheet extends StatelessWidget {
  const DeleteModalBottomSheet({
    super.key,
    required this.onTap,
    this.text
  });

  final void Function() onTap;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text != null ? text! : Strings.delete, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.red)),
                Icon(FontAwesomeIcons.trash, color: Colors.red)
              ]
            )
          ),

          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(Strings.cancel),
                Icon(FontAwesomeIcons.circleXmark)
              ]
            )
          )
        ]
      )
    );
  }
}
