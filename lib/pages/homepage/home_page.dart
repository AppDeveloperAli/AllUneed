import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fiv/model/user_model.dart';
import 'package:fiv/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../appColors/app_colors.dart';
import '../../route/routing_page.dart';
import '../../widgets/build_drawer.dart';
import '../../widgets/grid_view_widget.dart';
import '../detailPage/details_page.dart';

late UserModel userModel;

Size? size;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future getCurrentUserDataFunction() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then(
      (DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          userModel = UserModel.fromDocument(documentSnapshot);
        } else {
          if (kDebugMode) {
            print("Document does not exist the database");
          }
        }
      },
    );
  }

  Widget buildCategory() {
    return Column(
      children: [
        const ListTile(
          leading: Text(
            "Categories",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(
          height: size!.height * 0.1 + 20,
          child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("categories").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
              if (!streamSnapshort.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: streamSnapshort.data!.docs.length,
                itemBuilder: (ctx, index) {
                  return Categories(
                    onTap: () {
                      RoutingPage.goTonext(
                        context: context,
                        navigateTo: GridViewWidget(
                          title: streamSnapshort.data!.docs[index]
                              ["categoryName"],
                          subCollection: streamSnapshort.data!.docs[index]
                              ["categoryName"],
                          collection: "categories",
                          id: streamSnapshort.data!.docs[index].id,
                        ),
                      );
                    },
                    categoryName: streamSnapshort.data!.docs[index]
                        ["categoryName"],
                    image: streamSnapshort.data!.docs[index]["categoryImage"],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
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
            // scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
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

  final List<String> imageUrls = [
    'https://example.com/image1.jpg',
    'https://example.com/image2.jpg',
    'https://example.com/image3.jpg',
    'https://example.com/image4.jpg',
    'https://example.com/image5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getCurrentUserDataFunction();
    return Scaffold(
      drawer: const BuildDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('AUN'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 10,
            ),
            child: Material(
              elevation: 0,
              shadowColor: Colors.grey[300],
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  fillColor: AppColors.KwhiteColor,
                  hintText: "Search Your Product",
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
          query == ""
              ? Column(
                  children: [
                    buildCategory(),
                    const ListTile(
                      leading: Text(
                        "Available Offer's",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 210,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('special')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          final documents = snapshot.data!.docs;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final slideImages = documents[index]
                                  ['slideImages'] as List<dynamic>;
                              return CarouselSlider(
                                options: CarouselOptions(height: 200.0),
                                items: slideImages.map((imageUrl) {
                                  return Card(
                                    semanticContainer: true,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 5,
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    const ListTile(
                      leading: Text(
                        "Best Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('bestProducts')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Loading indicator while data is being fetched
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                              child: Text('No data available'),
                            ); // If no data available
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final product = snapshot.data!.docs[index];
                              final productData =
                                  product.data() as Map<String, dynamic>;
                              final List<dynamic> productImages =
                                  productData['productImage'];
                              return SingleProduct(
                                onTap: () {},
                                productId: productData['productId'],
                                productCategory: productData['prdouctCategory'],
                                productRate: productData['productPrice'],
                                productPrice: productData['productRate'],
                                productImage: productImages[0],
                                productName: productData['productName'],
                              );
                            },
                          );
                        })
                    // const ListTile(
                    //   leading: Text(
                    //     "Best Sell",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.normal,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 200,
                    //   child: StreamBuilder(
                    //     stream: FirebaseFirestore.instance
                    //         .collection("products")
                    //         .snapshots(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       return ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: snapshot.data!.size,
                    //         shrinkWrap: true,
                    //         itemBuilder: (context, index) {
                    //           var data = snapshot.data!.docs;
                    //           return Column(
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   RoutingPage.goTonext(
                    //                     context: context,
                    //                     navigateTo: DetailsPage(
                    //                       productCategory: data[index]
                    //                           ["productCategory"],
                    //                       productId: data[index]["productId"],
                    //                       productImage: data[index]
                    //                           ["productImage"],
                    //                       productName: data[index]
                    //                           ["productName"],
                    //                       // productOldPrice: data["productOldPrice"],
                    //                       productPrice: data[index]
                    //                           ["productPrice"],
                    //                       productRate: data[index]
                    //                           ["productRate"],
                    //                       // productDescription:
                    //                       //     data["productDescription"],
                    //                     ),
                    //                   );
                    //                 },
                    //                 child: SizedBox(
                    //                   width: 200,
                    //                   height: 180,
                    //                   child: Card(
                    //                     semanticContainer: true,
                    //                     clipBehavior:
                    //                         Clip.antiAliasWithSaveLayer,
                    //                     child: Image.network(
                    //                       data[index]['productImage'],
                    //                       fit: BoxFit.fill,
                    //                     ),
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10.0),
                    //                     ),
                    //                     elevation: 5,
                    //                     margin: const EdgeInsets.all(10),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Text(
                    //                     data[index]['productName'],
                    //                   ),
                    //                   const SizedBox(
                    //                     width: 20,
                    //                   ),
                    //                   Text(
                    //                     data[index]['productPrice'].toString(),
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),

                    // const ListTile(
                    //   leading: Text(
                    //     "Products",
                    //     style: TextStyle(
                    //       fontSize: 20,
                    //       fontWeight: FontWeight.normal,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 200,
                    //   child: StreamBuilder(
                    //     stream: FirebaseFirestore.instance
                    //         .collection("products")
                    //         .snapshots(),
                    //     builder: (BuildContext context,
                    //         AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                    //             snapshot) {
                    //       return ListView.builder(
                    //         scrollDirection: Axis.horizontal,
                    //         itemCount: snapshot.data!.size,
                    //         shrinkWrap: true,
                    //         itemBuilder: (context, index) {
                    //           var data = snapshot.data!.docs;
                    //           return Column(
                    //             children: [
                    //               InkWell(
                    //                 onTap: () {
                    //                   RoutingPage.goTonext(
                    //                     context: context,
                    //                     navigateTo: DetailsPage(
                    //                       productCategory: data[index]
                    //                           ["productCategory"],
                    //                       productId: data[index]["productId"],
                    //                       productImage: data[index]
                    //                           ["productImage"],
                    //                       productName: data[index]
                    //                           ["productName"],
                    //                       // productOldPrice: data["productOldPrice"],
                    //                       productPrice: data[index]
                    //                           ["productPrice"],
                    //                       productRate: data[index]
                    //                           ["productRate"],
                    //                       // productDescription:
                    //                       //     data["productDescription"],
                    //                     ),
                    //                   );
                    //                 },
                    //                 child: SizedBox(
                    //                   width: 200,
                    //                   height: 180,
                    //                   child: Card(
                    //                     semanticContainer: true,
                    //                     clipBehavior:
                    //                         Clip.antiAliasWithSaveLayer,
                    //                     child: Image.network(
                    //                       data[index]['productImage'],
                    //                       fit: BoxFit.fill,
                    //                     ),
                    //                     shape: RoundedRectangleBorder(
                    //                       borderRadius:
                    //                           BorderRadius.circular(10.0),
                    //                     ),
                    //                     elevation: 5,
                    //                     margin: const EdgeInsets.all(10),
                    //                   ),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   Text(
                    //                     data[index]['productName'],
                    //                   ),
                    //                   const SizedBox(
                    //                     width: 20,
                    //                   ),
                    //                   Text(
                    //                     data[index]['productPrice'].toString(),
                    //                     style: const TextStyle(
                    //                         fontWeight: FontWeight.bold),
                    //                   ),
                    //                 ],
                    //               )
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     },
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(bottom: 20),
                    //   child: buildProduct(
                    //     stream: FirebaseFirestore.instance
                    //         .collection("products")
                    //         .snapshots(),
                    //   ),
                    // ),
                  ],
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("products")
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshort) {
                    if (!streamSnapshort.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var varData =
                        searchFunction(query, streamSnapshort.data!.docs);
                    return result.isEmpty
                        ? const Center(child: Text("Not Found"))
                        : GridView.builder(
                            shrinkWrap: true,
                            itemCount: result.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              childAspectRatio: 0.6,
                            ),
                            itemBuilder: (ctx, index) {
                              var data = varData[index];
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
                                      // productDescription:
                                      //     data["productDescription"],
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
        ],
      ),
    );
  }
}

class Categories extends StatelessWidget {
  final String image;
  final String categoryName;
  final Function()? onTap;
  const Categories({
    Key? key,
    required this.onTap,
    required this.categoryName,
    required this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        width: size!.width / 2 - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Background Image
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                //  Image.network(
                //   image,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),

            // Blurred Overlay
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Text Overlay
            Center(
              child: Text(
                categoryName,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
