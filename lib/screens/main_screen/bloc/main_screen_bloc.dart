import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/models/workout_model.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  TrainerRepository _trainerRepository;
  WorkoutListRepository _workoutListRepository;
  ClientListRepository _clientListRepository;
  FirebaseData _firebaseData;

  MainScreenBloc({
    required trainerRepository,
    required workoutListRepository,
    required clientListRepository,
    required firebaseData,
  })  : _workoutListRepository = workoutListRepository,
        _clientListRepository = clientListRepository,
        _firebaseData = firebaseData,
        _trainerRepository = trainerRepository,
        super(InitialMainScreenState());

  @override
  Stream<MainScreenState> mapEventToState(MainScreenEvent event) async* {
    if (event is InitialMainScreenEvent) {
      yield* _buildInitialMainScreenEvent(event);
    } else if (event is AddWorkoutMainScreenEvent) {
      yield* _buildAddWorkoutMainScreenEvent(event);
    } else if (event is ChangeDayWorkoutMainScreenEvent) {
      yield* _buildChangeDayWorkoutMainScreenEvent(event);
    } else if (event is DeleteWorkoutMainScreenEvent) {
      yield* _buildDeleteWorkoutMainScreenEvent(event);
    }
  }

  Stream<MainScreenState> _buildInitialMainScreenEvent(
      InitialMainScreenEvent event) async* {
    yield LoadingMainScreenState(isLoading: true);
    try {
      await _workoutListRepository
          .updateDayWorkoutList(event.date);
      //todo зачем апдейтить клиент лист?
      await _clientListRepository.updateClientList();
      final workoutList = _workoutListRepository.getWorkoutDayList;
      workoutList.sort((a,b)=> a.clientLastName.compareTo(b.clientLastName));
      yield LoadingMainScreenState(isLoading: false);
      //todo нахрена тут лист?
      yield DataMainScreenState(workoutList: workoutList);
    }catch(e){
      print('$e');
      yield LoadingMainScreenState(isLoading: false);
      yield DataMainScreenState(workoutList: []);
    }


  }

  Stream<MainScreenState> _buildAddWorkoutMainScreenEvent(
      AddWorkoutMainScreenEvent event) async* {
    //todo доделать, распределить как-то с initialEvent задачи
    try{
      await _firebaseData.addWorkout(
        WorkoutModel(
          trainerId: _trainerRepository.getTrainer.id,
          clientId: event.client.id ?? '',
          clientLastName: event.client.lastname,
          day: event.date.day,
          month: event.date.month,
          year: event.date.year,
          isSplit: event.client.isSplit,
          isTeenage: event.client.isTeenage,
          isDiscount: event.client.isDiscount,
        ),
      );
      await _workoutListRepository
          .updateMonthWorkoutList(event.date);

    }catch(e){
      print('$e');
    }
  }

  Stream<MainScreenState> _buildChangeDayWorkoutMainScreenEvent(ChangeDayWorkoutMainScreenEvent event) async*{
    yield LoadingMainScreenState(isLoading: true);
    try {
      await _workoutListRepository
          .updateDayWorkoutList(event.date);
      await _workoutListRepository
          .updateMonthWorkoutList(event.date);
      //await _clientListRepository.updateClientList();

      final workoutList = _workoutListRepository.getWorkoutDayList;
      yield LoadingMainScreenState(isLoading: false);
      yield DataMainScreenState(workoutList: workoutList);
    }catch(e){
      print('$e');
      yield LoadingMainScreenState(isLoading: false);
      yield DataMainScreenState(workoutList: []);
    }
  }

  Stream<MainScreenState> _buildDeleteWorkoutMainScreenEvent(DeleteWorkoutMainScreenEvent event) async* {
    yield LoadingMainScreenState(isLoading: true);
    try {
      //todo проверить нужны ли стейты загрузки, обновлять ли с этого ивента или запускать инитиал
      await _firebaseData.delWorkout(event.workout);
      yield LoadingMainScreenState(isLoading: false);
    }catch(e){
      print('$e');
      yield LoadingMainScreenState(isLoading: false);
      yield DataMainScreenState(workoutList: []);
    }
  }
}
