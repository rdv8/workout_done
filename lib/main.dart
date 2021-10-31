import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/app_theme.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/main_screen_route.dart';
import 'package:workout_done/screens/sign_in_screen/sign_in_screen_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('___Initialed User___${FirebaseAuth.instance.currentUser?.uid}');
 //todo сделать инициализацию списков клиентов и тренировок до открытие приложения?
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthorization(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseData(),
        ),
        ChangeNotifierProvider(
          create: (_) => TrainerRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientListRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkoutListRepository(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    context
        .read<TrainerRepository>()
        .init(firebaseData: context.read<FirebaseData>());
    context
        .read<ClientListRepository>()
        .init(trainerRepository: context.read<TrainerRepository>());
    context
        .read<WorkoutListRepository>()
        .init(trainerRepository: context.read<TrainerRepository>());
    //todo инициализируется ли список месячный????

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.appThemeData,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            context.read<TrainerRepository>().initTrainer(user: snapshot.data);
            return MainScreenRoute();
          } else {
            return SignInScreenRoute();
          }
        },
      ),
    );
  }
}
