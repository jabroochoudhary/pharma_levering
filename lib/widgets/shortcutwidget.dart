import 'package:flutter/material.dart';

import '../appColors/app_colors.dart';

class ShortCutWidget extends StatefulWidget {
  final String productImage;
  final String productName;
  final VoidCallback onPressed;
  ShortCutWidget({
    required this.productImage,
    required this.productName,
    required this.onPressed,
  });

  @override
  _ShortCutWidget createState() => _ShortCutWidget();
}

class _ShortCutWidget extends State<ShortCutWidget> {
  bool isFave = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        height: 80,
        width: 80,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                height: double.infinity,
                margin: EdgeInsets.all(11.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      widget.productImage,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 1,
                  ),
                  Text(
                    widget.productName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
