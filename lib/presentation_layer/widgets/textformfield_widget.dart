import 'package:flutter/material.dart';

Widget buildTextFormField(
    {bool autoFocus = false,
    TextEditingController? textEditingController,
    required TextInputType textInputType,
    bool obscureText = false,
    Function(String?)? onSaved,
    required String? Function(String?) validator,
    required Widget label,
    required IconData prefixIcon,
    String? hintText,
    Function(String?)? onChanged,
    IconData? suffixIcon,
    VoidCallback? suffixPressed}) {
  return TextFormField(
    autofocus: autoFocus,
    controller: textEditingController,
    keyboardType: textInputType,
    obscureText: obscureText,
    onSaved: onSaved,
    validator: validator,
    decoration: InputDecoration(
      hintText: hintText,
      border: const OutlineInputBorder(),
      label: label,
      suffixIcon: IconButton(icon: Icon(suffixIcon), onPressed: suffixPressed),
      prefixIcon: Icon(prefixIcon),
    ),
    onChanged: onChanged,
  );
}
