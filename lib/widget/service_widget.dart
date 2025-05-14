import 'dart:io';

import 'package:flutter/material.dart';

import '../model/ServiceDto.dart';

class ServiceWidget extends StatelessWidget {
  const ServiceWidget({
    super.key,
    required this.serviceDto,
    this.onChangeImage,
    this.onTap,
    this.image
  });

  final ServiceDto serviceDto;
  final void Function()? onChangeImage;
  final void Function()? onTap;
  final File? image;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if(image == null){
      imageWidget = Image.network(
        serviceDto.imgUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey,
            height: 150,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
              color: Colors.grey,
              height: 150,
              alignment: Alignment.center,
              child: const Icon(Icons.image_not_supported)
          );
        },
      );
    } else {
      imageWidget = Image.file(
        image!,
        width: double.infinity,
        height: 150,
        fit: BoxFit.cover,
      );
    }


    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            imageWidget,
            if(onChangeImage == null) ...[
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black54],
                    )
                  )
                )
              ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(serviceDto.name, style: Theme.of(context).textTheme.bodyLarge)
              )
            ] else ...[
              Positioned(
                  right: 10,
                  bottom: 10,
                  child: GestureDetector(
                      onTap: onChangeImage,
                      child: CircleAvatar(
                        child: Icon(Icons.change_circle_rounded, size: 16),
                      )
                  )
              )
            ]
          ],
        ),
      )
    );
  }
}
