// login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// register exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

// Non firebase exceptions

class NonFirebaseException implements Exception {
  final String message;

  NonFirebaseException(this.message);

  @override
  String toString() => message;
}

// class UserNotLoggedInAuthException implements Exception {
//   final String message;

//   UserNotLoggedInAuthException(this.message);

//   @override
//   String toString() => message;
// }

// Firebase exceptions

class FirebaseException implements Exception {
  final String message;

  FirebaseException(this.message);

  @override
  String toString() => message;
}
