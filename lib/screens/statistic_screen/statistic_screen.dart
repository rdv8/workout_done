import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/network/firebase_auth.dart';

class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> firestore =
        FirebaseFirestore.instance.collection('trainers');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Статистика'),
      ),
      body: Column(
        children: [
          Center(child: Text('')),
          StreamBuilder(
              stream: firestore.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshots) =>
                  (snapshots.hasData
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: 3,
                          itemBuilder: (context, index) => ListTile(
                                title: Text('1'),
                              ))
                      : Text('Пусто'))),
          ElevatedButton(
              onPressed: () {},
              child: Text('123')),
          ElevatedButton(
              onPressed: () {
               context.read<FirebaseAuthorization>().registerTrainer(email: 'test@main.ru', password: '123456');
              },
              child: Text('add trainer'))
        ],
      ),
    );
  }
}
