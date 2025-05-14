import 'package:flutter/material.dart';

import '../model/SummaryOperatorDto.dart';

class OperatorWidget extends StatelessWidget {
  const OperatorWidget({
    super.key,
    required this.isSelected,
    required this.operator,
    required this.onTap
  });

  final bool isSelected;
  final SummaryOperatorDto operator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: ClipRRect(
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
    );
  }
}


