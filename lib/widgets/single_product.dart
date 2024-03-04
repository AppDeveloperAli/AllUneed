import 'package:cached_network_image/cached_network_image.dart';
import 'package:fiv/provider/favorite_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Size? size;

class SingleProduct extends StatefulWidget {
  final productId;
  final productCategory;
  final productRate;
  // final productOldPrice;
  final productPrice;
  final productImage;
  final productName;
  final images;
  final productDescription;
  final Function()? onTap;
  const SingleProduct({
    Key? key,
    required this.onTap,
    required this.productId,
    required this.productCategory,
    required this.productRate,
    required this.images,
    required this.productDescription,
    // required this.productOldPrice,
    required this.productPrice,
    required this.productImage,
    required this.productName,
  }) : super(key: key);

  @override
  _SingleProductState createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    FavoriteProvider favoriteProvider = Provider.of<FavoriteProvider>(context);

    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection("userFavorite")
        .doc(widget.productId)
        .get()
        .then(
          (value) => {
            if (mounted)
              {
                if (value.exists)
                  {
                    setState(() {
                      isFavorite = value.get("productFavorite");
                    }),
                  }
              }
          },
        );

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(12.0),
            alignment: Alignment.topRight,
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  widget.productImage,
                ),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                setState(
                  () {
                    isFavorite = !isFavorite;

                    if (isFavorite == true) {
                      favoriteProvider.favorite(
                        productDescription: widget.productDescription,
                        images: widget.images,
                        productId: widget.productId,
                        productCategory: widget.productCategory,
                        productRate: widget.productRate,
                        // productOldPrice: widget.productOldPrice,
                        productPrice: widget.productPrice,
                        productImage: widget.productImage,
                        productFavorite: true,
                        productName: widget.productName,
                      );
                    } else if (isFavorite == false) {
                      favoriteProvider.deleteFavorite(
                          productId: widget.productId);
                    }
                  },
                );
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.pink[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      widget.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Rs ${widget.productPrice}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
