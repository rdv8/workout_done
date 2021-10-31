import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_event.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_state.dart';

class StatisticScreenBloc
    extends Bloc<StatisticScreenEvent, StatisticScreenState> {
  WorkoutListRepository _workoutListRepository;

  StatisticScreenBloc({
    required WorkoutListRepository workoutListRepository,
    required ClientListRepository clientListRepository,
  })  : _workoutListRepository = workoutListRepository,
        super(InitialStatisticScreenState()) {
    on<InitialStatisticScreenEvent>(_initial);
  }

  FutureOr<void> _initial(InitialStatisticScreenEvent event,
      Emitter<StatisticScreenState> emit) async {
    try {
      //todo сделать циркулярку
      emit(LoadingStatisticScreenState(isLoading: true));
      await _workoutListRepository.updateMonthWorkoutList(event.date);
      final _workoutList = _workoutListRepository.getWorkoutMonthList;

      if (_workoutList.isNotEmpty) {
        _workoutList.sort((a, b) => a.clientId.compareTo(b.clientId));
        //todo проработать лучше статистику(возможно переделать структуру БД(возможность посмотреть кто в сплит, кто в дисконт))

        Map<String, int> workoutCountList = {};
        Map<String, int> workoutTypeCountList = {};
        var id = _workoutList.first.clientId;
        var countWorkout = 0;
        var countTeenage = 0;
        var countDiscount = 0;
        var countSplit = 0;
        for (var i in _workoutList) {
          if (i.clientId == id) {
            countWorkout++;
            workoutCountList['${i.clientLastName}'] = countWorkout;

            if (i.isTeenage == true) {
              countTeenage++;
              workoutTypeCountList['Подростки'] = countTeenage;
            }
            if (i.isDiscount == true) {
              countDiscount++;
              workoutTypeCountList['Скидочные'] = countDiscount;
            }
            if (i.isSplit == true) {
              countSplit++;
              workoutTypeCountList['Сплит'] = countSplit;
            }
          } else {
            id = i.clientId;
            countWorkout = 1;
            workoutCountList['${i.clientLastName}'] = countWorkout;
          }
        }
        //todo не нужен тут лист? в датастейте?
        emit(LoadingStatisticScreenState(isLoading: false));
        emit(DataStatisticScreenState(
            statisticTypeList: workoutTypeCountList,
            statisticList: workoutCountList,
            workoutList: _workoutList));
      } else {
        emit(LoadingStatisticScreenState(isLoading: false));
        emit(DataStatisticScreenState(
            statisticTypeList: {}, statisticList: {}, workoutList: []));
      }
    } catch (error) {
      emit(LoadingStatisticScreenState(isLoading: false));
      emit(ErrorStatisticScreenState(error: error));
    }
  }
}
