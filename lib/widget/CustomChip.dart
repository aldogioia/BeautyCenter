import 'package:flutter/material.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected
  });

  final String text;
  final void Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    Color background = Theme.of(context).colorScheme.surface;
    Color border = Theme.of(context).inputDecorationTheme.enabledBorder!.borderSide.color;
    double borderWidth = 1;

    if(isSelected){
      background = Theme.of(context).colorScheme.primary.withAlpha((255 * 0.25).toInt());
      border = background;
      borderWidth = 0;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: background,
          border: Border.all(color: border, width: borderWidth)
        ),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall)
      )
    );
  }
}
