import 'package:flutter/material.dart';


class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.text,
    this.imgUrl,
    this.onTap,
    this.onLongPress
  });

  final String text;
  final String? imgUrl;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
        ),
        child:  Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if(imgUrl != null) ...[
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(imgUrl!),    // todo usare imageNetwork
                      fit: BoxFit.cover
                    )
                  )
                ),

                const SizedBox(width: 10),
              ],

              Text(
                text,
                style: Theme.of(context).textTheme.labelMedium,
              )
            ]
        ),
      ),
    );
  }
}
