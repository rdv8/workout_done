abstract class SignInScreenEvent {}

class InitialSignInScreenEvent extends SignInScreenEvent {}

class RegistrySignInScreenEvent extends SignInScreenEvent {
  final String email;
  final String password;

  RegistrySignInScreenEvent({
    required this.email,
    required this.password,
  });
}
class LoginSignInScreenEvent extends SignInScreenEvent {
  final String email;
  final String password;

  LoginSignInScreenEvent({
    required this.email,
    required this.password,
  });
}
