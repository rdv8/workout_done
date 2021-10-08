import 'package:flutter/material.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: (){context.read<FirebaseAuthorization>().signInWithEmailAndPassword(email: 'test@main.ru', password: '123456');},
                child: Text('Enter User')),
            GestureDetector(
                onTap: (){context.read<FirebaseAuthorization>().singInAnonymously();},
                child: Text('Enter Anonymously'))
          ],
        ),
      ),
    );
  }
}
