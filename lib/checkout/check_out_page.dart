import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiv/checkout/orderPlaced.dart';
import 'package:fiv/model/cart_model.dart';
import 'package:fiv/pages/detailPage/details_page.dart';
import 'package:fiv/provider/cart_provider.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:fiv/widgets/single_product.dart';
import 'package:fiv/widgets/snackBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../appColors/app_colors.dart';
import '../widgets/single_cart_item.dart';

class CheckOutPage extends StatefulWidget {
  String? time;
  CheckOutPage({Key? key, required this.time}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  // late Razorpay _razorpay;
  late double totalPrice;

  // @override
  // void initState() {
  //   super.initState();
  //   // _razorpay = Razorpay();
  //   // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
  //   // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  //   // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  // }

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': num.parse(totalPrice.toString()) * 100,
      'name': 'Yaqoob Bugti',
      'description': 'Payment for some randonm product',
      'prefill': {
        'contact': '8888888888',
        'email': 'yaqoobkafeel580@gmail.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      // _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) {
  //   print("Payment Susccess");
  // }

  // void _handlePaymentError(PaymentFailureResponse response) {
  //   print("Payment error");
  // }

  // void _handleExternalWallet(ExternalWalletResponse response) {
  //   print("EXTERNAL_WALLET ");
  // }

  bool isLoading = false;

  Future<String?> getFullName() async {
    String? fullName;
    String? currentUserId = FirebaseAuth.instance.currentUser!.uid;

    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();

      if (snapshot.exists) {
        fullName = snapshot['fullName'];
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }

    return fullName;
  }

  Map<String, dynamic>? specialData; // Variable to store special data

  Future<Map<String, dynamic>?> fetchSpecialData() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('special')
          .doc('UYmil6gQ34PgL51cLxcS')
          .get();

      if (snapshot.exists) {
        return snapshot.data();
      } else {
        print('Document does not exist');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    totalPrice = 0.0; // Initialize totalPrice
    fetchSpecialData().then((data) {
      setState(() {
        specialData = data;
        if (specialData != null) {
          totalPrice =
              price(); // Calculate totalPrice only if special data is available
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    double subTotal = cartProvider.subTotal();

    // double discount = 5;
    // int shipping = 10;

    // double discountValue = (subTotal * discount) / 100;

    // double value = subTotal - discountValue;

    // totalPrice = value += shipping;

    if (cartProvider.getCartList.isEmpty) {
      setState(() {
        totalPrice = 0.0;
      });
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text(
          "Check out",
          style: TextStyle(
            color: AppColors.KblackColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            cartProvider.getCartList.isEmpty
                ? const Center(
                    child: Text("No Product"),
                  )
                : ListView.builder(
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
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  ListTile(
                    leading: const Text("Picked Time"),
                    trailing: Text('${widget.time.toString()} PM'),
                  ),
                  ListTile(
                    leading: const Text("Sub Total"),
                    trailing: Text("₹ ${subTotal.toStringAsFixed(2)}"),
                  ),
                  ListTile(
                    leading: const Text("Discount"),
                    trailing: specialData != null &&
                            specialData!.containsKey('discount')
                        ? Text('${specialData!['discount'].toString()} %')
                        : const Text('Loading...'),
                  ),
                  ListTile(
                    leading: const Text("Shipping"),
                    trailing: specialData != null &&
                            specialData!.containsKey('shiping')
                        ? Text('₹ ${specialData!['shiping'].toString()}')
                        : const Text('Loading...'),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Text("Total"),
                    trailing: Text(price().toString()),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  cartProvider.getCartList.isEmpty
                      ? const Text("")
                      : isLoading
                          ? const CircularProgressIndicator()
                          : MyButton(
                              // onPressed: () => openCheckout(),
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                String orderID =
                                    generateRandomNumber().toString();
                                String deliveryPasscode =
                                    generateRandomNumber().toString();
                                CollectionReference ordersCollection =
                                    FirebaseFirestore.instance
                                        .collection('orders');
                                CollectionReference otpCollection =
                                    FirebaseFirestore.instance
                                        .collection('otp');

                                List<String> getProductNames(
                                    List<CartModel> cartList) {
                                  return cartList
                                      .map((item) => item.productName)
                                      .toList();
                                }

                                List<CartModel> cartList =
                                    cartProvider.getCartList;
                                List<String> productNames =
                                    getProductNames(cartList);

                                try {
                                  final docSnapshot = await otpCollection
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .get();

                                  String? fullName = await getFullName();

                                  await otpCollection.doc().set({
                                    'UiD':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'orderID': orderID,
                                    'pinCode': deliveryPasscode,
                                    'isDelivered': false,
                                    'productNames': productNames,
                                    'customerName': fullName,
                                  });
                                  // cartProvider.deleteCartCollection();

                                  await ordersCollection.doc().set({
                                    'orderID': orderID,
                                    'deliveryPasscode': deliveryPasscode,
                                    'productNames': productNames,
                                    'ID':
                                        FirebaseAuth.instance.currentUser!.uid,
                                  });
                                  cartProvider.deleteCartCollection();
                                  CustomSnackBar(context,
                                      const Text('Order Placed Successfully'));
                                  Navigator.of(context).pushAndRemoveUntil(
                                    CupertinoPageRoute(
                                      builder: (context) => OrderPlacedScreen(
                                        deliveryPasscode: deliveryPasscode,
                                        orderID: orderID,
                                      ),
                                    ),
                                    (route) => false,
                                  );
                                } catch (e) {
                                  CustomSnackBar(context,
                                      Text('Error uploading order: $e'));
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                              text: "Buy",
                            ),
                  // const ListTile(
                  //   leading: Text(
                  //     "Best Sell",
                  //     style: TextStyle(
                  //       fontSize: 20,
                  //       fontWeight: FontWeight.normal,
                  //     ),
                  //   ),
                  // ),
                  // buildProduct(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("products")
                  //       .where("productRate", isGreaterThan: 4)
                  //       .orderBy(
                  //         "productRate",
                  //         descending: true,
                  //       )
                  //       .snapshots(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  double price() {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    double subTotal = cartProvider.subTotal();

    // Check if specialData is not null before accessing its properties
    if (specialData != null) {
      num discount = double.tryParse(specialData!['discount'] ?? '0') ?? 0;
      num shipping = double.tryParse(specialData!['shipping'] ?? '0') ?? 0;

      double discountValue = (subTotal * discount) / 100;

      double value = subTotal - discountValue;

      return value + shipping;
    } else {
      return 0.0; // Return a default value if specialData is null
    }
  }

  int generateRandomNumber() {
    Random random = Random();
    int min = 1000; // minimum 6-digit number
    int max = 9999; // maximum 6-digit number
    return min + random.nextInt(max - min);
  }

  String query = "";
  var result;
  searchFunction(query, searchList) {
    result = searchList.where((element) {
      return element["productName"].toUpperCase().contains(query) ||
          element["productName"].toLowerCase().contains(query) ||
          element["productName"].toUpperCase().contains(query) &&
              element["productName"].toLowerCase().contains(query);
    }).toList();
    return result;
  }

  Widget buildProduct(
      {required Stream<QuerySnapshot<Map<String, dynamic>>>? stream}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 4 + 0,
      child: StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
          if (!streamSnapshort.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: streamSnapshort.data!.docs.length,
            itemBuilder: (ctx, index) {
              var varData = searchFunction(query, streamSnapshort.data!.docs);
              var data = varData[index];
              // var data = streamSnapshort.data!.docs[index];
              return SingleProduct(
                onTap: () {
                  RoutingPage.goTonext(
                    context: context,
                    navigateTo: DetailsPage(
                      productDescription: data['productDescription'],

                      imageList: data["images"],
                      productCategory: data["productCategory"],
                      productId: data["productId"],
                      productImage: data["productImage"],
                      productName: data["productName"],
                      // productOldPrice: data["productOldPrice"],
                      productPrice: data["productPrice"],
                      productRate: data["productRate"],
                      // productDescription: data["productDescription"],
                    ),
                  );
                },
                images: data["images"],
                productDescription: data['productDescription'],
                productId: data["productId"],
                productCategory: data["productCategory"],
                productRate: data["productRate"],
                // productOldPrice: data["productOldPrice"],
                productPrice: data["productPrice"],
                productImage: data["productImage"],
                productName: data["productName"],
              );
            },
          );
        },
      ),
    );
  }
}
