import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/models/workout_model.dart';

abstract class MainScreenEvent {
  MainScreenEvent();
}

class InitialMainScreenEvent extends MainScreenEvent {
  final DateTime date;

  InitialMainScreenEvent({required this.date});
}

class AddWorkoutMainScreenEvent extends MainScreenEvent {
  final DateTime date;
  final ClientModel client;

  AddWorkoutMainScreenEvent({
    required this.date,
    required this.client,
  });
}

class ChangeDayWorkoutMainScreenEvent extends MainScreenEvent{
 final DateTime date;

  ChangeDayWorkoutMainScreenEvent({required this.date});
}

class DeleteWorkoutMainScreenEvent extends MainScreenEvent {
  final Workout workout;

  DeleteWorkoutMainScreenEvent({required this.workout});
}
