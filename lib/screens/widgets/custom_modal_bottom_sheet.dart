import 'package:flutter/material.dart';
// todo уточнить тип возвращаемый модалкой
Future<dynamic> showCustomModalBottomSheet({required BuildContext context, required Widget body}) async{
  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.blue.shade800,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(160, 40))),
      context: context,
      builder: (context) => body);
}
