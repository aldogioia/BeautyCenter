import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.onChanged,
    this.controller,
    this.validator,
    this.keyboardType,
    this.initialValue,
    this.prefixIcon,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled
  });

  final String? labelText;
  final String? hintText;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? initialValue;
  final bool readOnly;
  final IconData? prefixIcon;
  final bool? enabled;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      initialValue: widget.initialValue,
      obscureText: widget.obscureText,
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: Theme.of(context).textTheme.bodySmall,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        prefixIcon: widget.prefixIcon != null ? Icon(Icons.search, size: 16) : null
      ),
    );
  }
}
