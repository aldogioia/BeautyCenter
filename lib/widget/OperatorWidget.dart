import 'package:flutter/material.dart';

import '../model/OperatorDto.dart';

class OperatorWidget extends StatelessWidget {
  const OperatorWidget({
    super.key,
    required this.isSelected,
    required this.operator,
    required this.onTap
  });

  final bool isSelected;
  final OperatorDto operator;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Color? background = isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.25) : null;
    final TextStyle? style = Theme.of(context).textTheme.displaySmall;

    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: background
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(operator.imgUrl),   // todo usare NetworkImage
                        fit: BoxFit.cover
                      )
                  )
                ),

                const SizedBox(height: 5),

                Text("${operator.name} ${operator.surname}", style: style)
              ]
            )
        )
    );
  }
}


