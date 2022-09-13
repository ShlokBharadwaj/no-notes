// Non firebase exceptions

class NonFirebaseException implements Exception {
  final String message;

  NonFirebaseException(this.message);

  @override
  String toString() => message;
}

class UserNotLoggedInException implements Exception {
  final String message;

  UserNotLoggedInException(this.message);

  @override
  String toString() => message;
}

// Firebase exceptions

class FirebaseException implements Exception {
  final String message;

  FirebaseException(this.message);

  @override
  String toString() => message;
}
