import 'package:bloc/bloc.dart';
import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';
import 'package:nonotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()) {
    on<AuthEventInitialize>(((event, emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if (user == null) {
        emit(const AuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AuthStateNeedsEmailVerification());
      } else {
        emit(AuthStateLoggedIn(user));
      }
    }));
  }
}
