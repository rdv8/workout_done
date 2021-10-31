import 'package:flutter/material.dart';

class WorkoutHistoryScreen extends StatelessWidget {
  const WorkoutHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History'),),
      body: Text('История'),
    );
  }
}

//todo история тренировок в модалке с клиентом по id
/*
final y = await context.read<FirebaseData>().getClientWorkoutList(
context.read<TrainerRepository>().getTrainer.id,
context
    .read<ClientListRepository>()
.getClientList[0]
.id ??
'',
);*/
