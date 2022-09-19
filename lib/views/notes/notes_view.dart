import 'package:flutter/material.dart';
import 'package:nonotes/constants/routes.dart';
import 'package:nonotes/enums/menu_action.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/services/crud/notes_services.dart';
import 'package:nonotes/utilities/dialogs/delete_user_dialog.dart';
import 'package:nonotes/utilities/dialogs/logout_dialog.dart';
import 'package:nonotes/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (action) async {
              if (action == MenuAction.logout) {
                if (await showLogoutDialog(context)) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
              }
              if (action == MenuAction.deleteUser) {
                if (await showDeleteUserDialog(context)) {
                  await AuthService.firebase().deleteUser();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(registerRoute, (_) => false);
                }
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: MenuAction.logout,
                child: Text("Logout"),
              ),
              const PopupMenuItem(
                value: MenuAction.deleteUser,
                child: Text("Delete User"),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as List<DatabaseNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(
                      id: note.id,
                    );
                  },
                  onTap: (note) async {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNotesRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(createOrUpdateNotesRoute);
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
