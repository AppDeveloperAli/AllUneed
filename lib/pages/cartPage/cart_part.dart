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
  int selectedPayment = 0;
  Widget CustomPaymentCardButton(String title, int index) {
    // Parse the time string to get hour and minute values
    List<String> timeParts = title.split(' : ');
    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Create a TimeOfDay object for the specified time
    TimeOfDay storedTime = TimeOfDay(hour: hour, minute: minute);

    // Get the current time
    TimeOfDay currentTime = TimeOfDay.now();

    // Convert TimeOfDay to DateTime for easier comparison
    DateTime currentDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        currentTime.hour,
        currentTime.minute);

    // Convert storedTime to DateTime for easier comparison
    DateTime storedDateTime = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        storedTime.hour,
        storedTime.minute);

    // Calculate the difference in hours
    int differenceInHours = storedDateTime.difference(currentDateTime).inHours;

    // Check if the difference is 5 hours or more in the future
    bool isAtLeastFiveHoursLater = differenceInHours <= 5;

    return OutlinedButton(
      onPressed: () {
        if (isAtLeastFiveHoursLater) {
          setState(() {
            selectedPayment = index;
          });
        }
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
            width: (selectedPayment == index) ? 2.0 : 0.5,
            color: (selectedPayment == index)
                ? Colors.green
                : Colors.blue.shade600),
      ),
      child: Stack(
        children: [
          Center(
            child: isAtLeastFiveHoursLater
                ? Text(
                    title,
                    style: TextStyle(
                        color: (selectedPayment == index)
                            ? Colors.green
                            : Colors.black),
                  )
                : Text(
                    title,
                    style: TextStyle(
                        color: (selectedPayment == index)
                            ? Colors.green
                            : Colors.black26),
                  ),
          ),
          if (selectedPayment == index && isAtLeastFiveHoursLater)
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
                RoutingPage.goTonext(
                  context: context,
                  navigateTo: const CheckOutPage(),
                );
              },
            ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body:
          // cartProvider.getCartList.isEmpty
          //     ? const Center(
          //         child: Text("No Product"),
          //       )
          //     :
          SingleChildScrollView(
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
                  productPrice: data.productPrice,
                  productQuantity: data.productQuantity,
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
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: const BorderSide(
                                                        color: Colors.blue)))),
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
                                          final snackBarMsg = SnackBar(
                                            content: Text(
                                                'You select Time Slot : "$snackBar"'),
                                          );

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBarMsg);
                                        },
                                        child: Text("SUBMIT".toUpperCase(),
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue))),
                                  ),
                                ],
                              ),
                            )
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
