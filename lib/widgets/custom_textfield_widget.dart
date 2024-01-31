import 'package:flutter/material.dart';

class CustomTextFieldWidget extends StatelessWidget {
  TextEditingController? controller;
  String hintText;
  CustomTextFieldWidget({super.key, required this.hintText, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        filled: true,
        hintStyle: TextStyle(color: Colors.grey[800]),
        fillColor: Colors.white70,
      ),
    );
  }
}
