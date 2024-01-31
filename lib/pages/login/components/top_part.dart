import 'package:fiv/appColors/app_colors.dart';
import 'package:flutter/material.dart';

class TopPart extends StatelessWidget {
  const TopPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "images/logo.jpg",
                scale: 8,
              ),
            ),
            const SizedBox(
              height: 7,
            ),
            const Text(
              "Login",
              style: TextStyle(
                color: AppColors.KblackColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ],
    );
  }
}
