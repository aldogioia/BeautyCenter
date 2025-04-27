import 'package:flutter/material.dart';

import '../../model/OperatorDto.dart';


class OperatorItem extends StatelessWidget {
  final bool isSelected;
  final OperatorDto operator;
  const OperatorItem({super.key, required this.isSelected, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.network(
                operator.imgUrl,
                fit: BoxFit.cover,
                width: 150,
                height: 200,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey,
                    width: 150,
                    height: 200,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    width: 150,
                    height: 200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.image_not_supported)
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
              Text(operator.name, textAlign: TextAlign.center),
              if(isSelected)
                Positioned(
                  right: 5,
                  top: 5,
                  child: Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                )
            ],
          )
        )
      ]
    );
  }
}