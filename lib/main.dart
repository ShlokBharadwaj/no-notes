import 'package:flutter/material.dart';
import 'package:nonotes/views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: const LoginView(),
    // darkTheme: ThemeData.dark(),
  ));
}
