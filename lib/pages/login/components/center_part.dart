import 'package:fiv/widgets/custom_textfield_widget.dart';
import 'package:flutter/material.dart';

class CenterPart extends StatelessWidget {
  final TextEditingController? email;
  final TextEditingController? password;
  final bool obscureText;
  final Widget icon;
  final void Function()? onPressed;
  const CenterPart({
    required this.obscureText,
    required this.icon,
    required this.email,
    required this.password,
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFieldWidget(hintText: 'Email', controller: email!),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextFormField(
            controller: password,
            decoration: InputDecoration(
              hintText: "Password",
              suffixIcon: IconButton(
                onPressed: onPressed,
                icon: icon,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              filled: true,
              hintStyle: TextStyle(color: Colors.grey[800]),
              fillColor: Colors.white70,
            ),
          ),
        )
      ],
    );
  }
}
