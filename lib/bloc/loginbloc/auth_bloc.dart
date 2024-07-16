import 'package:chatify/bloc/loginbloc/auth_event.dart';
import 'package:chatify/bloc/loginbloc/auth_state.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Bloc class to handle authentication events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(InitialAuthState()) {
//
    on<SigninCredential>((event, emit) {
      if (EmailValidator.validate(event.emailValue) == false) {
        emit(AuthErrorState("Enter valid e-mail"));
      } else if (event.passwordValue.length < 8) {
        emit(AuthErrorState("Password must be at least 8 characters"));
      } else {
        emit(SignInValidState());
      }
    });

    on<LoggedIn>((event, emit) async {
      emit(AuthLoadingState());
    });
  }
}
