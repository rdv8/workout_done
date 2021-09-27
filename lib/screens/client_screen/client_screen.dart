import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/test_values.dart';
import 'package:workout_done/models/client_model.dart';
import 'package:workout_done/network/firebase_firestore.dart';
import 'package:workout_done/repository/client_list_repository.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_bloc.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_state.dart';
import 'package:workout_done/screens/client_screen/client_screen_model.dart';
import 'package:workout_done/screens/client_screen/workout_history_screen/workout_history_screen.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClientScreenBloc, ClientScreenState>(
        listener: (context, state) {}, builder: (context, state) => _Body());
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Клиенты'),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount:
                context.read<ClientListRepository>().getClientList.length,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                showCustomModalBottomSheet(
                    context: context,
                    body: ChangeNotifierProvider.value(
                      value: ClientScreenModel()..initClient(context.read<ClientListRepository>().getClientList[index]),
                      child: CustomModalClient(
                        client: context
                            .read<ClientListRepository>()
                            .getClientList[index],
                      ),
                    ));
              },
              title: Center(
                  child: Text(
                      '${index + 1} ${context.read<ClientListRepository>().getClientList[index].name}')),
            ),
          ),
          TextButton(
            onPressed: () {
              showCustomModalBottomSheet(
                  context: context,
                  body: ChangeNotifierProvider.value(
                      value: ClientScreenModel(), child: CustomModalClient()));
            },
            child: Text('Добавить клиента'),
          ),
        ],
      ),
    );
  }
}

class CustomModalClient extends StatelessWidget {
  final ClientModel? client;

  const CustomModalClient({this.client, Key? key}) : super(key: key);

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
                        FirebaseData().addClient(
                            constTrainerId,
                            ClientModel(
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
                              isTeenage:
                                  context.read<ClientScreenModel>().isTeenage,
                              isDiscount:
                                  context.read<ClientScreenModel>().isDiscount,
                            ));
                        Navigator.pop(context);
                        ClientListRepository().init();
                      },
                      child: Text('Добавить'))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              FirebaseData().delClient(constTrainerId, client?.id ?? '');
                              Navigator.pop(context);
                            }, child: Text('Удалить клиента')),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      WorkoutHistoryScreen()));
                            },
                            child: Text('История тренировок'))
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
