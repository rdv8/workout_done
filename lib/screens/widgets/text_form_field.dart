import 'package:flutter/material.dart';
import 'package:workout_done/constants/app_theme.dart';

class CustomTextFormField extends StatelessWidget {
  final bool isObscure;
  final TextEditingController controller;
  final String hintText;

  const CustomTextFormField({
    required this.isObscure,
    required this.controller,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscure,
      style: TextStyle(color: Color(0xffd1ffc9)),
      controller: controller,
      cursorColor: AppColors.lightColor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12),
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.blueColor)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1.5, color: AppColors.greenColor)),
        hintStyle: TextStyle(color: AppColors.greenColor),
        isCollapsed: true,
      ),
    );
  }
}
