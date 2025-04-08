import 'dart:io';

import 'package:flutter/material.dart';

import '../model/ServiceDto.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
    required this.serviceDto,
    this.onChangeImage,
    this.onTap,
    this.onLongPress,
    this.image
  });

  final ServiceDto serviceDto;
  final void Function()? onChangeImage;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
          alignment: onChangeImage == null ? Alignment.bottomLeft : Alignment.bottomRight,
          padding: const EdgeInsets.all(10),
          height: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                  image: image == null
                      ? AssetImage('assets/images/login-image.jpeg') // todo prendere l'immagine dal dto e usare NetworkImage
                      : FileImage(image!),
                  fit: BoxFit.cover
              )
          ),
          child: onChangeImage == null
              ? Text(serviceDto.name, style: Theme.of(context).textTheme.labelLarge)
              : GestureDetector(
                  onTap: onChangeImage,
                  child: CircleAvatar(
                    child: Icon(Icons.change_circle_rounded, size: 16),
                  )
                )

      )
    );
  }
}
