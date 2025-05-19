import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showToast(BuildContext context, String message) {
  Flushbar(
    message: message,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.teal,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}