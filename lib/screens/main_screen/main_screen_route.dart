import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_bloc.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';
import 'package:workout_done/screens/main_screen/main_screen.dart';
import 'package:workout_done/screens/main_screen/main_screen_model.dart';

class MainScreenRoute extends StatelessWidget {
  const MainScreenRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainScreenBloc>(
        create: (_) => MainScreenBloc(
          trainerRepository: context.read<TrainerRepository>(),
          firebaseData: context.read<FirebaseData>(),
              clientListRepository: context.read<ClientListRepository>(),
              workoutListRepository: context.read<WorkoutListRepository>(),
            )..add(InitialMainScreenEvent(date: DateTime.now())),
        child: ChangeNotifierProvider<MainScreenModel>(
            create: (_) => MainScreenModel(),
            child: MainScreen()));
  }
}
