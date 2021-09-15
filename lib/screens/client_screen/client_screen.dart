import 'package:flutter/material.dart';
import 'package:workout_done/screens/client_screen/workout_history_screen/workout_history_screen.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';

class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

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
            itemCount: 10,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                showCustomModalBottomSheet(
                    context: context,
                    body: CustomModalClient(
                      index: index + 1,
                    ));
              },
              title: Center(child: Text('${index + 1} Client')),
            ),
          ),
          TextButton(
            onPressed: () {
              showCustomModalBottomSheet(
                  context: context, body: CustomModalClient());
            },
            child: Text('Добавить клиента'),
          ),
        ],
      ),
    );
  }
}

class CustomModalClient extends StatelessWidget {
  final int? index;

  const CustomModalClient({this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController lastnameTextController = TextEditingController();
    TextEditingController nameTextController = TextEditingController();
    FocusNode nameFocusNode = FocusNode();
    FocusNode lastnameFocusNode = FocusNode();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            index == null ? 'Добавить клиента' : "Клиент $index",
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
            focusNode: nameFocusNode,
            controller: lastnameTextController,
            decoration: InputDecoration(hintText: 'Фамилия'),
          ),
          TextFormField(
            focusNode: lastnameFocusNode,
            controller: nameTextController,
            decoration: InputDecoration(hintText: 'Имя'),
          ),
          CheckBoxRow(
            title: 'Сплит',
          ),
          CheckBoxRow(title: 'Подросток'),
          CheckBoxRow(title: 'Скидка'),
          index == null
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Divider(
                      thickness: 3,
                      color: Colors.black26,
                    ),
                    CheckBoxRow(title: 'Скрыть клиeнта'),
                  ],
                ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: index == null
                  ? ElevatedButton(onPressed: () {}, child: Text('Добавить'))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                            onPressed: () {}, child: Text('Удалить клиента')),
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

  const CheckBoxRow({required this.title, Key? key}) : super(key: key);

  @override
  _CheckBoxRowState createState() => _CheckBoxRowState();
}

class _CheckBoxRowState extends State<CheckBoxRow> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        const SizedBox(
          width: 8,
        ),
        Checkbox(
            value: _value,
            onChanged: (newValue) {
              setState(() {
                _value = newValue ?? false;
              });
            }),
      ],
    );
  }
}
