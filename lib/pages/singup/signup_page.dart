import 'package:fiv/pages/login/login_page.dart';
import 'package:fiv/pages/singup/component/signup_provider.dart';
import 'package:fiv/widgets/custom_textfield_widget.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  bool isObsecure = true;
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    SignupAuthProvider signupAuthProvider =
        Provider.of<SignupAuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Sign Up'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    LottieBuilder.asset(
                      'assets/signup.json',
                      height: 300,
                      repeat: false,
                      // reverse: true,
                    ),
                    // TextFormField(
                    //   controller: fullName,
                    //   decoration: const InputDecoration(hintText: "Full name"),
                    // ),
                    CustomTextFieldWidget(
                        keyboardType: TextInputType.name,
                        hintText: 'Full Name',
                        controller: fullName),
                    // TextFormField(
                    //   controller: email,
                    //   decoration:
                    //       const InputDecoration(hintText: "Email address"),
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: CustomTextFieldWidget(
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Email Address',
                          controller: email),
                    ),
                    // TextFormField(
                    //   controller: location,
                    //   decoration: const InputDecoration(hintText: "Location"),
                    // ),
                    CustomTextFieldWidget(
                        keyboardType: TextInputType.streetAddress,
                        hintText: 'Location',
                        controller: location),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: password,
                        obscureText: isObsecure,
                        // keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObsecure = !isObsecure; // Toggle the value
                              });
                            },
                            icon: Icon(
                              isObsecure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          fillColor: Colors.white70,
                        ),
                      ),
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('MIT'),
                      value: 'MIT',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('NITTE'),
                      value: 'NITTE',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.all(0),
                      title: const Text('MVIT'),
                      value: 'MVIT',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    signupAuthProvider.loading == false
                        ? MyButton(
                            onPressed: () {
                              if (selectedOption != null) {
                                signupAuthProvider.signupVaidation(
                                    emailAdress: email,
                                    fullName: fullName,
                                    password: password,
                                    college: selectedOption!,
                                    context: context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please select a College"),
                                  ),
                                );
                              }
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
      ),
    );
  }
}
