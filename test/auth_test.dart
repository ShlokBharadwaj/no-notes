import 'package:nonotes/services/auth/auth_exception.dart';
import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('Can\'t logout if not initialized', () {
      expect(() => provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedException>()));
    });

    test('Should be able to initialize', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('User should be null after initialization', () {
      expect(provider.currentUser, isNull);
    });

    test('Should be able to initialize in less than 2 seconds', () async {
      final stopwatch = Stopwatch()..start();
      await provider.initialize();
      expect(stopwatch.elapsedMilliseconds, lessThan(2000));
    });

    test('Should be able to log in', () async {
      final user = await provider.logIn(
        email: 'shlok@gmail.com',
        password: 'password',
      );
      expect(user, isNotNull);
    });

    test('Should be able to log out', () async {
      await provider.logOut();
      expect(provider.isInitialized, true);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  AuthUser? _user;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(milliseconds: 1000));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<AuthUser> deleteUser() {
    if (!isInitialized) throw NotInitializedException();
    _user = null;
    return Future.value(_user);
  }

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'shlok@gmail.com') throw FirebaseException('Email Error');
    if (password == 'password') throw FirebaseException('Password Error');
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw FirebaseException("User not logged in");
    await Future.delayed(const Duration(milliseconds: 1000));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw FirebaseException("User not logged in");
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw FirebaseException("User not logged in");
    return Future.value();
  }
}
