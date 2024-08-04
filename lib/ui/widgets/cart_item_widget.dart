import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartItemWidget extends StatefulWidget {
  final String cardNumber;
  final String amount;
  final String cardType;
  final String expiryDate;

  const CartItemWidget({
    super.key,
    required this.expiryDate,
    required this.cardType,
    required this.cardNumber,
    required this.amount,
  });

  @override
  CartItemWidgetState createState() => CartItemWidgetState();
}

class CartItemWidgetState extends State<CartItemWidget> {
  bool _isAmountVisible = true;

  void _toggleAmountVisibility() {
    setState(() {
      _isAmountVisible = !_isAmountVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildCard(widget.cardNumber, widget.amount);
  }

  Widget buildCard(String cardNumber, String amount) {
    const textStyleWhite = TextStyle(color: Colors.white);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.cardType,
                  style: textStyleWhite.copyWith(fontSize: 20.sp),
                ),
                Text(
                  widget.cardNumber,
                  style: textStyleWhite.copyWith(fontSize: 18.sp),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.expiryDate,
                  style: textStyleWhite.copyWith(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _isAmountVisible ? amount : '****',
                        style: textStyleWhite.copyWith(
                            fontSize: 24.sp, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _toggleAmountVisibility();
                      },
                      icon: Icon(_isAmountVisible
                          ? Icons.remove_red_eye
                          : Icons.remove_red_eye_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
