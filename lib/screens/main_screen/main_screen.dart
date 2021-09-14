import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      elevation: 0,
      title: Text('Workout Done!'),
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
    return Column(
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade700, width: 24),
                borderRadius: BorderRadius.circular(24)),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(20),
              itemCount: 20,
              itemBuilder: (context, index) => Text('${index + 1}. Тренировка'),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade700)),
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                          top: Radius.elliptical(160, 40))),
                  context: context,
                  builder: (context) => Container(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Клиенты',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
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
                                    print('${index + 1}. Клиент');
                                  },
                                  child: Text(
                                    '${index + 1}. Клиент',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ));
            },
            child: Text(
              'Add workout',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ),
        )
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
                Row(
                  children: [
                    Icon(Icons.wc),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Клиенты'),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
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
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    const SizedBox(
                      width: 8,
                    ),
                    Text('Выход'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
           onTap: (){
             print('left');
            },
           child: Icon(Icons.arrow_left)),
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
            style: TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap: (){
            print('right');
            },
            child: Icon(Icons.arrow_right)),
      ],
    );
  }
}
