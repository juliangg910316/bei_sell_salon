import 'package:bei_sell/shared/custom_text_style.dart';
import 'package:bei_sell/widget/amount_text.dart';
import 'package:flutter/material.dart';

class FrameHome extends StatelessWidget {
  final String title;
  final String body;
  final Color? color;
  final Function onPressed;
  const FrameHome(
      {Key? key,
      required this.title,
      required this.body,
      this.color = Colors.white,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => onPressed(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            color: color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: CustomTextStyle.bodyTextStyle(
                    color: Theme.of(context).primaryColor, size: 14),
              ),
              const SizedBox(
                height: 8,
              ),
              AmountText(
                amount: body,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              /* Text(
                this.body,
                style: CustomTextStyle.titleTextStyle(
                    color: Theme.of(context).primaryColor),
              ), */
            ],
          ),
        ),
      ),
    );
  }
}
