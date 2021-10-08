import 'package:flutter/cupertino.dart';

class MainScreenModel extends ChangeNotifier{
 DateTime pickedDate = DateTime.now();
 bool isLoading = false;

  void init () async {
    print('init main screen');
  }

  void changeIsLoading(bool newIsLoading){
    isLoading = newIsLoading;
    notifyListeners();
  }
}