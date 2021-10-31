import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:workout_done/models/trainer_model.dart';
import 'package:workout_done/network/firebase_data.dart';

class TrainerRepository extends ChangeNotifier {
  //late final FirebaseData _firebaseData;
  Trainer? _trainer;

  Trainer get getTrainer => _trainer ?? Trainer.empty();

  void init({required FirebaseData firebaseData}){
   // _firebaseData = firebaseData;

  }


  void initTrainer({required User? user}) async {
    _trainer = Trainer(
      id: user?.uid ?? '',
      email: user?.email ?? '',
    );
  }

  void clearTrainer(){
    _trainer = Trainer.empty();
  }
}
