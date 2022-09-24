import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nonotes/services/cloud/cloud_note.dart';
import 'package:nonotes/services/cloud/cloud_storage_constants.dart';
import 'package:nonotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } on FirebaseException catch (_) {
      throw const CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
      });
    } on FirebaseException catch (_) {
      throw const CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((
            doc,
          ) =>
              CloudNote.fromSnapshot(doc))
          .where(
            (note) => note.ownerUserId == ownerUserId,
          ));

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw const CouldNotGetAllNotesException();
    }
  }

  Future<CloudNote> createNewNote({
    required String ownerUserId,
    // required String text,
  }) async {
    final document = await notes.add(
      {
        ownerUserIdFieldName: ownerUserId,
        textFieldName: '',
      },
    );
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}