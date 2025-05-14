import 'package:beauty_center_frontend/widget/modal-bottom-sheet/login_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 50),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login-image.jpeg'),
          fit: BoxFit.cover
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    transitionAnimationController: AnimationController(
                        vsync: Navigator.of(context),
                        duration: Duration(milliseconds: 750)
                    ),
                    builder: (context) {
                      return LoginModalBottomSheet();
                    }
                );
              },
              child: Text(Strings.log_in)
          )
        ]
      )
    );
  }
}
