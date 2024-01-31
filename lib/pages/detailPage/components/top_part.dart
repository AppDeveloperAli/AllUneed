import 'package:flutter/material.dart';

class TopPart extends StatelessWidget {
  final String productImage;

  const TopPart({
    Key? key,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FImage&psig=AOvVaw3LIjH2-WbQuWclkbsZIGrU&ust=1692619323456000&source=images&cd=vfe&opi=89978449&ved=0CBAQjRxqFwoTCOCz-r2Y64ADFQAAAAAdAAAAABAE")),
        ),
      ),
    );
  }
}
