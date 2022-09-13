import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/auth_user.dart';
import 'package:nonotes/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  @override
  final AuthProvider provider;

  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(
        FirebaseAuthProvider(),
      );

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) {
    return provider.createUser(
      email: email,
      password: password,
    );
  }

  Future<AuthUser> deleteUser() {
    return provider.deleteUser();
  }

  @override
  // TODO: implement currenUser
  AuthUser? get currenUser => provider.currenUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    return provider.logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() {
    return provider.logOut();
  }

  @override
  Future<void> sendEmailVerification() {
    return provider.sendEmailVerification();
  }

  @override
  Future<void> initialize() {
    return provider.initialize();
  }
}
