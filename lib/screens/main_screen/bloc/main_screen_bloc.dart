import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/constants/test_values.dart';
import 'package:workout_done/models/workout_model.dart';
import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  WorkoutListRepository _workoutListRepository;
  ClientListRepository _clientListRepository;
  FirebaseData _firebaseData;

  MainScreenBloc(
      {required workoutListRepository,
      required clientListRepository,
      required firebaseData})
      : _workoutListRepository = workoutListRepository,
        _clientListRepository = clientListRepository,
        _firebaseData = firebaseData,
        super(InitialMainScreenState());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is InitialMainScreenEvent) {
      yield* _buildInitialMainScreenEvent(event);
    } else if (event is AddWorkoutMainScreenEvent) {
      yield* _buildAddWorkoutMainScreenEvent(event);
    }
  }

  Stream<MainScreenState> _buildInitialMainScreenEvent(
      InitialMainScreenEvent event) async* {
    yield LoadingMainScreenState(isLoading: true);

    await _workoutListRepository
        .updateDayWorkoutList(DateTime.now().toString().substring(0, 10));
    //todo найти место для инициализации списков  initstate?
    await _clientListRepository.updateClientList();

    final workoutList = _workoutListRepository.getWorkoutDayList;
    yield LoadingMainScreenState(isLoading: false);
    yield DataMainScreenState(workoutList: workoutList);
  }

  Stream<MainScreenState> _buildAddWorkoutMainScreenEvent(
      AddWorkoutMainScreenEvent event) async* {
    await _firebaseData.addWorkout(
      Workout(
        trainerId: constTrainerId,
        clientId: event.clientId,
        clientLastName: event.clientLastName,
        date: event.date,
      ),
    );
  }
}
