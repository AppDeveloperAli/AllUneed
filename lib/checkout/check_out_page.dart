import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiv/pages/detailPage/details_page.dart';
import 'package:fiv/provider/cart_provider.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:fiv/widgets/single_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../appColors/app_colors.dart';
import '../widgets/single_cart_item.dart';

class CheckOutPage extends StatefulWidget {
  String? time;
  CheckOutPage({Key? key, required this.time}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late Razorpay _razorpay;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
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
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Susccess");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("EXTERNAL_WALLET ");
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    cartProvider.getCartData();

    double subTotal = cartProvider.subTotal();

    double discount = 5;
    int shipping = 10;

    double discountValue = (subTotal * discount) / 100;

    double value = subTotal - discountValue;

    totalPrice = value += shipping;

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
                        productPrice: data.productPrice,
                        productQuantity: data.productQuantity,
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
                  const ListTile(
                    leading: Text("Discount"),
                    trailing: Text("5 %"),
                  ),
                  const ListTile(
                    leading: Text("Shiping"),
                    trailing: Text("₹ 10"),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    leading: const Text("Total"),
                    trailing: Text("₹ ${totalPrice.toStringAsFixed(2)}"),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const ListTile(
                    leading: Text(
                      "Best Sell",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  buildProduct(
                    stream: FirebaseFirestore.instance
                        .collection("products")
                        .where("productRate", isGreaterThan: 4)
                        .orderBy(
                          "productRate",
                          descending: true,
                        )
                        .snapshots(),
                  ),
                  cartProvider.getCartList.isEmpty
                      ? const Text("")
                      : MyButton(
                          onPressed: () => openCheckout(),
                          text: "Buy",
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
