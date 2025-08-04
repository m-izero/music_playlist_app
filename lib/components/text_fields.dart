import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class my_TextField extends StatelessWidget {
  final controller;
  final hintText;
  final displayText;
  final prefixIcon;

  const my_TextField({
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
          border: OutlineInputBorder(),
          prefixIcon: prefixIcon,
        ),
      ),
    );
  }
}
