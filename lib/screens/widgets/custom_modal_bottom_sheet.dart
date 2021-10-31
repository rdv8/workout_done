import 'package:flutter/material.dart';
import 'package:workout_done/constants/app_theme.dart';
// todo уточнить тип возвращаемый модалкой
Future<dynamic> showCustomModalBottomSheet({required BuildContext context, required Widget body}) async{
  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.mainColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(160, 40))),
      context: context,
      builder: (context) => body);
}
