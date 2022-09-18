import 'package:flutter/foundation.dart';
import 'package:nonotes/services/cloud/cloud_storage_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    // required this.createdAt,
    // required this.updatedAt,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName] as String,
        text = snapshot.data()[textFieldName] as String;
}
