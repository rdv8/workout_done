import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthorization extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void registerTrainer(
      {required String email, required String password}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password,);
  }

  void signOutTrainer() async {
    await _auth.signOut();
  }

  void signInWithEmailAndPassword ({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  void singInAnonymously() async{
    _auth.signInAnonymously();
  }

  changeAuthStateTrainer (){
   _auth.authStateChanges().listen((event) { });
  }
}
