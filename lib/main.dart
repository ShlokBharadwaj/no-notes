import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nonotes/views/login_view.dart';
import 'package:nonotes/views/register_view.dart';
import 'package:nonotes/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  devtools.log("main() called");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
      '/notes': (context) => const NotesView(),
      '/verify-email': (context) => const VerifyEmailView(),
    },
    // darkTheme: ThemeData.dark(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (user != null) {
              if (user.emailVerified) {
                return const NotesView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

enum MenuAction { logout, deleteUser }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (action) async {
              if (action == MenuAction.logout) {
                if (await showLogoutDialog(context)) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushReplacementNamed('/login');
                }
              }
              if (action == MenuAction.deleteUser) {
                if (await showDeleteUserDialog(context)) {
                  await FirebaseAuth.instance.currentUser?.delete();
                  Navigator.of(context).pushReplacementNamed('/register');
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text("Notes"),
            ],
          ),
        ),
      ),
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
