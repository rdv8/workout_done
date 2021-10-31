import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_bloc.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_event.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen_model.dart';

class StatisticScreenRoute extends StatelessWidget {
  const StatisticScreenRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatisticScreenBloc>(
      create: (_) => StatisticScreenBloc(
        clientListRepository: context.read<ClientListRepository>(),
        workoutListRepository: context.read<WorkoutListRepository>(),
      )..add(InitialStatisticScreenEvent(
          date: DateTime.now())),
      child: ChangeNotifierProvider<StatisticScreenModel>(
          create: (_) => StatisticScreenModel(),
          child: StatisticScreen()),
    );
  }
}
