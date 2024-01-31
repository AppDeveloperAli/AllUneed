import 'package:fiv/pages/login/login_page.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:flutter/material.dart';

import '../../../appColors/app_colors.dart';
import '../../singup/signup_page.dart';

class EndPart extends StatelessWidget {
  const EndPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyButton(
          onPressed: () {
            RoutingPage.goTonext(
              context: context,
              navigateTo: const LoginPage(),
            );
          },
          text: "LOG IN",
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            RoutingPage.goTonext(
              context: context,
              navigateTo: const SignupPage(),
            );
          },
          child: const Text(
            "SIGNUP",
            style: TextStyle(
              color: AppColors.KgreyColor,
            ),
          ),
        )
      ],
    );
  }
}
