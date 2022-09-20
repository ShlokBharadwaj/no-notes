import 'package:flutter/material.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/utilities/generics/get_arguments.dart';
import 'package:nonotes/services/cloud/cloud_note.dart';
import 'package:nonotes/services/cloud/firebase_cloud_storage.dart';
import 'package:nonotes/services/cloud/cloud_storage_exceptions.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textEditingController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    if (_note == null) {
      return;
    }
    await _notesService.updateNote(
      documentId: _note!.documentId,
      text: _textEditingController.text,
    );
  }

  void _setupTextControllerListener() {
    _textEditingController.removeListener(_textControllerListener);
    _textEditingController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textEditingController.text = _note!.text;
      return _note!;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final newNote = await _notesService.createNewNote(
      ownerUserId: currentUser.id,
    );
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (note != null && _textEditingController.text.isEmpty) {
      await _notesService.deleteNote(
        documentId: note.documentId,
      );
    }
  }

  void _saveNoteIfTextIsNotEmpty() async {
    final note = _note;
    if (note != null && _textEditingController.text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share),
            )
          ],
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
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
