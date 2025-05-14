import 'package:flutter/material.dart';


class RowItem extends StatelessWidget {
  const RowItem({
    super.key,
    required this.text,
    this.imgUrl,
    this.onTap,
    this.icon
  });

  final String text;
  final String? imgUrl;
  final IconData? icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imgUrl!,
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey,
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 10,
                          height: 10,
                          child: const CircularProgressIndicator(strokeWidth: 1),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                          color: Colors.grey,
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          child: const Icon(Icons.image_not_supported)
                      );
                    },
                  )
                ),

                const SizedBox(width: 10),
              ],

              if(icon != null) ...[
                Icon(icon!, size: 24, color: Theme.of(context).colorScheme.primary),

                const SizedBox(width: 10)
              ],

              Text(text)
            ]
        ),
      ),
    );
  }
}
