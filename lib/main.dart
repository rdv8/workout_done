import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/main_screen_route.dart';
import 'package:workout_done/screens/sign_in_screen/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((event) {
    print('_CHECK USER_: $event');
  });

//todo сделать инициализацию тренера
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FirebaseData(),
        ),
        ChangeNotifierProvider(
          create: (_) => FirebaseAuthorization(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientListRepository(),
        ),
        ChangeNotifierProvider(
          create: (_) => WorkoutListRepository(),
        ),
      ],
      child: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.data == null) {
              return SignInScreen();
            } else {
              return MainScreenRoute(user: snapshot.data,);
            }
          },
      ),
    );
  }
}



