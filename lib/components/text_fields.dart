import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool displayText;
  final prefixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.displayText,
    required this.hintText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        controller: controller,
        obscureText: displayText,
        decoration: InputDecoration(
          labelText: hintText,
          border: const OutlineInputBorder(),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
