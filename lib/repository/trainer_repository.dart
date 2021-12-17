import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:workout_done/models/trainer_model.dart';
import 'package:workout_done/network/firebase_data.dart';

class TrainerRepository extends ChangeNotifier {
  TrainerModel? _trainer;

  TrainerModel get getTrainer => _trainer ?? TrainerModel.empty();

  void init({required FirebaseData firebaseData}){
  }


  void initTrainer({required User? user}) async {
    _trainer = TrainerModel(
      id: user?.uid ?? '',
      email: user?.email ?? '',
    );
  }

  void clearTrainer(){
    _trainer = TrainerModel.empty();
  }
}
