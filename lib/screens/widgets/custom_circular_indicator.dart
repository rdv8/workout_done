import 'package:flutter/material.dart';
import 'package:workout_done/constants/app_theme.dart';

class CustomCircularIndicator extends StatelessWidget {
  const CustomCircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: AppColors.mainColor,
          color: AppColors.accentColor,
        ),
      ),
    );
  }
}
