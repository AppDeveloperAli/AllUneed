import 'dart:ui';

import 'package:fiv/model/user_model.dart';
import 'package:fiv/widgets/single_product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => GridViewWidget(
                            subCollection: streamSnapshort.data!.docs[index]
                                ["categoryName"],
                            collection: "categories",
                            id: streamSnapshort.data!.docs[index].id,
                          ),
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
      height: size!.height / 4 + 0,
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
                      productOldPrice: data["productOldPrice"],
                      productPrice: data["productPrice"],
                      productRate: data["productRate"],
                      productDescription: data["productDescription"],
                    ),
                  );
                },
                productId: data["productId"],
                productCategory: data["productCategory"],
                productRate: data["productRate"],
                productOldPrice: data["productOldPrice"],
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

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    getCurrentUserDataFunction();
    return Scaffold(
      drawer: const BuildDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 7,
              shadowColor: Colors.grey[300],
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    query = value;
                  });
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  fillColor: AppColors.KwhiteColor,
                  hintText: "Search Your Product",
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
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
                    const ListTile(
                      leading: Text(
                        "Products",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    buildProduct(
                      stream: FirebaseFirestore.instance
                          .collection("products")
                          .snapshots(),
                    ),
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
                                      productOldPrice: data["productOldPrice"],
                                      productPrice: data["productPrice"],
                                      productRate: data["productRate"],
                                      productDescription:
                                          data["productDescription"],
                                    ),
                                  );
                                },
                                productId: data["productId"],
                                productCategory: data["productCategory"],
                                productRate: data["productRate"],
                                productOldPrice: data["productOldPrice"],
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
            Image.network(
              image,
              fit: BoxFit.cover,
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
