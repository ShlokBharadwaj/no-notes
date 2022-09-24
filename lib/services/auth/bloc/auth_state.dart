import 'package:flutter/foundation.dart' show immutable;
import 'package:nonotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLoginFailure extends AuthState {
  final Exception exception;
  const AuthStateLoginFailure(this.exception);
}

class AuthStateNeedsEmailVerification extends AuthState {
  const AuthStateNeedsEmailVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogOutFailure(this.exception);
}

class AuthStateSignUpFailure extends AuthState {
  final Exception exception;
  const AuthStateSignUpFailure(this.exception);
}

class AuthStateEmailVerificationFailure extends AuthState {
  final Exception exception;
  const AuthStateEmailVerificationFailure(this.exception);
}

class AuthStateEmailVerificationSuccess extends AuthState {
  const AuthStateEmailVerificationSuccess();
}

class AuthStatePasswordResetFailure extends AuthState {
  final Exception exception;
  const AuthStatePasswordResetFailure(this.exception);
}

class AuthStatePasswordResetSuccess extends AuthState {
  const AuthStatePasswordResetSuccess();
}

class AuthStateDeleteUserFailure extends AuthState {
  final Exception exception;
  const AuthStateDeleteUserFailure(this.exception);
}

class AuthStateDeleteUserSuccess extends AuthState {
  const AuthStateDeleteUserSuccess();
}

class AuthStateEmailVerificationResendFailure extends AuthState {
  final Exception exception;
  const AuthStateEmailVerificationResendFailure(this.exception);
}

class AuthStateEmailVerificationResendSuccess extends AuthState {
  const AuthStateEmailVerificationResendSuccess();
}
