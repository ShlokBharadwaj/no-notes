import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nonotes/services/auth/auth_exception.dart';
import 'package:nonotes/services/auth/bloc/auth_bloc.dart';
import 'package:nonotes/services/auth/bloc/auth_event.dart';
import 'package:nonotes/services/auth/bloc/auth_state.dart';
import 'package:nonotes/utilities/dialogs/error_dialogs.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email already in use');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Registration error');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid email');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Register")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    context.read<AuthBloc>().add(
                          AuthEventRegister(
                            _email.text,
                            _password.text,
                          ),
                        );
                  },
                  child: const Text('Register'),
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
                    },
                    child: const Text("Already Registered? Login here!"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
