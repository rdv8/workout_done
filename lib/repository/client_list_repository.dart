import 'package:flutter/material.dart';
import 'package:workout_done/constants/test_values.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/network/firebase_firestore.dart';

class ClientListRepository extends ChangeNotifier{
  List<ClientModel>? _clientList;

  List<ClientModel> get getClientList => _clientList ?? [];

  Future<void> updateClientList() async {
    print('init client list repository');
    var response = await FirebaseData().getClientList(constTrainerId);
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
  }
}
