import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_bloc.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';

import 'package:workout_done/screens/main_screen/main_screen.dart';
import 'package:workout_done/screens/main_screen/main_screen_model.dart';

class MainScreenRoute extends StatelessWidget {
  final User? user;
  const MainScreenRoute({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainScreenBloc>(
        create: (_) => MainScreenBloc(
          firebaseData: context.read<FirebaseData>(),
              clientListRepository: context.read<ClientListRepository>(),
              workoutListRepository: context.read<WorkoutListRepository>(),
            )..add(InitialMainScreenEvent()),
        child: ChangeNotifierProvider<MainScreenModel>(
            create: (_) => MainScreenModel(),
            child: MainScreen()));
  }
}
