import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_event.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';

class ClientScreenBloc extends Bloc<ClientScreenEvent, ClientScreenState> {
  final TrainerRepository _trainerRepository;
  final ClientListRepository _clientListRepository;
  final FirebaseData _firebaseData;

  ClientScreenBloc({
    required clientListRepository,
    required firebaseData,
    required trainerRepository,
  })  : _trainerRepository = trainerRepository,
        _clientListRepository = clientListRepository,
        _firebaseData = firebaseData,
        super(ClientListScreenInitState());

  @override
  Stream<ClientScreenState> mapEventToState(ClientScreenEvent event) async* {
    if (event is InitialClientScreenEvent) {
      yield* _buildInitialEvent(event);
    }
    if (event is AddClientEvent) {
      yield* _buildAddClient(event);
    }
    if (event is ChangeClientEvent) {
      yield* _buildChangeClient(event);
    }
  }

  Stream<ClientScreenState> _buildInitialEvent(
      InitialClientScreenEvent event) async* {
    yield LoadingClientScreenState(isLoading: true);
    await _clientListRepository.updateClientList();
    final _clientList = _clientListRepository.getClientList;
    yield LoadingClientScreenState(isLoading: false);
    yield ClientListScreenDataState(clientList: _clientList);
  }

  Stream<ClientScreenState> _buildAddClient(AddClientEvent event) async* {
    yield LoadingClientScreenState(isLoading: true);
    await _firebaseData.addClient(_trainerRepository.getTrainer.id, event.client);
    await _clientListRepository.updateClientList();
    final _clientList = _clientListRepository.getClientList;
    yield LoadingClientScreenState(isLoading: false);
    yield ClientListScreenDataState(clientList: _clientList);
  }

  Stream<ClientScreenState> _buildChangeClient(ChangeClientEvent event) async* {
    yield LoadingClientScreenState(isLoading: true);
    await _firebaseData.updateClient(_trainerRepository.getTrainer.id, event.client);
    await _clientListRepository.updateClientList();
    final _clientList = _clientListRepository.getClientList;
    yield LoadingClientScreenState(isLoading: false);
    yield ClientListScreenDataState(clientList: _clientList);
  }
}
