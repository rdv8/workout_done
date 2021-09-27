import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_event.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';

class ClientScreenBloc extends Bloc<ClientScreenEvent, ClientScreenState> {

  ClientScreenBloc()
      : super(LoadingClientScreenState());

  @override
  Stream<ClientScreenState> mapEventToState(ClientScreenEvent event) async* {
    if (event is InitialClientScreenEvent) {
      yield* _buildInitialEvent(event);
    }
  }

  Stream<ClientScreenState> _buildInitialEvent(
      InitialClientScreenEvent event) async* {
    yield LoadingClientScreenState();
  }

}
