import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker extends FormField<File?> {
  CustomImagePicker({
    super.key,
    super.onSaved,
    super.validator,
    super.initialValue,
    required double height,
    void Function(File?)? onImagePick,
    double? width
  }) : super(
    builder: (FormFieldState<File?> state) {
      return _CustomImagePickerWidget(state, height: height, width: width, onImagePick: onImagePick);
    },
  );
}

class _CustomImagePickerWidget extends StatefulWidget {
  final FormFieldState<File?> state;
  const _CustomImagePickerWidget(
      this.state,
      {
        required this.height,
        this.width,
        this.onImagePick
      }
  );

  final double height;
  final double? width;
  final void Function(File?)? onImagePick;

  @override
  _CustomImagePickerWidgetState createState() => _CustomImagePickerWidgetState();
}

class _CustomImagePickerWidgetState extends State<_CustomImagePickerWidget> {
  final ImagePicker picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        widget.state.didChange(_image);
      });

      if(widget.onImagePick != null) widget.onImagePick!(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap:() async => await _pickImage(),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Theme.of(context).inputDecorationTheme.border!.borderSide.color),
              image: _image != null
                  ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                  : null,
            ),
            child: _image == null
                ? Center(child: CircleAvatar(child: Icon(FontAwesomeIcons.circlePlus, size: 16)))
                : null,
          )
        ),

        if (widget.state.hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.state.errorText ?? '',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            )
          )
      ]
    );
  }
}
