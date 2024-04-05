import 'package:cached_network_image/cached_network_image.dart';
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
  final String remaining;
  // final double productOldPrice;
  final num productRate;
  List<dynamic> imageList;

  final String productDescription;

  DetailsPage({
    Key? key,
    required this.remaining,
    required this.productCategory,
    required this.productId,
    required this.productDescription,
    required this.productName,
    required this.productImage,
    required this.imageList,
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
                        remaining: widget.remaining,
                        imageList: data["images"],
                        productCategory: data["productCategory"],
                        productId: data["productId"],
                        productImage: data["productImage"],
                        productName: data["productName"],
                        // productOldPrice: data["productOldPrice"],
                        productPrice: data["productPrice"],
                        productRate: data["productRate"],
                        productDescription: data["productDescription"],
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

    final PageController _pageController = PageController(viewportFraction: 1);
    int currentIndex = 1;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const TopPart(),
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 400,
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: widget.imageList.isEmpty
                              ? Image.asset('images/appicon.jpg')
                              : PageView(
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentIndex = index + 1;
                                    });
                                  },
                                  children: widget.imageList
                                      .map(
                                        (imageUrl) => CachedNetworkImage(
                                          key: UniqueKey(),
                                          imageUrl: imageUrl,
                                          fit: BoxFit.contain,
                                          placeholder: (context, url) => Center(
                                              child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Image.asset(
                                              'images/appicon.jpg',
                                              fit: BoxFit.contain,
                                            ),
                                          )),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: widget.imageList.isEmpty
                            ? Container()
                            : Card(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    '$currentIndex / ${widget.imageList.length}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                SecondPart(
                  productCategory: widget.productCategory,
                  productImage: widget.productImage,
                  productId: widget.productId,
                  productDescription: widget.productDescription,
                  productName: widget.productName,
                  // productOldPrice: productOldPrice,
                  productPrice: widget.productPrice.toDouble(),
                  productRate: widget.productRate.toInt(),
                  reamaining: widget.remaining,
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
                          "productDescription": widget.productDescription,
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
                // const ListTile(
                //   leading: Text(
                //     "Best Sell",
                //     style: TextStyle(
                //       fontSize: 20,
                //       fontWeight: FontWeight.normal,
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 20),
                //   child: buildProduct(
                //     stream: FirebaseFirestore.instance
                //         .collection("products")
                //         .where("productRate", isGreaterThan: 4)
                //         .orderBy(
                //           "productRate",
                //           descending: true,
                //         )
                //         .snapshots(),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
