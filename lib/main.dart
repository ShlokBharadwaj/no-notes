import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonotes/constants/routes.dart';
import 'package:nonotes/services/auth/bloc/auth_bloc.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';
import 'package:nonotes/services/auth/bloc/auth_state.dart';
import 'package:nonotes/services/auth/firebase_auth_provider.dart';
import 'package:nonotes/views/login_view.dart';
import 'package:nonotes/views/notes/create_update_note_view.dart';
import 'package:nonotes/views/notes/notes_view.dart';
import 'package:nonotes/views/register_view.dart';
import 'package:nonotes/views/verify_email_view.dart';
// import 'dart:developer' as devtools show log;

void main() {
  // devtools.log("main() called");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'No Notes',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      loginRoute: (context) => const LoginView(),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      createOrUpdateNotesRoute: (context) => const CreateUpdateNoteView(),
    },
    // darkTheme: ThemeData.dark(),
  ));
}

// typo

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsEmailVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
