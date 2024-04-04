import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String productId;
  final String productCategory;
  final String productImage;
  final num productPrice;
  final num productRate;
  final num productQuantity;
  final String productName;
  CartModel({
    required this.productCategory,
    required this.productId,
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productRate,
    required this.productQuantity,
  });
  factory CartModel.fromDocument(QueryDocumentSnapshot doc) {
    return CartModel(
      productId: doc["productId"],
      productCategory: doc["productCategory"],
      productImage: doc["productImage"],
      productPrice: doc["productPrice"],
      productRate: doc["productRate"],
      productQuantity: doc["productQuantity"],
      productName: doc["productName"],
    );
  }
}
