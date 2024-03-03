// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiv/pages/homepage/home_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:fiv/widgets/snackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedScreen extends StatelessWidget {
  String? orderID, deliveryPasscode;
  OrderPlacedScreen(
      {super.key, required this.orderID, required this.deliveryPasscode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LottieBuilder.asset(
              'assets/orderPlaced.json',
              repeat: false,
              height: 300,
            ),
            Text(
              'Order ID : $orderID',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 25, color: Colors.red),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Delivery Passcode : $deliveryPasscode',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.red),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Please note your Order ID and Passcode\n which you use for getting your parcel.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Thanks for your placement\nWe will deliver your order in few hours.',
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: MyButton(
                // onPressed: () => openCheckout(),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(builder: (context) => const HomePage()),
                    (route) => false,
                  );
                },
                text: "Back to Home",
              ),
            ),
          ],
        ),
      )),
    );
  }
}
