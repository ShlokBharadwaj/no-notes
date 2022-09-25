import 'package:flutter/foundation.dart' show immutable;
import 'package:nonotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateNeedsEmailVerification extends AuthState {
  const AuthStateNeedsEmailVerification();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoggedOut extends AuthState {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
}

class AuthStateDeleteUser extends AuthState {
  const AuthStateDeleteUser();
}

class AuthStateDeleteUserFailure extends AuthState {
  final Exception exception;
  const AuthStateDeleteUserFailure(this.exception);
}

// class AuthStateSignUpFailure extends AuthState {
//   final Exception exception;
//   const AuthStateSignUpFailure(this.exception);
// }

// class AuthStateEmailVerificationFailure extends AuthState {
//   final Exception exception;
//   const AuthStateEmailVerificationFailure(this.exception);
// }

// class AuthStateEmailVerificationSuccess extends AuthState {
//   const AuthStateEmailVerificationSuccess();
// }

// class AuthStatePasswordResetFailure extends AuthState {
//   final Exception exception;
//   const AuthStatePasswordResetFailure(this.exception);
// }

// class AuthStatePasswordResetSuccess extends AuthState {
//   const AuthStatePasswordResetSuccess();
// }

// class AuthStateEmailVerificationResendFailure extends AuthState {
//   final Exception exception;
//   const AuthStateEmailVerificationResendFailure(this.exception);
// }

// class AuthStateEmailVerificationResendSuccess extends AuthState {
//   const AuthStateEmailVerificationResendSuccess();
// }
