import 'package:flutter/material.dart';

void showInvalidMsg(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Center(
          child: Text(
            msg,
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 84, 53, 90),
      );
    },
  );
}
