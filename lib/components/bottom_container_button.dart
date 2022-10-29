import 'package:flutter/material.dart';
import '../constants.dart';

class BottomContainer extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const BottomContainer({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: kbottomContainerColor,
          margin: const EdgeInsets.only(top: 10.0, bottom: 5.0),
          height: kbottomContainerHeight,
          child: Center(
            child: Text(text, style: klargeBottomButtonTextStyle),
          ),
        ),
      ),
    );
  }
}