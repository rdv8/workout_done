import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_bloc.dart';
import 'package:workout_done/screens/sign_in_screen/sign_in_screen.dart';
import 'package:workout_done/screens/sign_in_screen/sign_in_screen_model.dart';

class SignInScreenRoute extends StatelessWidget {
  const SignInScreenRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignInScreenBloc>(
      create: (_) => SignInScreenBloc(
        firebaseAuthorization: context.read<FirebaseAuthorization>(),
        firebaseData: context.read<FirebaseData>(),
        trainerRepository: context.read<TrainerRepository>(),
      ),
      child: ChangeNotifierProvider<SignInScreenModel>(
        create: (_) => SignInScreenModel(),
        child: SignInScreen(),
      ),
    );
  }
}
