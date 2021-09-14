import 'package:flutter/material.dart';
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
              title: Center(child: Text('${index + 1} Client')),
            ),
          ),
          TextButton(
            onPressed: () {
              showCustomModalBottomSheet(context: context,body: CustomModalAddClient());
            },
            child: Text('Добавить клиента'),
          ),
        ],
      ),
    );
  }
}


class CustomModalAddClient extends StatelessWidget {
  const CustomModalAddClient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: MediaQuery.of(context).size.height / 2,
      child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          Text(
            'Добавить клиента',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Divider(
            color: Colors.blue.shade300,
            height: 20,
            thickness: 2,
            indent: 50,
            endIndent: 50,
          ),
          TextFormField(decoration: InputDecoration(hintText: 'Фамилия'),),
          TextFormField(decoration: InputDecoration(hintText: 'Имя'),),
          CheckBoxRow(title: 'Сплит', ),
          CheckBoxRow(title: 'Подросток'),
          CheckBoxRow(title: 'Скидка'),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: (){}, child: Text('Добавить')),



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
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.title),
        const SizedBox(width: 8,),
        Checkbox(value: _value, onChanged: (newValue){setState(() {
          _value = newValue ?? false;
        });}),
      ],
    )
    ;
  }
}
