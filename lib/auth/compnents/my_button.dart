import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  
  final Function()? onTapBtn;
  final String message;
  const MyButton({super.key, required this.onTapBtn, required this.message});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBtn,
      child: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}