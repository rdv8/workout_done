import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  Future<void> addTrainer({required User? user}) async {
    await _trainers.doc(user?.uid).set({
      'email': user?.email,
    });
  }

  Future<void> delTrainer(Trainer trainer) async {
    await _trainers.doc('ZASnnniv7ZG0EYcfwlUf').delete();
  }

  Future<void> updateTrainer({required User? user}) async {
    await _trainers.doc(user?.uid).update({
      'email': user?.email,
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
      String trainerID, DateTime date) async {
    final response = await _trainers
        .doc(trainerID)
        .collection('workouts')
        .where('day', isEqualTo: date.day)
        .where('month', isEqualTo: date.month)
        .where('year', isEqualTo: date.year)
        .get();
    return response;
  }

  //todo orderBy сделать сортированные листы

  Future<QuerySnapshot<Map<String, dynamic>>> getMonthWorkoutList(
      String trainerID, DateTime date) async {
    final response = await _trainers
        .doc(trainerID)
        .collection('workouts')
        .where('year', isEqualTo: date.year)
        .where('month', isEqualTo: date.month)
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
    await _trainers.doc(workout.trainerId).collection('workouts').add({
      'trainerId': workout.trainerId,
      'clientId': workout.clientId,
      'clientLastName': workout.clientLastName,
      'day': workout.day,
      'month': workout.month,
      'year': workout.year,
      'isSplit': workout.isSplit,
      'isDiscount': workout.isDiscount,
      'isTeenage': workout.isTeenage,

    });
  }

  Future<void> delWorkout(Workout workout) async {
    await _trainers
        .doc(workout.trainerId)
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
      'day': workout.day,
      'month': workout.month,
      'year': workout.year,
    });
  }
}
