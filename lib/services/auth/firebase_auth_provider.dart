import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:nonotes/firebase_options.dart';
import 'package:nonotes/services/auth/auth_provider.dart';
import 'package:nonotes/services/auth/auth_exception.dart';
import 'package:nonotes/services/auth/auth_user.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException("User not logged in");
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseException(e.message ?? "Error");
    } catch (_) {
      throw NonFirebaseException("Error: ${_.toString()}");
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException("User not logged in");
      }
    } on FirebaseAuthException catch (e) {
      throw FirebaseException(e.message ?? "Error");
    } catch (_) {
      throw NonFirebaseException("Error: ${_.toString()}");
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException("User not logged in");
    }
  }

  @override
  Future<AuthUser> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
      return AuthUser.fromFirebase(user);
    } else {
      throw UserNotLoggedInAuthException("User not logged in");
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException("User not logged in");
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    final _email = FirebaseAuth.instance.currentUser?.email ?? email;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _email);
  }
}
