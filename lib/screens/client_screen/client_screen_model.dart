import 'package:flutter/material.dart';
import 'package:workout_done/models/client_model.dart';



class ClientScreenModel extends ChangeNotifier {
  final TextEditingController lastNameController  = TextEditingController();
  final TextEditingController nameController  = TextEditingController();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode nameFocusNode = FocusNode();
  String id = '';
  bool isSplit = false;
  bool isTeenage = false;
  bool isDiscount = false;
  bool isHide = false;
  bool isLoading = false;

// TODO: Проверить иниациализацию клиента
  void initClient (ClientModel client) {
    print('=====================init client screen');
    id = client.id ?? '';
    lastNameController.text = client.lastname;
    nameController.text = client.name;
    isSplit = client.isSplit;
    isTeenage = client.isTeenage;
    isDiscount = client.isDiscount;
    isHide = client.isHide ?? false;

  }

  void clearClientModel () {

    lastNameController.text = '';
    nameController.text = '';

    id = '';
    isSplit = false;
    isTeenage = false;
    isDiscount = false;
    isHide = false;
    isLoading = false;

  }

  void changeIsSplit (bool value){
    isSplit = value;
  }
  void changeIsTeenage (bool value){
    isTeenage = value;
  }
  void changeIsDiscount (bool value){
    isDiscount = value;
  }
  void changeIsHide (bool value){
    isHide = value;
  }
  void changeIsLoading (bool value) {
    isLoading = value;
    notifyListeners();
  }


  @override
  void dispose() {
    lastNameFocusNode.dispose();
    lastNameController.dispose();
    nameFocusNode.dispose();
    nameController.dispose();
    super.dispose();
  }
}