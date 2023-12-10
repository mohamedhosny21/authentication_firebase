import 'package:flutter/material.dart';

Widget buildSignInButtonProvider(
    {required Color color,
    required Color textStyleColor,
    required IconData icon,
    required String text,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 300,
      height: 40,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            text,
            style: TextStyle(
                color: textStyleColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0),
          ),
        ],
      ),
    ),
  );
}
