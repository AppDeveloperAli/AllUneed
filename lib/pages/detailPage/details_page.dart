import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiv/pages/cartPage/cart_part.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:fiv/widgets/my_button.dart';
import 'package:fiv/widgets/single_product.dart';
import 'package:fiv/widgets/snackBar.dart';
import 'package:flutter/material.dart';

import '../welcome/components/top_part.dart';
import 'components/second_part.dart';

class DetailsPage extends StatefulWidget {
  final String productImage;
  final String productName;
  final String productCategory;
  final num productPrice;
  final String productId;
  // final double productOldPrice;
  final num productRate;
  // final String productDescription;

  const DetailsPage({
    Key? key,
    required this.productCategory,
    required this.productId,
    // required this.productDescription,
    required this.productName,
    required this.productImage,
    required this.productPrice,
    // required this.productOldPrice,
    required this.productRate,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TopPart(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                    width: 250,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Image.network(
                        widget.productImage,
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      margin: const EdgeInsets.all(10),
                    ),
                  ),
                ],
              ),
              SecondPart(
                productCategory: widget.productCategory,
                productImage: widget.productImage,
                productId: widget.productId,
                // productDescription: productDescription,
                productName: widget.productName,
                // productOldPrice: productOldPrice,
                productPrice: widget.productPrice.toDouble(),
                productRate: widget.productRate.toInt(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 20),
                child: MyButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("cart")
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection("userCart")
                        .doc(widget.productId)
                        .set(
                      {
                        "productId": widget.productId,
                        "productImage": widget.productImage,
                        "productName": widget.productName,
                        "productPrice": widget.productPrice,
                        "productOldPrice": widget.productPrice,
                        "productRate": widget.productRate,
                        // "productDescription": productDescription,
                        "productQuantity": 1,
                        "productCategory": widget.productCategory,
                      },
                    );
                    CustomSnackBar(
                        context, const Text('Item added to Cart...'));
                    // RoutingPage.goTonext(
                    //   context: context,
                    //   navigateTo: const CartPage(),
                    // );
                  },
                  text: "Add to Cart",
                ),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: buildProduct(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .where("productRate", isGreaterThan: 4)
                      .orderBy(
                        "productRate",
                        descending: true,
                      )
                      .snapshots(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
