import 'package:flutter/material.dart';
import 'package:workout_done/constants/test_values.dart';
import 'package:workout_done/models/workout_model.dart';
import 'package:workout_done/network/firebase_firestore.dart';

class WorkoutListRepository extends ChangeNotifier {
  List<Workout>? _workoutDayList;
  //List<Workout>? _workoutMonthList;
  //List<Workout>? _workoutClientList;


  List<Workout> get getWorkoutDayList => _workoutDayList ?? [];

  Future<void> updateDayWorkoutList(String date) async {
    final response =
        await FirebaseData().getDayWorkoutList(constTrainerId, date);
    _workoutDayList = response.docs
        .map(
          (e) => Workout(
            id: e.id,
            trainerId: e['trainerId'],
            clientId: e['clientId'],
            clientLastName: e['clientLastName'],
            date: e['date'],
          ),
        ).toList();
  }
}
