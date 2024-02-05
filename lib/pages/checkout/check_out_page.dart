// import 'package:fiv/appColors/app_colors.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// import '../../provider/cart_provider.dart';
// import '../../widgets/my_button.dart';
// import '../../widgets/single_cart_item.dart';

// class CheckOutPage extends StatefulWidget {
//   const CheckOutPage({Key? key}) : super(key: key);

//   @override
//   State<CheckOutPage> createState() => _CheckOutPageState();
// }

// class _CheckOutPageState extends State<CheckOutPage> {
//   late Razorpay _razorpay;
//   late double totalPrice;

//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }

//   void openCheckout() async {
//     var options = {
//       'key': 'rzp_test_grPNFxkdVPznZr',
//       'amount': num.parse(totalPrice.toString()) * 100,
//       'name': 'Vedant',
//       'description': 'Payment for some random product',
//       'prefill': {
//         'contact': '8888888888',
//         'email': 'Vedant12',
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };

//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print("Payment Susccess");
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     print("Payment error");
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print("EXTERNAL_WALLET ");
//   }

//   @override
//   Widget build(BuildContext context) {
//     CartProvider cartProvider = Provider.of<CartProvider>(context);
//     cartProvider.getCartData();

//     double subTotal = cartProvider.subTotal();

//     double discount = 5;
//     int shipping = 10;

//     double discountValue = (subTotal * discount) / 100;

//     double value = subTotal - discountValue;

//     totalPrice = value += shipping;

//     if (cartProvider.getCartList.isEmpty) {
//       setState(() {
//         totalPrice = 0.0;
//       });
//     }

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         centerTitle: true,
//         title: const Text(
//           "Check out",
//           style: TextStyle(
//             color: AppColors.KblackColor,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: cartProvider.getCartList.isEmpty
//                 ? const Center(
//                     child: Text("No Product"),
//                   )
//                 : ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: cartProvider.getCartList.length,
//                     itemBuilder: (ctx, index) {
//                       var data = cartProvider.cartList[index];
//                       return SingleCartItem(
//                         productId: data.productId,
//                         productCategory: data.productCategory,
//                         productImage: data.productImage,
//                         productPrice: data.productPrice,
//                         productQuantity: data.productQuantity,
//                         productName: data.productName,
//                       );
//                     },
//                   ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: const Text("Sub Total"),
//                   trailing: Text("\$ $subTotal"),
//                 ),
//                 const ListTile(
//                   leading: Text("Discount"),
//                   trailing: Text("%5"),
//                 ),
//                 const ListTile(
//                   leading: Text("Shiping"),
//                   trailing: Text("\$10"),
//                 ),
//                 const Divider(
//                   thickness: 2,
//                 ),
//                 ListTile(
//                   leading: const Text("Total"),
//                   trailing: Text("\$ $totalPrice"),
//                 ),
//                 cartProvider.getCartList.isEmpty
//                     ? const Text("")
//                     : MyButton(
//                         onPressed: () => openCheckout(),
//                         text: "asdsa",
//                       ),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
