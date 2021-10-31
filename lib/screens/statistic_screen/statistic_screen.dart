import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/app_theme.dart';
import 'package:workout_done/constants/constants.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_bloc.dart';
import 'package:workout_done/screens/statistic_screen/bloc/statistic_screen_state.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen_model.dart';
import 'package:workout_done/screens/widgets/gradient_container.dart';

//todo сделать route в статистику и сделать инициализацию списка при открытии.
class StatisticScreen extends StatelessWidget {
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatisticScreenBloc, StatisticScreenState>(
      buildWhen: (previous, current) => current is DataStatisticScreenState,
      listener: (context, state) {},
      builder: (context, state) =>
          //todo как правильно реализовать получение нужного стейта?
          state is DataStatisticScreenState
              ? Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text('Статистика',style: TextStyle(color: AppColors.lightColor),),
                  ),
                  body:
                  GradientContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // todo сделать переключение или выбор месяца. Расписать по фамилиям кол-во тре-ок и сплит, дети?
                        Center(
                          child: Text(
                              'Количество тренирвок за ${Constants.monthList[context.read<StatisticScreenModel>().pickedDate.month]}',style: TextStyle(color: AppColors.accentColor),),
                        ),
                        Center(
                          child: Text(
                              '${context.read<WorkoutListRepository>().getWorkoutMonthList.length}',style: TextStyle(color: AppColors.accentColor),),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ...state.statisticList.entries.map(
                          (workout) => Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${workout.key}',style: TextStyle(color: AppColors.accentColor),),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text('${workout.value}',style: TextStyle(color: AppColors.accentColor),),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ...state.statisticTypeList.entries.map(
                          (type) => Container(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${type.key}',style: TextStyle(color: AppColors.accentColor),),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text('${type.value}',style: TextStyle(color: AppColors.accentColor),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox.shrink(),
    );
  }
}
