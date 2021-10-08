import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/models/trainer_model.dart';
import 'package:workout_done/models/workout_model.dart';

//todo нужен ли нотифайер
class FirebaseData extends ChangeNotifier {
  final _trainers = FirebaseFirestore.instance.collection('trainers');

  /// Тренер
  //todo сделать футуре воид?
  void getTrainerList() async {
    final trainerList = await _trainers.get();
    print('${trainerList.docs.map((e) => e['email']).toList()}');
  }

  Future<void> addTrainer(Trainer trainer) async {
    await _trainers.add({'email': '123', 'password': '123'});
  }

  Future<void> delTrainer(Trainer trainer) async {
    await _trainers.doc('ZASnnniv7ZG0EYcfwlUf').delete();
  }

  Future<void> updateTrainer(Trainer trainer) async {
    await _trainers.doc(trainer.id).update({
      'email': trainer.email,
      'password': trainer.password,
    });
  }

  /// Client
  Future<QuerySnapshot<Map<String, dynamic>>> getClientList(
      String trainerID) async {
    final response = await _trainers.doc(trainerID).collection('clients').get();
    return response;
  }

  Future<void> addClient(String trainerId, ClientModel client) async {
    await _trainers.doc(trainerId).collection('clients').add({
      'lastname': client.lastname,
      'name': client.name,
      'isSplit': client.isSplit,
      'isTeenage': client.isTeenage,
      'isDiscount': client.isDiscount,
      'isHide': client.isHide
    });
  }

  Future<void> updateClient(String trainerId, ClientModel client) async {
    await _trainers.doc(trainerId).collection('clients').doc(client.id).update({
      'lastname': client.lastname,
      'name': client.name,
      'isSplit': client.isSplit,
      'isTeenage': client.isTeenage,
      'isDiscount': client.isDiscount,
      'isHide': client.isHide,
    });
  }

  Future<void> delClient(String trainerId, String clientId) async {
    await _trainers.doc(trainerId).collection('clients').doc(clientId).delete();
  }

  /// Workout

  Future<QuerySnapshot<Map<String, dynamic>>> getAllWorkoutList(
      String trainerID) async {
    final response =
        await _trainers.doc(trainerID).collection('workouts').get();
    return response;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDayWorkoutList(
      String trainerID, String date) async {
    final response = await _trainers
        .doc(trainerID)
        .collection('workouts')
        .where('date', isEqualTo: date)
        .get();
    return response;
  }
 //todo: сделать месячный фильтр
  Future<QuerySnapshot<Map<String, dynamic>>> getMonthWorkoutList(
      String trainerID, String date) async {
    final response = await _trainers
        .doc(trainerID)
        .collection('workouts')
        .where('date', isEqualTo: date)
        .get();
    return response;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClientWorkoutList(
      String trainerID, String clientId) async {
    final response = await _trainers
        .doc(trainerID)
        .collection('workouts')
        .where('clientId', isEqualTo: clientId)
        .get();
    return response;
  }

  Future<void> addWorkout(Workout workout) async {
    await _trainers
        .doc(workout.trainerId)
        .collection('workouts')
        .add({
      'trainerId': workout.trainerId,
      'clientId': workout.clientId,
      'clientLastName' : workout.clientLastName,
      'date': workout.date,
    });
  }

  Future<void> delWorkout(
      Workout workout) async {
    await _trainers
        .doc(workout.trainerId)
        .collection('clients')
        .doc(workout.clientId)
        .collection('workouts')
        .doc(workout.id)
        .delete();
  }

  Future<void> updateWorkout(Workout workout) async {
    await _trainers
        .doc(workout.trainerId)
        .collection('clients')
        .doc(workout.clientId)
        .collection('workouts')
        .doc(workout.id)
        .update({
      'date': workout.date,
    });
  }
}
