import 'package:flutter/material.dart';

class myTextFiled extends StatelessWidget {
  myTextFiled({
    super.key,
    required this.hinText,
    required this.inputType,
    required this.prefixIcon,
    this.isDense,
    required this.obscureText,
    required this.controller,
  });
  final controller;
  String? hinText;
  TextInputType? inputType;
  Icon? prefixIcon;
  bool? isDense = false;
  bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.white),
          ),
          prefixIcon: prefixIcon,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          hintText: hinText,
          fillColor: Colors.grey.shade200,
          filled: true,
          isDense: isDense,
        ),
      ),
    );
  }
}
