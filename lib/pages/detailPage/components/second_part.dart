import 'package:fiv/pages/cartPage/cart_part.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../appColors/app_colors.dart';
import '../../../route/routing_page.dart';

class SecondPart extends StatelessWidget {
  final String productName;
  final double productPrice;
  // final double productOldPrice;
  final int productRate;
  final String productDescription;
  final String productId;
  final String productImage;
  final String productCategory;
  final String reamaining;
  const SecondPart({
    Key? key,
    required this.reamaining,
    required this.productCategory,
    required this.productImage,
    required this.productId,
    required this.productDescription,
    required this.productName,
    required this.productPrice,
    // required this.productOldPrice,
    required this.productRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  productName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "INR $productPrice",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "INR $productRate",
                    style: const TextStyle(
                        fontSize: 18,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red),
                  ),
                  Text(
                    "Piece $reamaining",
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            productDescription,
            style: const TextStyle(),
          ),
        ),
      ],
    );
  }
}
