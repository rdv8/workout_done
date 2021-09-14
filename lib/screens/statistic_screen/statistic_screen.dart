import 'package:flutter/material.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Статистика'),
      ),
      body: Column(
        children: [
          Center(child: Text('Статистика')),
        ],
      ),
    );
  }
}
