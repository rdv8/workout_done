import 'package:flutter/material.dart';

class AppTheme{
  static final appThemeData = ThemeData(
    fontFamily: 'Ubuntu',
    primaryColor: AppColors.darkColor,
    primarySwatch: AppColors.mainMaterialColor,
    backgroundColor: AppColors.darkColor,
    scaffoldBackgroundColor: AppColors.darkColor,
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      iconTheme: IconThemeData(color: AppColors.greenColor),
      color: Colors.black,
      elevation: 10,
    ),
    textTheme: TextTheme(
      headline5: TextStyle(fontWeight: FontWeight.bold),
    ),

  );
}

class AppColors {
  static const Color darkColor = Color(0xff09231c);
  static const MaterialColor mainMaterialColor = MaterialColor(0xff085a42, <int,Color>{
    50: Color(0xffd1ffc9),
    100: Color(0xffd1ffc9),
    200: Color(0xffd1ffc9),
    300: Color(0xffd1ffc9),
    400: Color(0xff085a42),
    500: Color(0xff085a42),
    600: Color(0xff085a42),
    700: Color(0xff09231c),
    800: Color(0xff09231c),
    900: Color(0xff09231c),
  });
  static const Color lightColor = Color(0xff879a79);
  static const Color greenColor = Color(0xff879a79);
  static const Color blueColor = Color(0xff879a79);
  static const Color pinkColor = Color(0xff879a79);


}


/*
static const MaterialColor green = MaterialColor(
  _greenPrimaryValue,
  <int, Color>{
    50: Color(0xFFE8F5E9),
    100: Color(0xFFC8E6C9),
    200: Color(0xFFA5D6A7),
    300: Color(0xFF81C784),
    400: Color(0xFF66BB6A),
    500: Color(_greenPrimaryValue),
    600: Color(0xFF43A047),
    700: Color(0xFF388E3C),
    800: Color(0xFF2E7D32),
    900: Color(0xFF1B5E20),
  },
);*/
