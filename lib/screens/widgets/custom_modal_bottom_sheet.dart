import 'package:flutter/material.dart';
import 'package:workout_done/constants/app_theme.dart';

Future<dynamic> showCustomModalBottomSheet({required BuildContext context, required Widget body}) async{
  return await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.darkColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.elliptical(160, 40))),
      context: context,
      builder: (context) => body);
}
