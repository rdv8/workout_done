import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/constants/app_theme.dart';
import 'package:workout_done/constants/constants.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/client_screen/client_screen_route.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_bloc.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_state.dart';
import 'package:workout_done/screens/main_screen/main_screen_model.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen_route.dart';
import 'package:workout_done/screens/widgets/custom_circular_indicator.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/screens/widgets/gradient_container.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenBloc, MainScreenState>(
      listener: (context, state) {
        if (state is LoadingMainScreenState) {
          context.read<MainScreenModel>().changeIsLoading(state.isLoading);
        }
      },
      buildWhen: (previous, current) => current is DataMainScreenState,
      builder: (context, state) => Stack(
        children: [
          Scaffold(
            floatingActionButton: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DateButton(),
                _CustomFab(),
              ],
            ),
            drawerScrimColor: Colors.black.withOpacity(0.6),
            drawer: _CustomDrawer(),
            appBar: _CustomAppBar(),
            body: GradientContainer(child: _Body()),
          ),
          Visibility(
            visible: context.watch<MainScreenModel>().isLoading,
            child: CustomCircularIndicator(),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    //todo: Проверить свойство в AppBar'e
    return AppBar(
      centerTitle: true,
      title: Text(
        'Тренировки за ${context.read<MainScreenModel>().pickedDate.day} ${Constants.monthDayList[context.read<MainScreenModel>().pickedDate.month]}',
        style: TextStyle(color: AppColors.lightColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context.read<WorkoutListRepository>().getWorkoutDayList.length == 0
                ? Expanded(
                    child: Center(
                      child: Text(
                        'За этот день не проведено ни одной тренировки.',
                        style: TextStyle(color: AppColors.accentColor),
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        itemCount: context
                            .read<WorkoutListRepository>()
                            .getWorkoutDayList
                            .length,
                        itemBuilder: (context, index) {
                          final item = context
                              .read<WorkoutListRepository>()
                              .getWorkoutDayList[index];
                          return Dismissible(
                              background: Container(
                                padding: EdgeInsets.all(8),
                                color: Colors.red.withOpacity(0.3),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.close)),
                              ),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.mainColor,
                                    title: Text(
                                      'Удалить тренировку?',
                                      style: TextStyle(
                                          color: AppColors.accentColor),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: Text(
                                            'Дa',
                                            style: TextStyle(
                                                color: AppColors.accentColor),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            'Нет',
                                            style: TextStyle(
                                                color: AppColors.accentColor),
                                          )),
                                    ],
                                  ),
                                ).then((value) {
                                  if (value) {
                                    context.read<MainScreenBloc>().add(
                                        DeleteWorkoutMainScreenEvent(
                                            workout: item));
                                    context.read<MainScreenBloc>().add(
                                        InitialMainScreenEvent(
                                            date: context
                                                .read<MainScreenModel>()
                                                .pickedDate));
                                  }
                                });
                              },
                              onDismissed: (direction) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Удалено')));
                              },
                              key: Key(item.clientId),
                              child: ListTile(
                                  title: Center(
                                      child: Text(
                                '${index + 1}. ${item.clientLastName}',
                                style: TextStyle(color: AppColors.accentColor),
                              ))));
                        }),
                  ),
            GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! > 0) {
                    context.read<MainScreenModel>().pickedDate = context
                        .read<MainScreenModel>()
                        .pickedDate
                        .subtract(Duration(days: 1));
                    context.read<MainScreenBloc>().add(
                        ChangeDayWorkoutMainScreenEvent(
                            date: context.read<MainScreenModel>().pickedDate));

                  } else if (details.primaryVelocity! < 0) {
                    context.read<MainScreenModel>().pickedDate = context
                        .read<MainScreenModel>()
                        .pickedDate
                        .add(Duration(days: 1));
                    context.read<MainScreenBloc>().add(
                        ChangeDayWorkoutMainScreenEvent(
                            date: context.read<MainScreenModel>().pickedDate));

                  }
                }
              },
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(children: [
                      Icon(Icons.chevron_left,color: AppColors.lightColor,),
                      Icon(Icons.chevron_left,color: AppColors.lightColor,),
                    ],),
                    Row(children: [
                      Icon(Icons.chevron_right,color: AppColors.lightColor,),
                      Icon(Icons.chevron_right,color: AppColors.lightColor,),
                    ],)

                ],),
                height: 50,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.lightColor),
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.mainColor),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}


class _DateButton extends StatelessWidget {
  const _DateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32),
      child: FloatingActionButton(
        backgroundColor: AppColors.lightColor,
        child: Text(
          '${context.read<MainScreenModel>().pickedDate.day}.${context.read<MainScreenModel>().pickedDate.month}',
          style: TextStyle(
            fontSize: 18,
            color: AppColors.mainColor,
          ),
        ),
        onPressed: () async {
          await showDatePicker(
                  helpText: 'Выберите дату:',
                  cancelText: 'Отмена',
                  confirmText: 'Выбрать',
                  context: context,
                  initialDate: context.read<MainScreenModel>().pickedDate,
                  firstDate: DateTime(2021),
                  lastDate: DateTime(2030))
              .then((value) => context
                      .read<MainScreenModel>()
                      .pickedDate =
                  value ?? context.read<MainScreenModel>().pickedDate);
          context.read<MainScreenBloc>().add(
              ChangeDayWorkoutMainScreenEvent(
                  date: context.read<MainScreenModel>().pickedDate));
        },
      ),
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  const _CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        padding: const EdgeInsets.only(top: 48),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                AppColors.mainColor,
              ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Workout Done!',
                  style: TextStyle(fontSize: 30, color: AppColors.accentColor),
                ),
                Divider(
                  height: 40,
                  thickness: 3,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(clientScreenRoute());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.wc, color: AppColors.accentColor),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Клиенты',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.lightColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StatisticScreenRoute()));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.assessment_outlined,
                            color: AppColors.accentColor),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          'Статистика',
                          style: TextStyle(
                              fontSize: 20, color: AppColors.lightColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      //todo уточнить надо ли чистить листы?
                      context.read<ClientListRepository>().clearClientList();
                      context.read<TrainerRepository>().clearTrainer();
                      context.read<WorkoutListRepository>().clearWorkoutList();
                      context.read<FirebaseAuthorization>().signOutTrainer();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.exit_to_app, color: AppColors.accentColor),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text('Выход',
                            style: TextStyle(
                                fontSize: 20, color: AppColors.lightColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomModalAddWorkout extends StatelessWidget {
  const _CustomModalAddWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Тренировка за ${context.read<MainScreenModel>().pickedDate.day}.${context.read<MainScreenModel>().pickedDate.month}',
            style: TextStyle(fontSize: 20, color: AppColors.accentColor),
          ),
          Divider(
            color: AppColors.lightColor,
            height: 20,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  context.read<ClientListRepository>().getClientList.length,
              itemBuilder: (context, index) => TextButton(
                onPressed: () {
                  context.read<MainScreenBloc>().add(
                        AddWorkoutMainScreenEvent(
                            client: context
                                .read<ClientListRepository>()
                                .getClientList[index],
                            date: context.read<MainScreenModel>().pickedDate),
                      );
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  '${context.read<ClientListRepository>().getClientList[index].lastname}',
                  style: TextStyle(
                      color: AppColors.accentColor,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomFab extends StatefulWidget {
  const _CustomFab({Key? key}) : super(key: key);

  @override
  _CustomFabState createState() => _CustomFabState();
}

class _CustomFabState extends State<_CustomFab> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 1,
      backgroundColor: AppColors.lightColor,
      child: Icon(
        Icons.add,
        color: AppColors.mainColor,
      ),
      onPressed: () {
        showCustomModalBottomSheet(
          context: context,
          body: ChangeNotifierProvider.value(
            value: context.read<MainScreenModel>(),
            child: BlocProvider.value(
              value: context.read<MainScreenBloc>(),
              child: _CustomModalAddWorkout(),
            ),
          ),
        ).then((value) {
          if (value == true) {
            context.read<MainScreenBloc>().add(InitialMainScreenEvent(
                date: context.read<MainScreenModel>().pickedDate));
          }
        });
      },
    );
  }
}
