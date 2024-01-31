import 'package:fiv/pages/welcome/components/center_part.dart';
import 'package:fiv/pages/welcome/components/top_part.dart';
import 'package:flutter/material.dart';
import 'components/end_part.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              //top part
              TopPart(),
              //Center PArt
              CenterPart(),
              // end part
              EndPart(),
            ],
          ),
        ),
      ),
    );
  }
}
