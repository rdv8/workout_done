import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthorization extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerTrainer(
      {required String email, required String password}) async {
    final UserCredential response = await _auth.createUserWithEmailAndPassword(
        email: email, password: password,);
    return response;
  }

  Future<void> signOutTrainer() async {
    await _auth.signOut();
  }

  Future<UserCredential> signInWithEmailAndPassword ({required String email, required String password}) async {
    final UserCredential response = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return response;
  }
}
