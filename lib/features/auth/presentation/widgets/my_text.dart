import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final TextEditingController controller;
  final bool  obscure;
  final String hint;

  const MyText({
    super.key, 
    required this.controller,
    required this.obscure, 
    required this.hint
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          filled: true,
          fillColor: Colors.grey[200],
          counterStyle: TextStyle(color: Colors.grey[100]),
          hintText: hint,
        ),
      ),
    );
  }
}
