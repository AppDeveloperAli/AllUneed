import 'package:fiv/provider/cart_provider.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:fiv/widgets/single_cart_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../checkout/check_out_page.dart';
import '../../route/routing_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int? selectedPayment;
  Widget CustomPaymentCardButton(String title, int index) {
    List<String> timeParts = title.split(' : ');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay storedTime = TimeOfDay(hour: hour, minute: minute);

    TimeOfDay currentTime = TimeOfDay.now();

    // Adjusting the logic to handle time crossing 10:30 PM
    bool isAM = storedTime.hour < 12;
    bool isPM = storedTime.hour >= 12;
    bool isBefore1030PM = storedTime.hour < 22 ||
        (storedTime.hour == 22 && storedTime.minute <= 30);
    bool isBefore5Hours = currentTime.hour >= storedTime.hour &&
        currentTime.hour - storedTime.hour < 5;

    bool isPastTime = isPM && isBefore1030PM && isBefore5Hours;

    return ElevatedButton(
      onPressed: () {
        if (!isPastTime || (isAM && !isBefore5Hours)) {
          setState(() {
            selectedPayment = index;
          });
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
          width: (selectedPayment == index) ? 2.0 : 0.5,
          color:
              (selectedPayment == index) ? Colors.green : Colors.blue.shade600,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '$title PM',
              style: TextStyle(
                color: isPastTime
                    ? Colors.black26
                    : (selectedPayment == index ? Colors.green : Colors.black),
              ),
            ),
          ),
          if (selectedPayment == index && !isPastTime)
            Positioned(
              top: -2,
              right: 0,
              child: Image.asset(
                "images/check.png",
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    return Scaffold(
      bottomNavigationBar: cartProvider.getCartList.isEmpty
          ? const Text("")
          : MyButton(
              text: "Check Out",
              onPressed: () {
                var snackBar = '';
                switch (selectedPayment) {
                  case 0:
                    snackBar = '5:30';
                    break;
                  case 1:
                    snackBar = '6:30';
                    break;
                  case 2:
                    snackBar = '7:30';
                    break;
                  case 3:
                    snackBar = '8:30';
                    break;
                  case 4:
                    snackBar = '9:30';
                    break;
                  case 5:
                    snackBar = '10:30';
                    break;
                }

                if (selectedPayment != null) {
                  final snackBarMsg = SnackBar(
                    content: Text('You select Time Slot : "$snackBar"'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBarMsg);
                  RoutingPage.goTonext(
                    context: context,
                    navigateTo: CheckOutPage(
                      time: snackBar,
                    ),
                  );
                } else {
                  const snackBarMsg = SnackBar(
                    content:
                        Text('Please select a Time Or Wait Until Tomorrow...'),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBarMsg);
                }
              },
            ),
      appBar: AppBar(
        title: const Center(child: Text('Products in Cart')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: cartProvider.getCartList.isEmpty
          ? const Center(
              child: Text("No Product"),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: cartProvider.getCartList.length,
                    itemBuilder: (ctx, index) {
                      var data = cartProvider.cartList[index];
                      return SingleCartItem(
                        productId: data.productId,
                        productCategory: data.productCategory,
                        productImage: data.productImage,
                        productPrice: data.productPrice.toDouble(),
                        productQuantity: data.productQuantity.toInt(),
                        productName: data.productName,
                      );
                    },
                  ),
                  cartProvider.getCartList.isEmpty
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.white,
                          width: double.infinity,
                          child: Card(
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      'Available Time Slot\'s',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CustomPaymentCardButton('5 : 30', 0),
                                  ),
                                  CustomPaymentCardButton('6 : 30', 1),
                                  CustomPaymentCardButton('7 : 30', 2),
                                  CustomPaymentCardButton('8 : 30', 3),
                                  CustomPaymentCardButton('9 : 30', 4),
                                  CustomPaymentCardButton('10 : 30', 5),
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
