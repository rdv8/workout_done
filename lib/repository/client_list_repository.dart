import 'package:flutter/material.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/trainer_repository.dart';

class ClientListRepository extends ChangeNotifier{
  late final TrainerRepository _trainerRepository;
  List<ClientModel>? _clientList;

  List<ClientModel> get getClientList => _clientList ?? [];

  void init({required TrainerRepository trainerRepository}){
    _trainerRepository = trainerRepository;
    if (_trainerRepository.getTrainer.id.isNotEmpty) {
      updateClientList();
    }
  }

  Future<void> updateClientList() async {
    var response = await FirebaseData().getClientList(_trainerRepository.getTrainer.id);
    _clientList = response.docs
        .map(
          (e) => ClientModel(
            id: e.id,
            lastname: e['lastname'],
            name: e['name'],
            isSplit: e['isSplit'],
            isTeenage: e['isTeenage'],
            isDiscount: e['isDiscount'],
            isHide: e['isHide'],
          ),
        ).toList();
    _clientList?.sort((a,b){return a.lastname.compareTo(b.lastname);});
  }

  void clearClientList() {
    _clientList = [];
  }
}
