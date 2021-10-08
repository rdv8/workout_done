
import 'package:workout_done/models/client_model.dart';

abstract class ClientScreenEvent {}

class InitialClientScreenEvent extends ClientScreenEvent {}

class LoadClientEvent extends ClientScreenEvent{
  final ClientModel client;
  LoadClientEvent({required this.client});
}

class AddClientEvent extends ClientScreenEvent{
  final ClientModel client;
  AddClientEvent({required this.client});
}

class ChangeClientEvent extends ClientScreenEvent {
  final ClientModel client;
  ChangeClientEvent({required this.client});
}