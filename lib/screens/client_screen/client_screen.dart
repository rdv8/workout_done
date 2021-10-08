import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/test_values.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_bloc.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_event.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';
import 'package:workout_done/screens/client_screen/client_screen_model.dart';
import 'package:workout_done/screens/client_screen/workout_history_screen/workout_history_screen.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';

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
      builder: (context, state) =>
          _Body(clientList: context.read<ClientListRepository>().getClientList),
    );
  }
}

class _Body extends StatelessWidget {
  final List<ClientModel> _clientList;

  const _Body({required clientList, Key? key})
      : _clientList = clientList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Клиенты'),
        ),
        body: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
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
                      '${_clientList[index].name.isEmpty ? '${index + 1}' : _clientList[index].name}'),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await showCustomModalBottomSheet(
                        context: context,
                        body: ChangeNotifierProvider.value(
                            value: context.read<ClientScreenModel>()..clearClientModel(),
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
              child: const Text('Добавить клиента'),
            ),
          ],
        ),
      ),
      Visibility(
        visible: context.watch<ClientScreenModel>().isLoading,
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
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Divider(
            color: Colors.blue.shade300,
            height: 20,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          TextFormField(
            focusNode: context.read<ClientScreenModel>().lastNameFocusNode,
            controller: context.read<ClientScreenModel>().lastNameController,
            decoration: InputDecoration(hintText: 'Фамилия'),
          ),
          TextFormField(
            focusNode: context.read<ClientScreenModel>().nameFocusNode,
            controller: context.read<ClientScreenModel>().nameController,
            decoration: InputDecoration(hintText: 'Имя'),
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
                      child: const Text('Добавить'))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseData()
                                  .delClient(constTrainerId, client?.id ?? '');
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
                             context.read<ClientScreenBloc>().add(ChangeClientEvent(client: ClientModel(
                               isHide: context.read<ClientScreenModel>().isHide,
                               id: context.read<ClientScreenModel>().id,
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
        Text(widget.title),
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
