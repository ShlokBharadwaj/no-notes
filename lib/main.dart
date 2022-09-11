import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            // case ConnectionState.done:
            //   return Column(
            //     children: [
            //       TextField(
            //         controller: _email,
            //         enableSuggestions: false,
            //         autocorrect: false,
            //         keyboardType: TextInputType.emailAddress,
            //         decoration: const InputDecoration(
            //           hintText: "Email",
            //         ),
            //       ),
            //       TextField(
            //         controller: _password,
            //         obscureText: true,
            //         enableSuggestions: false,
            //         autocorrect: false,
            //         decoration: const InputDecoration(
            //           hintText: "Password",
            //         ),
            //       ),
            //       TextButton(
            //         onPressed: () async {
            //           final email = _email.text;
            //           final password = _password.text;
            //           try {
            //             final UserCredential = await FirebaseAuth.instance
            //                 .createUserWithEmailAndPassword(
            //               email: email,
            //               password: password,
            //             );
            //             print(UserCredential);
            //           } on FirebaseAuthException catch (e) {
            //             print(e);
            //           }
            //         },
            //         child: const Text("Register"),
            //       ),
            //     ],
            //   );
            default:
              {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _email,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _password,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: _email.text,
                                      password: _password.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('User registered'),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.message ?? 'Error'),
                                ),
                              );
                            }
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  );
                }
              }
          }
        },
      ),
    );
  }
}
