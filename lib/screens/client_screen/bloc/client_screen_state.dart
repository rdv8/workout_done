import 'package:workout_done/models/client_model.dart';

abstract class ClientScreenState {}

class ClientListScreenInitState extends ClientScreenState{}

class LoadingClientScreenState extends ClientScreenState{
  bool isLoading = false;
  LoadingClientScreenState({required this.isLoading});
}

class ClientListScreenDataState extends ClientScreenState {
  final List<ClientModel> clientList;
  ClientListScreenDataState ({required this.clientList});
}

