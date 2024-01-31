import 'package:fiv/pages/login/login_page.dart';
import 'package:fiv/pages/singup/component/signup_provider.dart';
import 'package:fiv/widgets/custom_textfield_widget.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController location = TextEditingController();

  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SignupAuthProvider signupAuthProvider =
        Provider.of<SignupAuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  // TextFormField(
                  //   controller: fullName,
                  //   decoration: const InputDecoration(hintText: "Full name"),
                  // ),
                  CustomTextFieldWidget(
                      hintText: 'Full Name', controller: fullName),
                  // TextFormField(
                  //   controller: email,
                  //   decoration:
                  //       const InputDecoration(hintText: "Email address"),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: CustomTextFieldWidget(
                        hintText: 'Email Address', controller: email),
                  ),
                  // TextFormField(
                  //   controller: location,
                  //   decoration: const InputDecoration(hintText: "Location"),
                  // ),
                  CustomTextFieldWidget(
                      hintText: 'Location', controller: location),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: TextFormField(
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        fillColor: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  signupAuthProvider.loading == false
                      ? MyButton(
                          onPressed: () {
                            signupAuthProvider.signupVaidation(
                                emailAdress: email,
                                fullName: fullName,
                                password: password,
                                context: context);
                          },
                          text: "SIGN UP",
                        )
                      : const Center(child: CircularProgressIndicator()),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account?\t\t"),
                        Text("LOGIN")
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
