import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:workout_done/constants/app_theme.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_bloc.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_event.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_state.dart';
import 'package:workout_done/screens/sign_in_screen/sign_in_screen_model.dart';
import 'package:workout_done/screens/widgets/text_form_field.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInScreenBloc, SignInScreenState>(
      listener: (context, state) {
        if (state is ErrorSignInScreenState) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('${state.error}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ));
        }
      },
      builder: (context, state) => Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.darkColor, Colors.black]),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Workout Done!',
                  style: TextStyle(
                    fontSize: 48,
                    color: AppColors.darkColor,
                  ),
                ),
                const SizedBox(
                  height: 200,
                ),
                Column(
                  children: [
                    CustomTextFormField(
                      controller:
                          context.read<SignInScreenModel>().emailController,
                      hintText: 'Email',
                      isObscure: false,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextFormField(
                      controller: context
                          .read<SignInScreenModel>()
                          .passwordController,
                      hintText: 'Password',
                      isObscure: true,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      context.read<SignInScreenBloc>().add(
                            LoginSignInScreenEvent(
                              email: context
                                  .read<SignInScreenModel>()
                                  .emailController
                                  .text,
                              password: context
                                  .read<SignInScreenModel>()
                                  .passwordController
                                  .text,
                            ),
                          );
                    },
                    child: const Text(
                      'Enter',
                      style:
                          TextStyle(color: AppColors.lightColor, fontSize: 20),
                    )),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SignInScreenBloc>().add(
                          RegistrySignInScreenEvent(
                            email: context
                                .read<SignInScreenModel>()
                                .emailController
                                .text,
                            password: context
                                .read<SignInScreenModel>()
                                .passwordController
                                .text,
                          ),
                        );
                  },
                  child: const Text(
                    'Зарегистрироваться и войти',
                    style: TextStyle(color: AppColors.greenColor),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
