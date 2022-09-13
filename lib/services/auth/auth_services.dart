import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/auth_user.dart';

class AuthService implements AuthProvider {
  @override
  final AuthProvider provider;

  const AuthService(this.provider);

  @override
  Future<AuthUser> createUser(
      {required String email, required String password}) {
    // TODO: implement createUser
    throw UnimplementedError();
  }

  @override
  // TODO: implement currenUser
  AuthUser? get currenUser => throw UnimplementedError();

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    // TODO: implement logIn
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }
}
