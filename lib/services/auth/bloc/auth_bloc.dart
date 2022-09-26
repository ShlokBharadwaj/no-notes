import 'package:bloc/bloc.dart';
import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';
import 'package:nonotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateUninitialized()) {
    // Send email Verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    // Registration
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          await provider.createUser(
            email: event.email,
            password: event.password,
          );
          await provider.sendEmailVerification();
          emit(
            const AuthStateNeedsEmailVerification(),
          );
        } on Exception catch (e) {
          emit(AuthStateRegistering(e));
        }
      },
    );

    // Initialization
    on<AuthEventInitialize>(((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut(null));
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsEmailVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    }));
    on<AuthEventLogIn>((event, emit) async {
      // emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(const AuthStateNeedsEmailVerification());
        } else {
          emit(AuthStateLoggedIn(user));
        }
      } on Exception catch (e) {
        emit(AuthStateLoggedOut(e));
      }
    });
    on<AuthEventLogOut>((event, emit) async {
      emit(const AuthStateUninitialized());
      try {
        await provider.logOut();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateLogOutFailure(e));
      }
    });
    on<AuthEventDeleteUser>((event, emit) async {
      emit(const AuthStateUninitialized());
      try {
        await provider.deleteUser();
        emit(const AuthStateLoggedOut(null));
      } on Exception catch (e) {
        emit(AuthStateDeleteUserFailure(e));
      }
    });
  }
}
