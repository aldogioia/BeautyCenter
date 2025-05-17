import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/summary_operator_dto.dart';


class OperatorItem extends StatelessWidget {
  final bool isSelected;
  final SummaryOperatorDto operator;
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
              CachedNetworkImage(
                imageUrl: operator.imgUrl,
                fit: BoxFit.cover,
                width: 150,
                height: 200,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  width: 150,
                  height: 200,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  width: 150,
                  height: 200,
                  alignment: Alignment.center,
                  child: const FaIcon(FontAwesomeIcons.solidFaceSadTear)
                ),
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
              Text(operator.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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