abstract class AuthState {}

class InitialAuthState extends AuthState {}

class SignInValidState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errormessage;

  AuthErrorState(this.errormessage);
}

class AuthLoadingState extends AuthState{}
