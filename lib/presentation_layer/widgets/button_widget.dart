import 'package:flutter/material.dart';

class BuildButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget text;
  final double? width;
  final double? height;
  final Color color;
  const BuildButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.width,
      this.height,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(width ?? 200, height ?? 50)),
      child: text,
    );
  }
}
