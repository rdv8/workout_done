import 'package:flutter/material.dart';
import 'package:workout_done/models/workout_model.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/trainer_repository.dart';

class WorkoutListRepository extends ChangeNotifier {
  late final TrainerRepository _trainerRepository;
  List<Workout>? _workoutDayList;
  List<Workout>? _workoutMonthList;

  List<Workout> get getWorkoutDayList => _workoutDayList ?? [];

  List<Workout> get getWorkoutMonthList => _workoutMonthList ?? [];

  Future<void> init({required TrainerRepository trainerRepository}) async {
    _trainerRepository = trainerRepository;
    if (_trainerRepository.getTrainer.id.isNotEmpty) {
      await updateDayWorkoutList(DateTime.now());
      //todo обновляет?
      await updateMonthWorkoutList(DateTime.now());
    }
  }

  Future<void> updateDayWorkoutList(DateTime date) async {
    final response = await FirebaseData()
        .getDayWorkoutList(_trainerRepository.getTrainer.id, date);
    _workoutDayList = response.docs
        .map(
          (e) => Workout(
            id: e.id,
            trainerId: e['trainerId'],
            clientId: e['clientId'],
            clientLastName: e['clientLastName'],
            day: e['day'],
            month: e['month'],
            year: e['year'],
            isSplit: e['isSplit'],
            isTeenage: e['isTeenage'],
            isDiscount: e['isDiscount'],
          ),
        )
        .toList();
  }

  Future<void> updateMonthWorkoutList(DateTime date) async {
    final response = await FirebaseData()
        .getMonthWorkoutList(_trainerRepository.getTrainer.id, date);
    _workoutMonthList = response.docs
        .map(
          (e) => Workout(
            id: e.id,
            trainerId: e['trainerId'],
            clientId: e['clientId'],
            clientLastName: e['clientLastName'],
            day: e['day'],
            month: e['month'],
            year: e['year'],
            isSplit: e['isSplit'],
            isTeenage: e['isTeenage'],
            isDiscount: e['isDiscount'],
          ),
        )
        .toList();
  }

  void clearWorkoutList() {
    _workoutDayList = [];
    _workoutMonthList = [];
  }
}
