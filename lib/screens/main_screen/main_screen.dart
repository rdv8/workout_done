import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_done/screens/client_screen/client_screen.dart';
import 'package:workout_done/screens/statistic_screen/statistic_screen.dart';
import 'package:workout_done/screens/widgets/custom_modal_bottom_sheet.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          drawerScrimColor: Colors.black.withOpacity(0.6),
          backgroundColor: Colors.blue,
          drawer: _CustomDrawer(),
          appBar: _CustomAppBar(),
          body: _Body(),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({Key? key}) : super(key: key);

  @override
  AppBar build(BuildContext context) {
    /// Проверить свойство в AppBar'e
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));
    return AppBar(
      elevation: 30,
      centerTitle: true,
      actions: [
        _DateButton(),
      ],
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
          child: ListView.builder(
            //shrinkWrap: true,
            padding: EdgeInsets.symmetric(vertical: 15),
            itemCount: 20,
            itemBuilder: (context, index) => GestureDetector(
              onTap: (){print('$index');},
              child: ListTile(
                title: Center(child: Text('${index + 1}. Тренировка(сплит)')),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 28,bottom: 28),
            child: FloatingActionButton(
              backgroundColor: Colors.blue.shade700,
              child: Icon(Icons.add),
              onPressed: () {
                showCustomModalBottomSheet(context: context, body: CustomModalAddWorkout());
              },),
          ),
        )
        /*const SizedBox(
          height: kToolbarHeight,
        ),*/
      ],
    );
  }
}

class _DateButton extends StatefulWidget {
  const _DateButton({Key? key}) : super(key: key);

  @override
  __DateButtonState createState() => __DateButtonState();
}

class __DateButtonState extends State<_DateButton> {
  DateTime _pickedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              _pickedDate = _pickedDate.subtract(Duration(days: 1));
              setState(() {});
            },
            child: Icon(
              Icons.arrow_left,
              size: 32,
            )),
        TextButton(
          onPressed: () async {
            await showDatePicker(
                    context: context,
                    initialDate: _pickedDate,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2030))
                .then((value) => _pickedDate = value ?? _pickedDate);
            setState(() {});
          },
          child: Text(
            '${_pickedDate.toString().substring(0, 10)}',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        GestureDetector(
            onTap: () {
              _pickedDate = _pickedDate.add(Duration(days: 1));
              setState(() {});
            },
            child: Icon(
              Icons.arrow_right,
              size: 32,
            )),
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
              Text(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ClientScreen()));
                  },
                  child: Row(
                    children: [
                      Icon(Icons.wc),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('Клиенты'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
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
                      Text(
                        'Статистика',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('Выход'),
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
            'Выберите клиента',
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
              itemCount: 15,
              itemBuilder: (context, index) => TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  print('${index + 1}. Клиент');
                },
                child: Text(
                  '${index + 1}. Клиент',
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
