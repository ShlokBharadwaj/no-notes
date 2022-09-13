import 'package:nonotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currenUser;
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  Future<AuthUser> deleteUser();
  Future<void> logOut();
  Future<void> sendEmailVerification();
}
