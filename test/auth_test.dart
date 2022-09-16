import 'package:nonotes/services/auth/auth_exception.dart';
import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

// TODO: Run failed tests again after fixing them
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

    // test('Should be able to log in', () async {
    //   final user = await provider.logIn(
    //     email: 'shlok@gmail.com',
    //     password: 'password',
    //   );
    //   expect(user, isNotNull);
    // });

    test('Create user should delegate to login', () async {
      final badEmailUser = provider.createUser(
        email: 'shlok@mail.com',
        password: '123456',
      );
      expect(badEmailUser, throwsA(const TypeMatcher<FirebaseException>()));

      final badPasswordUser = provider.createUser(
        email: 'shlok@gmail.com',
        password: 'badPass',
      );
      expect(badPasswordUser, throwsA(const TypeMatcher<FirebaseException>()));

      final user = await provider.createUser(
        email: 'test@gmail.in',
        password: 'test',
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('Should be able to delete user', () async {
      await provider.deleteUser();
      expect(provider.isInitialized, true);
    });

    test('Logged in user should be able to get verified', () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('Should be able to log out', () async {
      await provider.logOut();
      expect(provider.isInitialized, true);
    });

    test('Should be able to logout and login again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'nope',
        password: 'nopeAgain',
      );
      expect(provider.currentUser, isNull);
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
    if (email == 'shlok@mail.com') throw FirebaseException('Email Error');
    if (password == 'password') throw FirebaseException('Password Error');
    const user = AuthUser(
      email: 'shlok@mail.com',
      isEmailVerified: false,
    );
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
    const newUser = AuthUser(
      isEmailVerified: true,
      email: 'shlok@mail.com',
    );
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
