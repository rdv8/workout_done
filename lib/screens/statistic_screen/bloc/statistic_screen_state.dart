import 'package:workout_done/models/workout_model.dart';

abstract class StatisticScreenState {}

class InitialStatisticScreenState extends StatisticScreenState {}

class DataStatisticScreenState extends StatisticScreenState {
  final List<Workout> workoutList;
  final Map<String, int> statisticList;
  final Map<String, int> statisticTypeList;

  DataStatisticScreenState({
    required this.workoutList,
    required this.statisticList,
    required this.statisticTypeList,
  });
}

class ErrorStatisticScreenState extends StatisticScreenState {
  final Object error;

  ErrorStatisticScreenState({required this.error});
}

class LoadingStatisticScreenState extends StatisticScreenState {
  final bool isLoading;

  LoadingStatisticScreenState({required this.isLoading});
}
