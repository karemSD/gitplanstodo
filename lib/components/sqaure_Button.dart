import 'package:flutter/material.dart';

class SquareButtonIcon extends StatelessWidget {
  SquareButtonIcon({super.key, required this.imagePath, required this.onTap});
  String imagePath;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white,
            )),
        child: Image.asset(
          imagePath,
          height: 40,
        ),
      ),
    );
  }
}
