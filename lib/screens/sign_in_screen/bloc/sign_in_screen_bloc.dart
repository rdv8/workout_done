import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_done/network/firebase_auth.dart';
import 'package:workout_done/network/firebase_data.dart';
import 'package:workout_done/repository/trainer_repository.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_event.dart';
import 'package:workout_done/screens/sign_in_screen/bloc/sign_in_screen_state.dart';

class SignInScreenBloc extends Bloc<SignInScreenEvent, SignInScreenState> {
  FirebaseAuthorization _firebaseAuthorization;
  FirebaseData _firebaseData;
  TrainerRepository _trainerRepository;

  SignInScreenBloc({
    required firebaseAuthorization,
    required firebaseData,
    required trainerRepository,
  })
      : _firebaseAuthorization = firebaseAuthorization,
        _firebaseData = firebaseData,
        _trainerRepository = trainerRepository,
        super(InitialSignInScreenState()) {
    on<RegistrySignInScreenEvent>(_registry);
    on<LoginSignInScreenEvent>(_login);
  }

  Future<void> _registry(RegistrySignInScreenEvent event,
      Emitter<SignInScreenState> emit) async {
    if (event.email.isNotEmpty && event.password.isNotEmpty)
      try {
        final UserCredential response = await _firebaseAuthorization
            .registerTrainer(email: event.email, password: event.password);

        await _firebaseData.addTrainer(user: response.user,);

        _trainerRepository.initTrainer(user: response.user);

        emit(SuccessSignInScreenState());
      } catch (e, trace) {
        emit(ErrorSignInScreenState(error: e));
        print('________________$trace');
      }
  }

  Future<void> _login(LoginSignInScreenEvent event,
      Emitter<SignInScreenState> emit) async {
    if (event.email.isNotEmpty && event.password.isNotEmpty)
      try {
        final UserCredential response = await _firebaseAuthorization
            .signInWithEmailAndPassword(
            email: event.email, password: event.password);

        _trainerRepository.initTrainer(user: response.user);
        emit(SuccessSignInScreenState());
      } catch (e, trace) {
        emit(ErrorSignInScreenState(error: e));
        print('________________$trace');
      }
  }
}
