import 'package:flutter/material.dart';
import 'package:workout_done/constants/app_theme.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;
  const GradientContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [AppColors.darkColor, Colors.black]),
      ),
      child: child,
    );
  }
}
