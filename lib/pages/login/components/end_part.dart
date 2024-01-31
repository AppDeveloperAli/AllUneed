import 'package:fiv/pages/singup/signup_page.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:flutter/material.dart';

class EndPart extends StatelessWidget {
  final void Function()? onPressed;
  final bool loading;
  const EndPart({
    required this.loading,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        loading == true
            ? const CircularProgressIndicator()
            : MyButton(
                onPressed: onPressed,
                text: "LOG IN",
              ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SignupPage(),
              ),
            );
            // RoutingPage.goTonext(
            //   context: context,
            //   navigateTo: const SignupPage(),
            // );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?\t\t"),
              Text("SIGN UP"),
            ],
          ),
        )
      ],
    );
  }
}
