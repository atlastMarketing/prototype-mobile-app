import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
CustomFormValidator({
  required String? Function(String?) validator,
  FocusNode? focusNode,
}) =>
    (String? val) {
      String? error = validator(val);
      if (error != null && focusNode != null) focusNode.requestFocus();
      return error;
    };
