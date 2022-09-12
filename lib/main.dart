import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: const HomePage(),
    // darkTheme: ThemeData.dark(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              {
                final user = FirebaseAuth.instance.currentUser;
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (user == null) {
                  return const Center(
                    // TODO: Handle Anonymous user here
                    child: Text('Not logged in. Anonymous'),
                  );
                } else if (user.emailVerified) {
                  return Center(
                    child: Text('Logged in as ${user.email}'),
                  );
                } else if (!user.emailVerified) {
                  return const Center(
                    child: Text(
                        'Email not verified. You need to verify your email first.'),
                  );
                } else {
                  return const Center(
                    child: Text('Done'),
                  );
                }
              }
            default:
              return const Text("Loading...");
          }
        },
      ),
    );
  }
}
