import 'package:fiv/appColors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TopPart extends StatelessWidget {
  const TopPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            LottieBuilder.asset(
              'assets/login.json',
              height: 350,
              repeat: true,
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ],
    );
  }
}
