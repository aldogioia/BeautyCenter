import 'package:flutter/material.dart';

import '../../model/ServiceDto.dart';

class ServiceItem extends StatelessWidget {
  final ServiceDto service;
  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        children: [
          Image.network(
            service.imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 150,
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
                child: const Icon(Icons.broken_image, size: 40, color: Colors.white54),
              );
            },
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              service.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
                shadows: [
                  Shadow(blurRadius: 5, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
