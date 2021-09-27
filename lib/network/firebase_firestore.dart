import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:workout_done/models/client_model.dart';

class FirebaseData {
  final _trainers = FirebaseFirestore.instance.collection('trainers');

  void getTrainerList() async {
    final trainerList = await _trainers.get();
    print('${trainerList.docs.map((e) => e['email']).toList()}');
  }

  Future<void> addTrainer() async {
    await _trainers.add({'email': '123', 'password': '123'});
  }

  Future<void> delTrainer() async {
    await _trainers.doc('ZASnnniv7ZG0EYcfwlUf').delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getClientList(String trainerID) async {
    final response =
        await _trainers.doc(trainerID).collection('clients').get();
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

  Future<void> delClient(String trainerId, String clientId) async {
    await _trainers.doc(trainerId).collection('clients').doc(clientId).delete();
  }
}