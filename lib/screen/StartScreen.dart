import 'package:beauty_center_frontend/widget/CustomButton.dart';
import 'package:flutter/material.dart';

import '../utils/strings.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/login-image.jpeg'),
          fit: BoxFit.cover
        )
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: Strings.access,
                    onPressed: () => Navigator.pushNamed(context, "/login"),
                  ),

                  const SizedBox(height: 50),

                  GestureDetector(
                    onTap: () {},       // todo
                    child: Text(
                      Strings.first_access,
                      style: Theme.of(context).textTheme.labelSmall
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
    );
  }
}
