import 'package:flutter/material.dart';

class StatisticScreenModel extends ChangeNotifier {
  DateTime pickedDate = DateTime.now();
  final Map<String,int> statisticList = {};
}