import 'package:flutter/material.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/services/crud/notes_services.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    if (_note == null) {
      return;
    } else {
      await _notesService.updateNote(
        note: _note!,
        text: _textEditingController.text,
      );
    }
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

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

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if (note != null && _textEditingController.text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: _textEditingController.text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextIsNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Note"),
        ),
        body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _note = snapshot.data as DatabaseNote; // add ! to remove RSOD
                _setupTextControllerListener();
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    autofocus: true,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Start typing...",
                    ),
                  ),
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ));
  }
}
