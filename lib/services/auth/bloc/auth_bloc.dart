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
    on<AuthEventInitialize>(
      ((event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsEmailVerification());
        } else {
          emit(AuthStateLoggedIn(user: user));
        }
      }),
    );

    // Login
    on<AuthEventLogIn>((event, emit) async {
      emit(
        const AuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user = await provider.logIn(
          email: email,
          password: password,
        );
        if (!user.isEmailVerified) {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(
            const AuthStateNeedsEmailVerification(),
          );
        } else {
          emit(
            const AuthStateLoggedOut(
              exception: null,
              isLoading: false,
            ),
          );
          emit(AuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(exception: e, isLoading: false),
        );
      }
    });

    // Logout
    on<AuthEventLogOut>((event, emit) async {
      try {
        await provider.logOut();
        emit(
          const AuthStateLoggedOut(
            exception: null,
            isLoading: false,
          ),
        );
      } on Exception catch (e) {
        emit(
          AuthStateLoggedOut(
            exception: e,
            isLoading: false,
          ),
        );
      }
    });

    // Delete user
    on<AuthEventDeleteUser>((event, emit) async {
      try {
        await provider.deleteUser();
        emit(
          const AuthStateDeleteUser(),
        );
      } on Exception catch (e) {
        emit(
          AuthStateDeleteUserFailure(e),
        );
      }
    });
  }
}
