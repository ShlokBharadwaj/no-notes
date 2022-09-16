import 'package:flutter/material.dart';
import 'package:nonotes/constants/routes.dart';
import 'package:nonotes/enums/menu_action.dart';
import 'package:nonotes/services/auth/auth_services.dart';
import 'package:nonotes/services/crud/notes_services.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  // @override
  // void dispose() {
  //   _notesService.close();
  //   super.dispose();
  // }

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
                  Navigator.of(context).pushReplacementNamed(loginRoute);
                }
              }
              if (action == MenuAction.deleteUser) {
                if (await showDeleteUserDialog(context)) {
                  await AuthService.firebase().deleteUser();
                  Navigator.of(context).pushReplacementNamed(registerRoute);
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                      if (snapshot.hasData) {
                        final allNotes = snapshot.data as List<DatabaseNote>;
                        return ListView.builder(
                          itemCount: allNotes.length,
                          itemBuilder: (context, index) {
                            final note = allNotes[index];
                            return ListTile(
                              title: Text(
                                note.text,
                                maxLines: 1,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
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
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(newNotesRoute);
          },
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Logout"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}

Future<bool> showDeleteUserDialog(BuildContext context) async {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete your user?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Delete User"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
