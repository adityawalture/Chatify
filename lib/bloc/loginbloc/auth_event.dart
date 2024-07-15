abstract class AuthEvent {}

class SigninCredential extends AuthEvent {
  final String emailValue;
  final String passwordValue;

  SigninCredential(this.emailValue, this.passwordValue);
}

class LoggedIn extends AuthEvent{
  final String email;
  final String password;

  LoggedIn(this.email, this.password);
}
