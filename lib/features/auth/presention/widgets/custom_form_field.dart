import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final RegExp? validationRegExp;
  const CustomFormField(
      {super.key,
      required this.hintText,
      required this.controller,
      this.validationRegExp});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: (input) {
          if (input == null || input.isEmpty) {
            return "$hintText is required";
          }
          if (validationRegExp != null) {
            if (!validationRegExp!.hasMatch(input)) {
              return "Enter a valid $hintText";
            }
          }
          return null;
        },
        obscureText: hintText.toLowerCase().contains('password'),
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(),
        ));
  }
}
