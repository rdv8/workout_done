import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/app_theme.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_bloc.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_event.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';
import 'package:workout_done/screens/client_screen/client_screen_model.dart';
import 'package:workout_done/screens/client_screen/workout_history_screen/workout_history_screen.dart';
import 'package:workout_done/screens/widgets/custom_circular_indicator.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';
import 'package:workout_done/screens/widgets/gradient_container.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientScreenBloc, ClientScreenState>(
      listener: (context, state) {
        if (state is LoadingClientScreenState) {
          context.read<ClientScreenModel>().changeIsLoading(state.isLoading);
        }
      },
      buildWhen: (previous, current) => current is ClientListScreenDataState,
      builder: (context, state) => Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Клиенты',
              style: TextStyle(color: AppColors.lightColor),
            ),
          ),
          body: GradientContainer(
            child: _Body(
                clientList: context.read<ClientListRepository>().getClientList),
          )),
    );
  }
}

class _Body extends StatelessWidget {
  final List<ClientModel> _clientList;

  const _Body({required List<ClientModel> clientList, Key? key})
      : _clientList = clientList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _clientList.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  showCustomModalBottomSheet(
                      context: context,
                      body: BlocProvider.value(
                        value: context.read<ClientScreenBloc>(),
                        child: ChangeNotifierProvider.value(
                          value: context.read<ClientScreenModel>()
                            ..initClient(_clientList[index]),
                          child: CustomModalClient(
                            client: _clientList[index],
                          ),
                        ),
                      )).then((value) {
                    if (value == true) {
                      context
                          .read<ClientScreenBloc>()
                          .add(InitialClientScreenEvent());
                    }
                  });
                },
                title: Center(
                  child: Text(
                    '${_clientList[index].lastname.isEmpty ? '${index + 1}' : _clientList[index].lastname} ${_clientList[index].isSplit == true ? '(Сплит)' : ''}',
                    style: TextStyle(color: AppColors.accentColor),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.lightColor)))),
            onPressed: () async {
              await showCustomModalBottomSheet(
                      context: context,
                      body: ChangeNotifierProvider.value(
                          value: context.read<ClientScreenModel>()
                            ..clearClientModel(),
                          child: BlocProvider.value(
                              value: context.read<ClientScreenBloc>(),
                              child: CustomModalClient())))
                  .then((value) {
                if (value == true) {
                  context
                      .read<ClientScreenBloc>()
                      .add(InitialClientScreenEvent());
                }
              });
            },
            child: const Text(
              'Добавить клиента',
              style: TextStyle(
                color: AppColors.accentColor,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      Visibility(
        visible: context.watch<ClientScreenModel>().isLoading,
        child: CustomCircularIndicator(),
      )
    ]);
  }
}

class CustomModalClient extends StatelessWidget {
  final ClientModel? client;

  const CustomModalClient({this.client, Key? key}) : super(key: key);

// TODO: Чекнуть размер модалки, убрать оверсайз
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            client == null ? 'Добавить клиента' : "${client?.name}",
            style: TextStyle(fontSize: 20, color: AppColors.accentColor),
          ),
          Divider(
            color: AppColors.lightColor,
            height: 20,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            cursorColor: AppColors.lightColor,
            style: TextStyle(color: AppColors.accentColor),
            focusNode: context.read<ClientScreenModel>().lastNameFocusNode,
            controller: context.read<ClientScreenModel>().lastNameController,
            decoration: InputDecoration(
              hintText: 'Фамилия',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightColor),
              ),
            ),
          ),
          TextFormField(
            textCapitalization: TextCapitalization.words,
            cursorColor: AppColors.lightColor,
            style: TextStyle(color: AppColors.accentColor),
            focusNode: context.read<ClientScreenModel>().nameFocusNode,
            controller: context.read<ClientScreenModel>().nameController,
            decoration: InputDecoration(
              hintText: 'Имя',
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightColor),
              ),
            ),
          ),
          CheckBoxRow(
            title: 'Сплит',
            value: context.read<ClientScreenModel>().isSplit,
            onChanged: context.read<ClientScreenModel>().changeIsSplit,
          ),
          CheckBoxRow(
            title: 'Подросток',
            value: context.read<ClientScreenModel>().isTeenage,
            onChanged: context.read<ClientScreenModel>().changeIsTeenage,
          ),
          CheckBoxRow(
            title: 'Скидка',
            value: context.read<ClientScreenModel>().isDiscount,
            onChanged: context.read<ClientScreenModel>().changeIsDiscount,
          ),
          client == null
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Divider(
                      thickness: 3,
                      color: Colors.black26,
                    ),
                    CheckBoxRow(
                      title: 'Скрыть клиeнта',
                      value: context.read<ClientScreenModel>().isHide,
                      onChanged: context.read<ClientScreenModel>().changeIsHide,
                    ),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: client == null
                  ? ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: AppColors.lightColor)))),
                      onPressed: () {
                        context.read<ClientScreenBloc>().add(
                              AddClientEvent(
                                client: ClientModel(
                                  lastname: context
                                      .read<ClientScreenModel>()
                                      .lastNameController
                                      .text,
                                  name: context
                                      .read<ClientScreenModel>()
                                      .nameController
                                      .text,
                                  isSplit:
                                      context.read<ClientScreenModel>().isSplit,
                                  isTeenage: context
                                      .read<ClientScreenModel>()
                                      .isTeenage,
                                  isDiscount: context
                                      .read<ClientScreenModel>()
                                      .isDiscount,
                                ),
                              ),
                            );
                        Navigator.pop(context, true);
                      },
                      child: const Text(
                        'Добавить',
                        style: TextStyle(
                          color: AppColors.accentColor,
                        ),
                      ))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseData().delClient(
                                  context
                                      .read<TrainerRepository>()
                                      .getTrainer
                                      .id,
                                  client?.id ?? '');
                              Navigator.pop(context, true);
                            },
                            child: const Text('Удалить клиента')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      WorkoutHistoryScreen()));
                            },
                            child: const Text('История тренировок')),
                        ElevatedButton(
                            onPressed: () async {
                              context
                                  .read<ClientScreenBloc>()
                                  .add(ChangeClientEvent(
                                      client: ClientModel(
                                    isHide: context
                                        .read<ClientScreenModel>()
                                        .isHide,
                                    id: context.read<ClientScreenModel>().id,
                                    lastname: context
                                        .read<ClientScreenModel>()
                                        .lastNameController
                                        .text,
                                    name: context
                                        .read<ClientScreenModel>()
                                        .nameController
                                        .text,
                                    isSplit: context
                                        .read<ClientScreenModel>()
                                        .isSplit,
                                    isTeenage: context
                                        .read<ClientScreenModel>()
                                        .isTeenage,
                                    isDiscount: context
                                        .read<ClientScreenModel>()
                                        .isDiscount,
                                  )));
                              Navigator.pop(context, true);
                            },
                            child: const Text('Сохранить изменения')),
                      ],
                    )),
        ],
      ),
    );
  }
}

class CheckBoxRow extends StatefulWidget {
  final String title;
  final Function onChanged;
  final bool value;

  CheckBoxRow(
      {required this.title,
      required this.onChanged,
      required this.value,
      Key? key})
      : super(key: key);

  @override
  _CheckBoxRowState createState() => _CheckBoxRowState(value);
}

class _CheckBoxRowState extends State<CheckBoxRow> {
  _CheckBoxRowState(this.isChecked);

  bool isChecked;

  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(color: AppColors.accentColor),
        ),
        const SizedBox(
          width: 8,
        ),
        Checkbox(
            value: isChecked,
            onChanged: (newValue) {
              setState(() {
                isChecked = newValue ?? false;
                widget.onChanged(newValue);
              });

              // widget.onChanged(newValue);
            }),
      ],
    );
  }
}
