import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/screens/client_screen/bloc/client_screen_bloc.dart';
import 'package:workout_done/screens/client_screen/client_screen.dart';
import 'package:workout_done/screens/client_screen/client_screen_model.dart';

MaterialPageRoute clientScreenRoute () {
  return MaterialPageRoute(builder: (_) => ClientScreenInit());
}
class ClientScreenInit extends StatelessWidget {
  const ClientScreenInit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientScreenBloc(),
      child: ChangeNotifierProvider<ClientScreenModel>(
          create: (_) => ClientScreenModel(),
          child: ClientScreen()),
    );
  }
}
