import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SingleCartItem extends StatefulWidget {
  final String productImage;
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productCategory;
  final String productId;

  const SingleCartItem({
    Key? key,
    required this.productId,
    required this.productCategory,
    required this.productImage,
    required this.productPrice,
    required this.productQuantity,
    required this.productName,
  }) : super(key: key);

  @override
  _SingleCartItemState createState() => _SingleCartItemState();
}

class _SingleCartItemState extends State<SingleCartItem> {
  int quantity = 0; // Initialize quantity with 0 initially

  @override
  void initState() {
    super.initState();
    // Fetch the quantity value from Firestore and update the state variable
    fetchQuantity();
  }

  // Function to fetch the quantity value from Firestore
  void fetchQuantity() async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection("cart")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("userCart")
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        setState(() {
          quantity = doc.data()?['productQuantity'] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching quantity: $e");
    }
  }

  // Function to update the quantity in Firestore
  void updateQuantity(int newQuantity) {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(widget.productId)
        .update({
      "productQuantity": newQuantity,
    }).then((_) {
      setState(() {
        quantity = newQuantity;
      });
    }).catchError((error) {
      print("Error updating quantity: $error");
    });
  }

  // Function to increment the quantity
  void incrementQuantity() {
    updateQuantity(quantity + 1);
  }

  // Function to decrement the quantity
  void decrementQuantity() {
    if (quantity > 0) {
      updateQuantity(quantity - 1);
    }
  }

  void deleteProductFuntion() {
    FirebaseFirestore.instance
        .collection("cart")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("userCart")
        .doc(widget.productId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      height: 190,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
          )
        ],
      ),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: NetworkImage(widget.productImage),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        widget.productName,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.productCategory,
                      ),
                      Text(
                        "₹ ${widget.productPrice.toInt() * widget.productQuantity.toInt()}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IncrementAndDecrement(
                            icon: Icons.remove,
                            onPressed: decrementQuantity,
                          ),
                          Text(
                            widget.productQuantity.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          IncrementAndDecrement(
                            icon: Icons.add,
                            onPressed: incrementQuantity,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          IconButton(
            onPressed: () {
              deleteProductFuntion();
            },
            icon: const Icon(
              Icons.close,
            ),
          )
        ],
      ),
    );
  }
}

class IncrementAndDecrement extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  const IncrementAndDecrement({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      height: 30,
      elevation: 2,
      color: Colors.grey[300],
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(icon),
    );
  }
}
