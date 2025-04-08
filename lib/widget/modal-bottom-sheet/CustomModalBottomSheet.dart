import 'package:flutter/material.dart';

class CustomModalBottomSheet {
  static void show({required Widget child, required BuildContext context}){
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        // todo da rimuovere?
        transitionAnimationController: AnimationController(
            vsync: Navigator.of(context),
            duration: Duration(milliseconds: 750)
        ),
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          color: Theme.of(context).colorScheme.surface
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 2,
                              color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                            ),

                            const SizedBox(height: 25),

                            child
                          ]
                      )
                  )
              )
            )
          );
        }
    );
  }
}
