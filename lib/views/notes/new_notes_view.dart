import 'package:flutter/material.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/services/crud/notes_services.dart';

class NewNotesView extends StatefulWidget {
  const NewNotesView({super.key});

  @override
  State<NewNotesView> createState() => _NewNotesViewState();
}

class _NewNotesViewState extends State<NewNotesView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final owner = await _notesService.getUser(
      email: currentUser.email!,
    );
    return await _notesService.createNote(
      owner: owner,
    );
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (note != null && _textEditingController.text.isEmpty) {
      await _notesService.deleteNote(
        id: note.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
      ),
      body: const Center(
        child: Text("Write your new note here..."),
      ),
    );
  }
}