import 'package:flutter/material.dart';

Future<void> showCustomModalBottomSheet({required BuildContext context, required Widget body}) {
  return showModalBottomSheet(
      backgroundColor: Colors.blue.shade800,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(160, 40))),
      context: context,
      builder: (context) => body);
}
