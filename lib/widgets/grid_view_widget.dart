// ignore_for_file: library_private_types_in_public_api

import 'package:fiv/pages/detailPage/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiv/route/routing_page.dart';
import 'package:flutter/material.dart';

import '../../appColors/app_colors.dart';
import 'single_product.dart';

class GridViewWidget extends StatefulWidget {
  final String id;
  final String collection;
  final String subCollection;
  String? title;

  GridViewWidget(
      {Key? key,
      required this.subCollection,
      required this.id,
      required this.collection,
      this.title})
      : super(key: key);

  @override
  _GridViewWidgetState createState() => _GridViewWidgetState();
}

class _GridViewWidgetState extends State<GridViewWidget> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title.toString()),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(widget.collection)
            .doc(widget.id)
            .collection(widget.subCollection)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshort) {
          if (!snapshort.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var varData = searchFunction(query, snapshort.data!.docs);
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 15, right: 15),
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
                result.isEmpty
                    ? const Text("Not Found")
                    : GridView.builder(
                        shrinkWrap: true,
                        itemCount: result.length,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          // childAspectRatio: 0.6,
                        ),
                        itemBuilder: (ctx, index) {
                          var data = varData[index];
                          return SingleProduct(
                            onTap: () {
                              RoutingPage.goTonext(
                                context: context,
                                navigateTo: DetailsPage(
                                  productDescription:
                                      data['productDescription'],
                                  imageList: data["images"],
                                  productCategory: data["categoryName"],
                                  productId: data["productId"],
                                  productImage: data["images"][0],
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
                            productCategory: data["categoryName"],
                            productRate: data["productRate"],
                            // productOldPrice: data["productOldPrice"],
                            productPrice: data["productPrice"],
                            productImage: data["images"][0],
                            productName: data["productName"],
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
