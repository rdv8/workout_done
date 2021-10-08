import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/workout_list_repository.dart';
import 'package:workout_done/screens/client_screen/client_screen_route.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_bloc.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_event.dart';
import 'package:workout_done/screens/main_screen/bloc/main_screen_state.dart';
import 'package:workout_done/screens/main_screen/main_screen_model.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
          if(state is LoadingMainScreenState){
            context.read<MainScreenModel>().changeIsLoading(state.isLoading);
          }
        },
        buildWhen: (previous, current) => current is DataMainScreenState,
        builder: (context, state) => SafeArea(
          child: Stack(
            children: [
              Scaffold(
                drawerScrimColor: Colors.black.withOpacity(0.6),
                backgroundColor: Colors.blue,
                drawer: _CustomDrawer(),
                appBar: _CustomAppBar(),
                body: _Body(),
              ),
              Visibility(
                visible: context.watch<MainScreenModel>().isLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blueAccent,
                      color: Colors.white,
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    //todo: Проверить свойство в AppBar'e
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return AppBar(
      elevation: 30,
      centerTitle: true,
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
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue.shade700, width: 24),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(120),
              bottomLeft: Radius.circular(120),
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  itemCount: context
                      .read<WorkoutListRepository>()
                      .getWorkoutDayList
                      .length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      showMenu(
                          context: context,
                          position: RelativeRect.fromLTRB(30, 30, 30, 30),
                          items: [
                            PopupMenuItem(child: Text('PopupMenuItem $index')),
                          ]);
                    },
                    child: ListTile(
                      title: Center(
                          child: Text(
                              '${context.read<WorkoutListRepository>().getWorkoutDayList[index].clientLastName}')),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 28, left: 16),
          child: _DateButton(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 28, bottom: 28),
            child: FloatingActionButton(
              heroTag: 1,
              backgroundColor: Colors.blue.shade700,
              child: Icon(Icons.add),
              onPressed: () {
                showCustomModalBottomSheet(
                    context: context,
                    body: BlocProvider.value(
                        value: context.read<MainScreenBloc>(),
                        child: CustomModalAddWorkout(),),).then((value) {
                          if (value == true) {
                            context.read<MainScreenBloc>().add(InitialMainScreenEvent());
                          }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
//todo сделать отобрежение по датам
class _DateButton extends StatefulWidget {
  const _DateButton({Key? key}) : super(key: key);

  @override
  __DateButtonState createState() => __DateButtonState();
}

class __DateButtonState extends State<_DateButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: GestureDetector(
              onTap: () {
                context.read<MainScreenModel>().pickedDate = context
                    .read<MainScreenModel>()
                    .pickedDate
                    .subtract(Duration(days: 1));
                setState(() {});
              },
              child: Icon(
                Icons.arrow_left,
                color: Colors.blue.shade900,
                size: 32,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: FloatingActionButton(
            heroTag: 2,
            backgroundColor: Colors.blue.shade700,
            child: Text(
              '${context.read<MainScreenModel>().pickedDate.day}.${context.read<MainScreenModel>().pickedDate.month}',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () async {
              await showDatePicker(
                      context: context,
                      initialDate: context.read<MainScreenModel>().pickedDate,
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2030))
                  .then((value) => context.read<MainScreenModel>().pickedDate =
                      value ?? context.read<MainScreenModel>().pickedDate);
              setState(() {});
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 64.0, top: 12),
          child: GestureDetector(
              onTap: () {
                context.read<MainScreenModel>().pickedDate = context
                    .read<MainScreenModel>()
                    .pickedDate
                    .add(Duration(days: 1));
                setState(() {});
              },
              child: Icon(
                Icons.arrow_right,
                color: Colors.blue.shade900,
                size: 32,
              )),
        ),
      ],
    );
  }
}

class _CustomDrawer extends StatelessWidget {
  const _CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.blue,
              ),
              const Text(
                'Workout Done!',
                style: TextStyle(fontSize: 30),
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
                      Icon(
                        Icons.wc,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Клиенты',
                        style: TextStyle(fontSize: 20),
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
                        builder: (context) => StatisticScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.assessment_outlined),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Статистика',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: () {context.read<FirebaseAuthorization>().signOutTrainer();},
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      const SizedBox(
                        width: 8,
                      ),
                      const Text('Выход', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomModalAddWorkout extends StatelessWidget {
  const CustomModalAddWorkout({Key? key}) : super(key: key);

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
            'Тренировка за ${context.read<MainScreenModel>().pickedDate.day}. ${context.read<MainScreenModel>().pickedDate.month}',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Divider(
            color: Colors.blue.shade300,
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
                          clientLastName: context
                              .read<ClientListRepository>()
                              .getClientList[index]
                              .lastname,
                          clientId: context
                                  .read<ClientListRepository>()
                                  .getClientList[index]
                                  .id ??
                              '',
                          date: context
                              .read<MainScreenModel>()
                              .pickedDate
                              .toString()
                              .substring(0, 10),
                        ),
                      );
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  '${context.read<ClientListRepository>().getClientList[index].lastname}',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
