abstract class SignInScreenState {
}

class InitialSignInScreenState extends SignInScreenState {}

class SuccessSignInScreenState extends SignInScreenState {}
class ErrorSignInScreenState extends SignInScreenState {
  final Object error;

  ErrorSignInScreenState({required this.error});
}