import 'package:flutter/material.dart';


class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width,
    this.height = 50,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.all(10),
    this.leading,
    this.textStyle,
    this.background
  });

  final void Function() onPressed;
  final String text;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets padding;
  final Icon? leading;
  final TextStyle? textStyle;
  final Color? background;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.background ?? Theme.of(context).colorScheme.primary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: widget.leading == null ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if(widget.leading != null) ...[
              widget.leading!,

              const SizedBox(width: 5)
            ],

            Text(
              widget.text,
              style: widget.textStyle ?? Theme.of(context).textTheme.displayMedium
            )
          ],
        )
      )
    );
  }
}
