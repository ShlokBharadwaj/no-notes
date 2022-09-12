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
              }
              // TODO: Uncomment and rectify verify email view
              // else {
              //   return const VerifyEmailView();
              // }
            } else {
              return const LoginView();
            }
            return const NotesView();
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
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
              }
              if (action == MenuAction.deleteUser) {
                await FirebaseAuth.instance.currentUser!.delete();
                Navigator.of(context).pushReplacementNamed('/register');
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
