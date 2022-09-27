import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter/material.dart';
import 'package:nonotes/services/auth/auth_user.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = 'Please wait a moment',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({
    required bool isLoading,
  }) : super(
          isLoading: isLoading,
        );
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required isLoading,
  }) : super(
          isLoading: isLoading,
        );
}

class AuthStateNeedsEmailVerification extends AuthState {
  const AuthStateNeedsEmailVerification({required isLoading})
      : super(
          isLoading: isLoading,
        );
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(
          isLoading: isLoading,
        );
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}

class AuthStateDeleteUser extends AuthState {
  const AuthStateDeleteUser({required isLoading})
      : super(
          isLoading: isLoading,
        );
}

class AuthStateDeleteUserFailure extends AuthState {
  final Exception exception;
  const AuthStateDeleteUserFailure(
      {required this.exception, required isLoading})
      : super(
          isLoading: isLoading,
        );
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
