import 'package:bei_sell/shared/custom_text_style.dart';
import 'package:flutter/material.dart';

class AmountText extends StatelessWidget {
  const AmountText(
      {Key? key,
      required this.amount,
      this.color = Colors.white,
      this.size = 40})
      : super(key: key);

  final String amount;
  final Color color;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '\$',
          style: CustomTextStyle.titleTextStyle(
              size: (size / 2) + 4, color: color),
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          amount,
          style: CustomTextStyle.titleTextStyle(
              size: size.toDouble(), color: color),
        ),
      ],
    );
  }
}
