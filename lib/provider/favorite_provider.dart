import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class FavoriteProvider with ChangeNotifier {
  void favorite(
      {required productId,
      required productCategory,
      required productRate,
      // required productOldPrice,
      required productPrice,
      required productImage,
      required productFavorite,
      required productName,
      required images,
      required productDescription}) {
    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userFavorite")
        .doc(productId)
        .set(
      {
        "productId": productId,
        "productCategory": productCategory,
        "categoryName": productCategory,
        "productRate": productRate,
        // "productOldPrice": productOldPrice,
        "productPrice": productPrice,
        "productImage": productImage,
        "productFavorite": productFavorite,
        "productName": productName,
        "images": images,
        "productDescription": productDescription
      },
    );
  }

  deleteFavorite({required String productId}) {
    FirebaseFirestore.instance
        .collection("favorite")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userFavorite")
        .doc(productId)
        .delete();
    notifyListeners();
  }
}
