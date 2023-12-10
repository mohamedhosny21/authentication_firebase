import 'package:flutter/material.dart';

void showCircularProgressIndicator(BuildContext context) {
  AlertDialog alertDialog = const AlertDialog(
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: Center(
      child: CircularProgressIndicator(
        color: Colors.black,
      ),
    ),
  );
  showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0),
      context: context,
      builder: (context) => alertDialog);
}
