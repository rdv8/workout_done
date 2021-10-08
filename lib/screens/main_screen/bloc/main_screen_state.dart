import 'package:workout_done/models/workout_model.dart';

abstract class MainScreenState {
  MainScreenState();
}

class InitialMainScreenState extends MainScreenState {}

class DataMainScreenState extends MainScreenState {
  final List<Workout> workoutList;
  DataMainScreenState ({required this.workoutList});
}

class LoadingMainScreenState extends MainScreenState{
  bool isLoading = false;
  LoadingMainScreenState({required this.isLoading});
}