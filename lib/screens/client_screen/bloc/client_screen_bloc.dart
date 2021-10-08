import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/constants/test_values.dart';

import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_event.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';

class ClientScreenBloc extends Bloc<ClientScreenEvent, ClientScreenState> {
  final ClientListRepository _clientListRepository;
  final FirebaseData _firebaseData;

  ClientScreenBloc({required clientListRepository, required firebaseData})
      : _clientListRepository = clientListRepository,
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
    await _firebaseData.addClient(constTrainerId, event.client);
    await _clientListRepository.updateClientList();
    final _clientList = _clientListRepository.getClientList;
    yield LoadingClientScreenState(isLoading: false);
    yield ClientListScreenDataState(clientList: _clientList);
  }

  Stream<ClientScreenState> _buildChangeClient(ChangeClientEvent event) async* {
    yield LoadingClientScreenState(isLoading: true);
    await _firebaseData.updateClient(constTrainerId, event.client);
    await _clientListRepository.updateClientList();
    final _clientList = _clientListRepository.getClientList;
    yield LoadingClientScreenState(isLoading: false);
    yield ClientListScreenDataState(clientList: _clientList);
  }
}
