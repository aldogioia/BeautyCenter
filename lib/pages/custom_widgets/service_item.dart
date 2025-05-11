import 'package:flutter/material.dart';

import '../../model/service_dto.dart';

class ServiceItem extends StatelessWidget {
  final ServiceDto service;
  const ServiceItem({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.bottomCenter,
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
            right: 0,
            bottom: 0,
            left: 0,
            top: 0,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            left: 10,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                  Text(
                    "${service.price}0€",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                ]
            )
          ),
        ],
      ),
    );
  }
}
